/**
 * 邮件插件
**/
window.cordovaCustomPlugin.Email = function () {
    /**
     * 功能:发送邮件
     * @args 数组 格式:[]
     * @success
     * @fail
    **/
    this.sendEmail = function (args, success, fail) {
        try {
            return this.executor("EmailPlugin", "send", args, success, fail);
        } catch (e) {
            throw e;
        }
    }

}
window.cordovaCustomPlugin.Email.prototype = new window.cordovaCustomPlugin.PluginBase();