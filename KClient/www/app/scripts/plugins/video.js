/**
 * 视屏插件
**/
window.cordovaCustomPlugin.Video = function () {
    /**
     * 功能:发短信
     * @args 数组 格式:[]
     * @success
     * @fail
    **/
    this.playVideo = function (args, success, fail) {
        try {
            return this.executor("VideoPlugin", "", args, success, fail);
        } catch (e) {
            throw e;
        }
    }
}
window.cordovaCustomPlugin.Video.prototype = new window.cordovaCustomPlugin.PluginBase();