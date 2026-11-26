package me.gistory.ziggle

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import java.net.URI

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
        val link = intent.data
        if (link != null && isSupported(link)) {
            // Reuse the running MainActivity through onNewIntent. Anything on top
            // of it, such as a Custom Tab, is closed so the link is shown.
            main.putExtra(EXTRA_LINK, link.toString())
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

        /** Same rule as `AppLinksLinkRepository._allowedPaths` in Dart. */
        private val NOTICE_PATH = Regex("^/notice/\\d+$")

        /**
         * Whether the app opens [link]. Must match
         * `AppLinksLinkRepository.toAppPath` in Dart, which decides the screen.
         */
        internal fun isSupported(link: Uri): Boolean {
            if (!isZiggle(link.scheme, link.host)) return false
            var path = link.encodedPath
            if (normalize(path) == "/app") {
                val redirect = link.getQueryParameter("redirect") ?: return false
                // A relative redirect resolves against the link itself.
                val target = runCatching { URI(link.toString()).resolve(redirect) }
                    .getOrNull() ?: return false
                if (!isZiggle(target.scheme, target.host)) return false
                path = target.rawPath
            }
            return NOTICE_PATH.matches(normalize(path))
        }

        private fun isZiggle(scheme: String?, host: String?) =
            scheme == "https" && host.equals(HOST, ignoreCase = true)

        /** Drops a trailing `/`. The web opens `/notice/123/` as the same page. */
        private fun normalize(path: String?): String {
            val p = path.orEmpty()
            return if (p.length > 1 && p.endsWith("/")) p.dropLast(1) else p
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
