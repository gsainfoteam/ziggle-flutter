package me.gistory.ziggle

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // When the activity is restored, the intent is the one that first started
        // it, so its link was already opened.
        if (savedInstanceState == null) intent = LinkActivity.restoreLink(intent)
        super.onCreate(savedInstanceState)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(LinkActivity.restoreLink(intent))
    }
}
