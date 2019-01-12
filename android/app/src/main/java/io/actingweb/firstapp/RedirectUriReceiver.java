package io.actingweb.firstapp;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import io.flutter.plugins.flutterauth0.FlutterAuth0Plugin;
import io.actingweb.firstapp.MainActivity;

public class RedirectUriReceiver extends Activity {

    public void onCreate(Bundle savedInstanceBundle) {
        super.onCreate(savedInstanceBundle);
        Intent intent = this.getIntent();
        Uri uri = intent.getData();
        String access_token = uri.getQueryParameter("code");
        String error = uri.getQueryParameter("error");
        FlutterAuth0Plugin.resolveWebAuthentication(access_token, error);
        Intent openMainActivity = new Intent(RedirectUriReceiver.this, MainActivity.class);
        openMainActivity.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
        startActivityIfNeeded(openMainActivity, 0);
        this.finish();
    }
}