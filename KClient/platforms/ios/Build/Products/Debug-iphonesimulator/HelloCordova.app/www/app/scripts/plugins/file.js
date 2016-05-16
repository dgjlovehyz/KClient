/**
 * 文件插件
**/
window.cordovaCustomPlugin.File = function () {
    /**
     * 功能够:从网络上下载文件
     * 参数:
     * @srcUrl
     * @targetUrl
     * @success
     * @fail
     * 返回值:无
    **/
    this.downloadPic=function (srcUrl, targetUrl, success, fail) {
        var ft = null;
        var uri = null;
        try {
            if (!(window.cordovaCustomPlugin.isHasPlatformSupport())) return false;
            var fileTransfer = cordova.require('cordova/plugin/FileTransfer');
            ft = new fileTransfer();
            uri = encodeURI(srcUrl);
            ft.download(uri, targetUrl, function (entry) {
                if (success == null) return;
                success(entry.fullPath);
            },function (err) {
                if (fail == null) return;
                fail(err);
            });
        } catch (e) {
            throw e;
        }
    }
    /**
     * 功能:取本地已缓存的图片，如果找不到则从网络上下载
     * 参数:
     * @fileAbsolutePath 文件的URL，绝对路径
     * @success 成功回调函数 fun(imageURI){} imageURI返回的图片base64格式
     * @fail    失败回调函数 fun(err){}
     * 返回值:无
    **/
    this.localFile=function (fileAbsolutePath, success, fail) {
        var pathArray = null;
        var fileName = null;
        var _localFile = null;
        var that = this;
        try {
            if (!(window.cordovaCustomPlugin.isHasPlatformSupport())) return false;
            var requestFileSystem = cordova.require('cordova/plugin/requestFileSystem');
            var localFileSystem = cordova.require('cordova/plugin/LocalFileSystem');
            requestFileSystem(localFileSystem.PERSISTENT, 0, function (fileSystem) {
                //创建目录
                fileSystem.root.getDirectory(
                   "cn.ilanhai/",
                   { create: true },
                   function (fileEntry) {
                   },
                   function () {
                   }
                );
                //缓存文件名称处理
                pathArray = fileAbsolutePath.split("/");
                fileName = pathArray[pathArray.length - 1];
                _localFile = "cn.ilanhai/" + fileName;
                //查找文件
                fileSystem.root.getFile(
                    _localFile,
                    null,
                    function (entry) {
                        if (success == null) return;
                        success(entry.fullPath);
                    },
                    function (){
                        fileSystem.root.getFile(
                            _localFile,
                            { create: true },
                            function (entry) {
                                var targetURL = entry.toURL();
                                that.downloadPic(fileAbsolutePath, targetURL, success, fail);
                            },
                            function (err) {
                                if (fail == null) return;
                                fail(err);
                            });
                    });
            }, function (err) {
                if (fail == null) return;
                fail(err);
            });
        } catch (e) {
            throw e;
        }
    }
    /**
     * 功能:上传文件
     * 参数:
     * @imgUri  图片的URI
     * @serverUri 远程服务器的URI
     * @mimeType 上传文件的mimeType 如:图片的mime类型为image/jpeg
     * @success 成功回调函数 1-成功 0-失败 fun(res){} 
     * @fail    失败回调函数 1-成功 0-失败 fun(rse){}
     * 返回值:无
    **/
    this.uploadFile=function(imgUri,serverUri,mimeType,success, fail) {
        var options = null;
        var fileTransfer = null;
        try {
            if (!(window.cordovaCustomPlugin.isHasPlatformSupport())) return false;
            if (!imgUri)
                throw new Error("请先选择本地图片");
            options = new FileUploadOptions();
            options.fileKey = "file";
            options.fileName = imgUri.substr(imgUri.lastIndexOf('/') + 1);
            options.mimeType = "image/jpeg";
            fileTransfer = new FileTransfer();
            fileTransfer.upload(
                imgUri,
                encodeURI(serverUri),
                function () {
                    if(success==null) return;
                    success(1);
                },
                function () {
                    if(fail==null) return;
                    fail(0);
                },
                options
            );
        } catch (e) {
            throw e;
        }
    }
    /**
     * 功能:调用手机摄像头
     * 参数:
     * @success  成功回调函数 fun(imageURI){}   成功反回的图片格式(base64 url编码)
     * @fail  失败回调函数 fun(err){}
     * 返回值:无
    **/
    this.fromCamera=function (success,fail) {
        var that=this;
        try {
            if (!(window.cordovaCustomPlugin.isHasPlatformSupport())) return false;
            var camera = cordova.require('cordova/plugin/Camera');
            camera.getPicture(function (imageURI) {
                if(success==null) return;
                success(imageURI);
            }, function (err) {
                if(fail==null) return;
                fail(err);
            },{
                quality: 50,
                destinationType: camera.DestinationType.DATA_URL,
                sourceType: camera.PictureSourceType.CAMERA,
                saveToPhotoAlbum: true,
                encodingType: camera.EncodingType.PNG
            });
        } catch (e) {
            throw e;
        }
    }
    /**
    * 功能:加载本地文件系统
    * 参数:
    * @success  成功回调函数 fun(imageURI){}  成功反回的图片格式(base64 url编码)
    * @fail  失败回调函数 fun(err){}
    * 返回值:无
   **/
    this.fromAlbum = function (success, fail) {
        var that = this;
        var camera = null;
        try {
            if (!(window.cordovaCustomPlugin.isHasPlatformSupport())) return false;
            camera = cordova.require('cordova/plugin/Camera');
            camera.getPicture(function (imageURI) {
                if(success==null) return;
                success(imageURI);
            }, function (err) {
                if(fail==null) return;
                fail(err);
            },{
                quality: 50,
                destinationType: camera.DestinationType.DATA_URL,
                sourceType: camera.PictureSourceType.PHOTOLIBRARY
            });
        } catch (e) {
            throw e;
        }
    }
}
window.cordovaCustomPlugin.File.prototype = new window.cordovaCustomPlugin.PluginBase();