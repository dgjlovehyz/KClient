/**
 * xeixin apppay插件
**/
window.cordovaCustomPlugin.Log = function () {
    /**
     * 功能:xeixin支付
     * @args 数组 格式:[appId,mchId,appKey,notifyUrl,outTradeNo,totalFee]
     * @success
     * @fail
    **/
    this.write = function (args, success, fail) {
        try {
            return this.executor("LogPlugin", "log", args, success, fail);
        } catch (e) {
            throw e;
        }
    }
}
window.cordovaCustomPlugin.Log.prototype = new window.cordovaCustomPlugin.PluginBase();