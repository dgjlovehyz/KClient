/**
 * 打电话插件
**/
window.cordovaCustomPlugin.Phone = function () {
    /**
     * 功能:打电话
     * @args 数组 格式:[]
     * @success
     * @fail
    **/
    this.dialTelephone = function (args, success, fail) {
        try {
            return this.executor("PhonePlugin", "call", args, success, fail);
        } catch (e) {
            throw e;
        }
    }
}
window.cordovaCustomPlugin.Phone.prototype = new window.cordovaCustomPlugin.PluginBase();


