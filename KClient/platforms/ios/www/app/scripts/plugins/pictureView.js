/**
 * 图片展示插件
 * 原生插件-支持图片缩放-用于资讯&商品&相册大图展示等
 * 说明-回调函数
 * imgSuccess-图片展示成功回调
 * imgFail-图片展示失败回调
 * args说明 
 * args数组，内容为图片的URL网络路径，不限个数
**/
window.cordovaCustomPlugin.PictureView=function () {
    /**
     * 功能:图片展示
     * @args 数组 格式:[]
     * @success
     * @fail
    **/
    this.showDetailImg = function (args, success, fail) {
        try {
            return this.executor("PictureViewPlugin", "show", args, success, fail);
        } catch (e) {
            throw e;
        }
    }
}
window.cordovaCustomPlugin.PictureView.prototype = new window.cordovaCustomPlugin.PluginBase();
