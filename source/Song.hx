import gameplay.Note.NoteStruct;

@:structInit class Song {
	public var data:SongData = {};

	public var notes:Array<NoteStruct> = [];
	public var speed:Float = 1;
}

@:structInit class SongData {
	public var id:String = 'N/A';
	public var name:String = 'N/A';
	public var artist:String = 'N/A';
}