/**
 * 发短信插件
**/
window.cordovaCustomPlugin.Sms = function () {
    /**
     * 功能:发短信
     * @args 数组 格式:[]
     * @success
     * @fail
    **/
    this.sendSMS = function (args, success, fail) {
        try {
            return this.executor("SMSPlugin", "send", args, success, fail);
        } catch (e) {
            throw e;
        }
    }
}
window.cordovaCustomPlugin.Sms.prototype = new window.cordovaCustomPlugin.PluginBase();