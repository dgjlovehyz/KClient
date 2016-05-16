/**
 * WebView插件
**/
window.cordovaCustomPlugin.WebView=function () {
    /**
     * 功能:webView
     * @args 数组 格式:[title,url]
     * @success
     * @fail
    **/
    this.loadUrl = function (args, success, fail) {
        try {
            return this.executor("WebViewPlugin", "loadUrl", args, success, fail);
        } catch (e) {
            throw e;
        }
    }
}
window.cordovaCustomPlugin.WebView.prototype = new window.cordovaCustomPlugin.PluginBase();