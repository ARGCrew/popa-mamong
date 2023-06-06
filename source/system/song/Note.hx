package system.song;

typedef NoteData = {
    var time:Float;
    var data:Int;
    var type:String;
}

typedef EventNoteData = {
    var time:Float;
    var type:String;
    var value1:Dynamic;
    var value2:Dynamic;
    var value3:Dynamic;
}

typedef MechanicNoteData = {
    var time:Float;
    var type:String;
    var arguments:Array<Dynamic>;
}