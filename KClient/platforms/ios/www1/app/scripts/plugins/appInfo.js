/**
 * 网络插件
**/
window.cordovaCustomPlugin.AppInfo = function () {
    /**
     * 功能：配制信息
     * @args 
     * @success
     * @fail
    **/
    this.cfgInfo = function (args, success, fail) {
        try {
            return this.executor("AppInfoPlugin", "cfgInfo", args, success, fail);
        } catch (e) {
            throw e;
        }
    }
}
window.cordovaCustomPlugin.AppInfo.prototype = new window.cordovaCustomPlugin.PluginBase();





