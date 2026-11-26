package me.gistory.ziggle

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle

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
        val link = intent.dataString
        if (link != null) {
            // Start MainActivity with the same intent as the launcher and carry
            // the link in an extra. If the link starts the app's task, the task
            // then looks as if the launcher started it, so tapping the app icon
            // later returns to it instead of starting another MainActivity on top
            // of a Custom Tab.
            startActivity(
                Intent(Intent.ACTION_MAIN)
                    .addCategory(Intent.CATEGORY_LAUNCHER)
                    .setClass(this, MainActivity::class.java)
                    .putExtra(EXTRA_LINK, link)
                    // Reuse the running MainActivity through onNewIntent. Anything
                    // on top of it, such as a Custom Tab, is closed so the link is
                    // shown.
                    .addFlags(
                        Intent.FLAG_ACTIVITY_NEW_TASK or
                            Intent.FLAG_ACTIVITY_CLEAR_TOP or
                            Intent.FLAG_ACTIVITY_SINGLE_TOP,
                    ),
            )
        }
        finish()
    }

    companion object {
        private const val EXTRA_LINK = "me.gistory.ziggle.LINK"

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
