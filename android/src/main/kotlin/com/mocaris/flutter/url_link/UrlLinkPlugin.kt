package com.mocaris.flutter.url_link

import android.content.Intent
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** UrlLinkPlugin */
class UrlLinkPlugin : FlutterPlugin, MethodCallHandler {

    companion object {
        //插件
        const val URL_LINK_NAME = "mocaris_url_link"

        var instance: UrlLinkPlugin? = null

        fun setDataUri(intent: Intent) {
            instance?.setDataUri(intent.dataString)
        }

    }

    init {
        instance = this
    }


    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var channel: MethodChannel?=null

    private var lastUri: String? = null

    private fun setDataUri(data: String?) {
        data?.let {
            this.lastUri = it
            channel?.invokeMethod("receive_uri", it)
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, URL_LINK_NAME).also {
            it.setMethodCallHandler(this)
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getLastUri" -> {
                result.success(lastUri)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        instance = null
    }

}
