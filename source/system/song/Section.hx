package system.song;

typedef SectionData = {
    var notes:Array<Note.NoteData>;
    var beats:Float;
    var bpm:Float;
    var changeBPM:Bool;
}