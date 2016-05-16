cordova.define("appInfo.CDVAppInfo", function(require, exports, module) {
var exec = require('cordova/exec');

exports.coolMethod = function(arg0, success, error) {
    exec(success, error, "CDVAppInfo", "coolMethod", [arg0]);
};

});
