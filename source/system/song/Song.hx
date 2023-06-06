package system.song;

import haxe.Json;

typedef SongData = {
    var song:String;
    var notes:Array<Section.SectionData>;
    var events:Array<Note.EventNoteData>;
    var bpm:Float;
    var speed:Float;
}

abstract Song(SongData) from SongData to SongData {
    public static function fromFile(path:String)
        return Json.parse(Paths.text(path));
}