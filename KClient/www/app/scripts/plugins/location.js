/**
 * 定位插件
**/
window.cordovaCustomPlugin.Location = function () {
    /**
     * 功能:网络定位
     * @args 数组 格式:[]
     * @success
     * @fail
    **/
    this.networkLocation = function (args, success, fail) {
        try {
            return this.executor("LocationPlugin", "networkLocation", args, success, fail);
        } catch (e) {
            throw e;
        }
    }

}
window.cordovaCustomPlugin.Location.prototype = new window.cordovaCustomPlugin.PluginBase();