package utils;

import haxe.Http;
import haxe.io.Bytes;

typedef RequestOptions = {
    var onBytes:(data:Bytes)->Void;
    var onData:(data:String)->Void;
    var onError:(error:String)->Void;
    var onStatus:(status:Int)->Void;
}

class GitHub {
    static var repoUrl:String = "";
    static var dataUrl:String = "";

    public static function connect(repository:String, author:String) {
        repoUrl = 'https://github.com/$author/$repository';
        dataUrl = 'https://raw.githubusercontent.com/$author/$repository';
    }

    public static function getText(file:String, branch:String = "main", options:RequestOptions) {
        var http:Http = new Http('$dataUrl/$branch/$file');

        http.onBytes = options.onBytes;
        http.onData = options.onData;
        http.onError = options.onError;
        http.onStatus = options.onStatus;

        http.request();
    }

    public static function getBytes(file:String, branch:String = "main", options:RequestOptions) {
        var http:Http = new Http('$dataUrl/$branch/$file');

        http.onBytes = options.onBytes;
        http.onData = options.onData;
        http.onError = options.onError;
        http.onStatus = options.onStatus;
        
        http.request();
    } 
}