/**
 * ��绰���
**/
window.cordovaCustomPlugin.Phone = function () {
    /**
     * ����:��绰
     * @args ���� ��ʽ:[]
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


