/**
 * �����Ų��
**/
window.cordovaCustomPlugin.Sms = function () {
    /**
     * ����:������
     * @args ���� ��ʽ:[]
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