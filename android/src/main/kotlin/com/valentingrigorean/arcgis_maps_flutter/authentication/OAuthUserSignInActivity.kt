package com.valentingrigorean.arcgis_maps_flutter.authentication;

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.browser.customtabs.CustomTabsIntent
import androidx.lifecycle.Lifecycle
import com.arcgismaps.httpcore.authentication.OAuthUserSignIn

private const val CUSTOM_TABS_WAS_LAUNCHED_KEY = "KEY_INTENT_EXTRA_CUSTOM_TABS_WAS_LAUNCHED"
/**
 * An activity that is responsible for launching a CustomTabs activity and to receive and process
 * the redirect intent as a result of a user completing the CustomTabs prompt.
 */
class OAuthUserSignInActivity : AppCompatActivity() {

    companion object {
        private var pendingSignIn: OAuthUserSignIn? = null

        fun promptForOAuthUserSignIn(context: Context, oAuthUserSignIn: OAuthUserSignIn) {
            pendingSignIn = oAuthUserSignIn
            val intent = Intent(context, OAuthUserSignInActivity::class.java)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            context.startActivity(intent)
        }
    }

    private var customTabsWasLaunched = false
    private lateinit var redirectUrl: String

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // redirect URL should be a valid string since we are adding it in the ActivityResultContract
        redirectUrl = pendingSignIn!!.oAuthUserConfiguration.redirectUrl

        if (savedInstanceState != null) {
            customTabsWasLaunched = savedInstanceState.getBoolean(
                CUSTOM_TABS_WAS_LAUNCHED_KEY
            )
        }

        if (!customTabsWasLaunched) {
            val authorizeUrl = pendingSignIn!!.authorizeUrl
            authorizeUrl?.let {
                launchCustomTabs(it)
            }
        }
    }

    override fun onDestroy() {
        pendingSignIn = null
        super.onDestroy()
    }


    override fun onNewIntent(customTabsIntent: Intent) {
        super.onNewIntent(customTabsIntent)
        // get the OAuth authorized URI returned from the custom tab
        customTabsIntent.data?.let { uri ->
            // the authorization code to generate the OAuth token, for example
            // in this sample app: "my-ags-app://auth?code=<AUTHORIZED_CODE>"
            val authorizationCode = uri.toString()
            // check if the URI matches with the OAuthUserConfiguration's redirectUrl
            if (authorizationCode.startsWith(redirectUrl)) {
                complete(authorizationCode)
            } else {
                complete(null)
            }
            finish()
        }
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus && lifecycle.currentState == Lifecycle.State.RESUMED) {
            // if we got here the user must have pressed the back button or the x button while the
            // custom tab was visible - finish by cancelling OAuth sign in
            complete(null)
            finish()
        }
    }

    /**
     * Launches the custom tabs activity with the provided [authorizeUrl].
     */
    private fun launchCustomTabs(authorizeUrl: String) {
        customTabsWasLaunched = true
        val intent = CustomTabsIntent.Builder().build().apply {
            intent.data = Uri.parse(authorizeUrl)
        }
        startActivity(intent.intent)
    }

    private fun complete(redirectUri: String?) {
        pendingSignIn?.let { pendingSignIn ->
            redirectUri?.let { redirectUri ->
                pendingSignIn.complete(redirectUri)
            } ?: pendingSignIn.cancel()
        } ?: throw IllegalStateException("OAuthUserSignIn not available for completion")
    }
}