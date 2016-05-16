/**
 * 网络插件
**/
window.cordovaCustomPlugin.Network = function () {
    /**
     * 功能:网络是否可用
     * @args 
     * @success
     * @fail
    **/
    this.networkIsAvailable = function (args, success, fail) {
        try {
            return this.executor("NetworkPlugin", "networkIsAvailable", args, success, fail);
        } catch (e) {
            throw e;
        }
    }
    /**
     * 功能:打开网络设置
     * @args 
     * @success
     * @fail
    **/
    this.settingNetwork = function (args, success, fail) {
        try {
            return this.executor("NetworkPlugin", "settingNetwork", args, success, fail);
        } catch (e) {
            throw e;
        }
    }
}
window.cordovaCustomPlugin.Network.prototype = new window.cordovaCustomPlugin.PluginBase();





