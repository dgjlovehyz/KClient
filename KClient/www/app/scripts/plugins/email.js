/**
 * �ʼ����
**/
window.cordovaCustomPlugin.Email = function () {
    /**
     * ����:�����ʼ�
     * @args ���� ��ʽ:[]
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