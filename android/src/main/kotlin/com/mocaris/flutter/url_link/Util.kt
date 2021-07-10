package com.mocaris.flutter.url_link

import android.content.Context
import android.content.Intent
import androidx.localbroadcastmanager.content.LocalBroadcastManager

const val BROADCAST_ACTION = "url_link_action"

object UrlLinkUtil {
    fun sendPlugin(context: Context, intent: Intent) {
        if(Intent.ACTION_VIEW == intent.action){
            intent.data?.let {
                val newIntent = Intent(BROADCAST_ACTION).apply {
                    this.putExtra("data", it.toString())
                }
                LocalBroadcastManager.getInstance(context).sendBroadcast(newIntent)
            }
        }
    }
}