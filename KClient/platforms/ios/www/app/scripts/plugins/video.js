/**
 * �������
**/
window.cordovaCustomPlugin.Video = function () {
    /**
     * ����:������
     * @args ���� ��ʽ:[]
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