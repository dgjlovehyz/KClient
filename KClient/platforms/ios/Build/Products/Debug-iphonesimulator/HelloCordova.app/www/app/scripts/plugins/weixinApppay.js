/**
 * xeixin apppay插件
**/
window.cordovaCustomPlugin.WeixinAppPay = function () {
    /**
     * 功能:xeixin支付
     * @args 数组 格式:[appId,mchId,appKey,notifyUrl,outTradeNo,totalFee]
     * @success
     * @fail
    **/
    this.pay = function (args, success, fail) {
        try {
            return this.executor("WeixinAppPayPlugin", "pay", args, success, fail);
        } catch (e) {
            throw e;
        }
    }
}
window.cordovaCustomPlugin.WeixinAppPay.prototype = new window.cordovaCustomPlugin.PluginBase();