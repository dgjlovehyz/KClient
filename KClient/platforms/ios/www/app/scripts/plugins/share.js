/**
 * shareSDK社会化分享插件
**/
window.cordovaCustomPlugin.Share=function() {
    /**
     * 功能:分享
     * @args 数组 格式:[]
     * @success
     * @fail
    **/
    this.sharePlatform = function (args, success, fail) {
        try {
            return this.executor("SharePlugin", "share", args, success, fail);
        } catch (e) {
            throw e;
        }
    }
}
window.cordovaCustomPlugin.Share.prototype = new window.cordovaCustomPlugin.PluginBase();
