; (function () {
    (function (context) {
        context.plugins = {
            alipay: new context.cordovaCustomPlugin.Alipay(),
            email: new context.cordovaCustomPlugin.Email(),
            file: new context.cordovaCustomPlugin.File(),
            phone: new context.cordovaCustomPlugin.Phone(),
            pictureView: new context.cordovaCustomPlugin.PictureView(),
            share: new context.cordovaCustomPlugin.Share(),
            sms: new context.cordovaCustomPlugin.Sms(),
            video: new context.cordovaCustomPlugin.Video(),
            webView: new context.cordovaCustomPlugin.WebView(),
            network: new context.cordovaCustomPlugin.Network(),
            location: new context.cordovaCustomPlugin.Location(),
            appInfo: new context.cordovaCustomPlugin.AppInfo(),
            upgrade: new context.cordovaCustomPlugin.Upgrade(),
            fileCache: new context.cordovaCustomPlugin.FileCache(),
            unionpayControlJar: new context.cordovaCustomPlugin.UnionpayControlJar(),
            weixinAppPay: new context.cordovaCustomPlugin.WeixinAppPay(),
            log: new context.cordovaCustomPlugin.Log(),
            deviceIsSupport: function () {
                if (!(context.cordovaCustomPlugin.isHasPlatformSupport())) return false;
                return true;
            }
        }
    }(window));
})();
