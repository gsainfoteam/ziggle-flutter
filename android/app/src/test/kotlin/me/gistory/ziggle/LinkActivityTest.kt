package me.gistory.ziggle

import java.io.File
import java.net.URI
import org.junit.Assert.assertEquals
import org.junit.Test

/**
 * Checks [LinkActivity.appPath] with the links that the Dart test
 * `test/app_links_link_repository_test.dart` checks
 * `AppLinksLinkRepository.toAppPath` with, so both apps open the same links.
 */
class LinkActivityTest {
    @Test
    fun opensTheSameLinksAsDart() {
        // Gradle runs unit tests in the module directory, android/app.
        val cases = File("../../test/fixtures/app_links.tsv").readLines()
            .filter { it.isNotEmpty() && !it.startsWith("#") }
            .map { it.split('\t') }
        val failures = cases.mapNotNull { (link, expected) ->
            val path = appPath(link)
            val want = expected.takeUnless { it == "-" }
            if (path == want) null else "$link: expected $want, got $path"
        }
        assertEquals("", failures.joinToString("\n"))
    }

    /**
     * Passes the raw parts of [link], which [LinkActivity] reads from
     * `android.net.Uri`, to [LinkActivity.appPath]. A link that does not parse
     * is not opened.
     */
    private fun appPath(link: String): String? {
        val uri = runCatching { URI(link) }.getOrNull() ?: return null
        return LinkActivity.appPath(uri.scheme, uri.host, uri.rawPath, uri.rawQuery)
    }
}
