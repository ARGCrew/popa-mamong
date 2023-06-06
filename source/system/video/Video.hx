package system.video;

import openfl.Lib;
import openfl.events.NetStatusEvent;
import openfl.net.NetConnection;
import haxe.io.Path;
import openfl.events.Event;
import openfl.net.NetStream;
import openfl.media.Video as StockVideo;

class Video extends StockVideo {
    private var stream:NetStream;
    private var source:String;
    
    @:isVar public var volume(get, set):Float = 1;
    public function set_volume(value:Float) {
        stream.soundTransform.volume = value;
        return value;
    }
    public function get_volume() return stream.soundTransform.volume;

    public var isPlaying:Bool = false;
    public var canPause:Bool = true;

    public var onOpening:()->Void;
    public var onPlaying:()->Void;
    public var onPaused:()->Void;
    public var onStopped:()->Void;
    public var onEndReached:()->Void;

    private var looping:Bool = false;

    public function new(width:Int, height:Int) {
        super(width, height);
        smoothing = true;
    }

    public function play(?location:String = null, loop:Bool = false) {
        source = location;
        looping = loop;

        final path:String = #if windows Path.normalize(location).split("/").join("\\") #else Path.normalize(location) #end;

        var connection:NetConnection = new NetConnection();
        connection.connect(null);
        stream = new NetStream(connection);
        stream.client = {onMetaData: function(data:Dynamic) vidOpening()};
        connection.addEventListener(NetStatusEvent.NET_STATUS, function(event:NetStatusEvent) {
            if (event.info.code == "NetStream.Play.Complete") vidEndReached();
        });
        stream.play(source);

        isPlaying = true;
    }

    public function stop() {
        stream.dispose();
        isPlaying = false;
        if (onStopped != null) onStopped();
    }
    public function pause() {
        stream.pause();
        if (onPaused != null) onPaused();
    }
    public function resume() {
        stream.resume();
        if (onPlaying != null) onPlaying();
    }

    public function dispose() {
        if (isPlaying) stop();

        onOpening = null;
        onPlaying = null;
		onStopped = null;
		onPaused = null;
		onEndReached = null;
    }

    private function vidOpening() {
        attachNetStream(stream);
        if (onOpening != null) onOpening();
    }

    private function vidEndReached() {
        if (looping) stream.play(source);
        else {
            stream.dispose();
            if (onEndReached != null) onEndReached();
        }
    }
}