package me.gistory.ziggle

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import java.net.URI
import java.net.URLDecoder

/**
 * Receives App Links and forwards them to [MainActivity] in the app's own task.
 *
 * Apps such as Instagram and Google Messages open links without
 * FLAG_ACTIVITY_NEW_TASK. If MainActivity received those links directly, a
 * second MainActivity (with its own Flutter engine) would start inside the
 * caller's task. Making MainActivity singleTask would avoid that, but it would
 * also close Custom Tabs and pickers on top of it whenever the app is reopened
 * from the launcher, so MainActivity stays singleTop and links come here.
 */
class LinkActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Start MainActivity with the same intent as the launcher. If this starts
        // the app's task, the task then looks as if the launcher started it, so
        // tapping the app icon later returns to it instead of starting another
        // MainActivity on top of a Custom Tab.
        val main = Intent(Intent.ACTION_MAIN)
            .addCategory(Intent.CATEGORY_LAUNCHER)
            .setClass(this, MainActivity::class.java)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        val path = intent.data?.let { appPath(it.scheme, it.host, it.encodedPath, it.encodedQuery) }
        if (path != null) {
            // Forward the path decided here as a plain link, so Flutter opens
            // exactly the screen this activity decided to open.
            main.putExtra(EXTRA_LINK, "https://$HOST$path")
                // Reuse the running MainActivity through onNewIntent. Anything on
                // top of it, such as a Custom Tab, is closed so the link is shown.
                .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        }
        // A link the app does not open only brings the app to the front, like the
        // launcher does, and leaves the current screen as it is.
        startActivity(main)
        finish()
    }

    companion object {
        private const val EXTRA_LINK = "me.gistory.ziggle.LINK"
        private const val HOST = "ziggle.gistory.me"

        /**
         * Same rule as `AppLinksLinkRepository._allowedPaths` in Dart. `[0-9]`,
         * not `\d`, because `\d` on Android also matches non-ASCII digits.
         */
        private val NOTICE_PATH = Regex("^/notice/[0-9]+$")
        private val ESCAPE = Regex("%([0-9A-Fa-f]{2})")

        /**
         * Returns the app path to open for a link, or null if the app does not
         * open it. Takes the raw parts of the link and decodes them itself, as
         * Dart's `Uri` does, instead of relying on how `android.net.Uri`
         * decodes them. This also lets it run in JVM unit tests.
         *
         * Follows `AppLinksLinkRepository.toAppPath` in Dart, which decides the
         * screen on iOS. Both are tested with `test/fixtures/app_links.tsv`.
         */
        internal fun appPath(
            scheme: String?,
            host: String?,
            encodedPath: String?,
            encodedQuery: String?,
        ): String? {
            if (!isZiggle(scheme, host)) return null
            var path = normalize(encodedPath)
            if (path == "/app") {
                // A relative redirect resolves against the link itself.
                val target = redirect(encodedQuery)?.let {
                    runCatching { URI("https://$HOST${encodedPath.orEmpty()}").resolve(it) }.getOrNull()
                } ?: return null
                if (!isZiggle(target.scheme, target.host)) return null
                path = normalize(target.rawPath)
            }
            return path.takeIf { NOTICE_PATH.matches(it) }
        }

        /**
         * The last `redirect` value, with keys and values decoded as Dart's
         * `Uri.queryParameters` does, so `%72edirect` is also `redirect`.
         */
        private fun redirect(encodedQuery: String?): String? = encodedQuery?.split('&')
            ?.map { it.split('=', limit = 2) }
            ?.lastOrNull { decodeQuery(it[0]) == "redirect" }
            ?.let { decodeQuery(it.getOrElse(1) { "" }) }

        /** Decodes `+` as a space and `%XX` escapes. Keeps a malformed escape as it is. */
        private fun decodeQuery(s: String) =
            runCatching { URLDecoder.decode(s, "UTF-8") }.getOrDefault(s)

        private fun isZiggle(scheme: String?, host: String?) =
            scheme == "https" && host.equals(HOST, ignoreCase = true)

        /**
         * Normalizes an encoded path as Dart's `Uri` does, then drops a trailing
         * `/`, because the web opens `/notice/123/` as the same page.
         */
        private fun normalize(path: String?): String {
            val p = removeDotSegments(decodeUnreserved(path.orEmpty()))
            return if (p.length > 1 && p.endsWith("/")) p.dropLast(1) else p
        }

        /** Decodes escaped unreserved characters, such as `%31`, and keeps other escapes, such as `%2F`. */
        private fun decodeUnreserved(path: String) = ESCAPE.replace(path) { m ->
            val c = m.groupValues[1].toInt(16).toChar()
            if (c in 'A'..'Z' || c in 'a'..'z' || c in '0'..'9' || c in "-._~") c.toString() else m.value
        }

        /**
         * Removes `.` and `..` segments. A port of `Uri._removeDotSegments` in
         * Dart. `java.net.URI.normalize` differs: it keeps a `..` above the root.
         */
        private fun removeDotSegments(path: String): String {
            val output = ArrayList<String>()
            var appendSlash = false
            for (segment in path.split('/')) {
                appendSlash = false
                when (segment) {
                    ".." -> {
                        if (output.isNotEmpty()) {
                            output.removeAt(output.lastIndex)
                            if (output.isEmpty()) output.add("")
                        }
                        appendSlash = true
                    }
                    "." -> appendSlash = true
                    else -> output.add(segment)
                }
            }
            if (appendSlash) output.add("")
            return output.joinToString("/")
        }

        /**
         * Moves the link that [LinkActivity] put in an extra back to the intent
         * data, where app_links reads it.
         */
        fun restoreLink(intent: Intent): Intent {
            val link = intent.getStringExtra(EXTRA_LINK) ?: return intent
            return Intent(intent).setData(Uri.parse(link)).apply { removeExtra(EXTRA_LINK) }
        }
    }
}
