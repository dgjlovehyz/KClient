window.cordovaCustomPlugin.PluginBase=function () {
    this.executor = function (pluginName, action, args, success, fail) {
        var exec = null;
        try {
            if (!(window.cordovaCustomPlugin.isHasPlatformSupport())) return false;
            exec = cordova.require('cordova/exec');
            return exec(success, fail,pluginName, action, args);
        } catch (e) {
            throw e;
        }
    }
}

   