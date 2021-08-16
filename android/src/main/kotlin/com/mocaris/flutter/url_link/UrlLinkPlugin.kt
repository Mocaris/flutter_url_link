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

        private var instance: UrlLinkPlugin? = null

        fun setDataUri(intent: Intent) {
            instance?.setDataUri(intent.dataString)
        }

    }

    init {
        instance = this
    }

    private var channel: MethodChannel? = null

    private var lastUri: String? = null

    private fun setDataUri(data: String?) {
        data?.let {
            this.lastUri = it
            channel?.invokeMethod("receive_uri", it)
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        instance = this
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
