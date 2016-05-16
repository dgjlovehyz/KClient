/**
 * WebView插件
**/
window.cordovaCustomPlugin.UnionpayControlJar= function () {
    /**
     * 功能:webView
     * @args 数组 格式:[sn,serverMode]
     * @success
     * @fail
    **/
    this.pay = function (args, success, fail) {
        try {
            return this.executor("UnionpayControlJarPlugin", "pay", args, success, fail);
        } catch (e) {
            throw e;
        }
    }
}
window.cordovaCustomPlugin.UnionpayControlJar.prototype = new window.cordovaCustomPlugin.PluginBase();