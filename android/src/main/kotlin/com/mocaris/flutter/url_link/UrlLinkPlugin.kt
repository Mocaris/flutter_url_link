package com.mocaris.flutter.url_link

import android.app.Application
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.annotation.NonNull
import androidx.localbroadcastmanager.content.LocalBroadcastManager

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** UrlLinkPlugin */
class UrlLinkPlugin : BroadcastReceiver(), FlutterPlugin, MethodCallHandler,
    EventChannel.StreamHandler {

    object Constant {
        //插件
        const val URL_LINK_NAME = "mocaris_url_link"

        //
        const val URL_LINK_NAME_STREAM = "mocaris_url_link_stream"

    }


    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    private var lastUrl: String? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, Constant.URL_LINK_NAME)
        channel.setMethodCallHandler(this)
        eventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, Constant.URL_LINK_NAME_STREAM).also {
                it.setStreamHandler(this)
            }
        LocalBroadcastManager.getInstance(flutterPluginBinding.applicationContext)
            .registerReceiver(this, IntentFilter(BROADCAST_ACTION))
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getLastUrl" -> {
                result.success(lastUrl)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        LocalBroadcastManager.getInstance(binding.applicationContext).unregisterReceiver(this)
    }

    override fun onReceive(context: Context?, intent: Intent) {
        if (BROADCAST_ACTION == intent.action) {
            intent.getStringExtra("data")?.let {
                this.lastUrl = it
                eventSink?.success(it)
            }
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        this.eventSink = events;
    }

    override fun onCancel(arguments: Any?) {
        this.eventSink = null
    }

}
