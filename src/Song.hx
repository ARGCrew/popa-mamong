import hxd.Res;
import haxe.Json;

typedef SongData = {
	var ?name:String;
	var ?artist:String;
}

typedef SongRating = {
	var ?difficulty:Float;
	var ?rating:Float;
}

typedef Song = {
	var ?data:SongData;
	var ?rating:SongRating;

	var ?speed:Float;
	var ?notes:Array<Array<Dynamic>>;
}

function getSong(name:String):Song {
	#if local
	var json:Song = Json.parse(Res.load('songs/$name.json').entry.getText());
	#end
	return normalizeSong(json);
}

function normalizeSong(song:Song):Song {
	if (song.data == null)
		song.data = {};
	if (song.rating == null)
		song.rating = {};
	if (song.speed == null)
		song.speed = 1;
	if (song.notes == null)
		song.notes = [];

	if (song.data.name == null)
		song.data.name = 'N/A';
	if (song.data.artist == null)
		song.data.artist = 'N/A';

	if (song.rating.difficulty == null)
		song.rating.difficulty = Math.NaN;
	if (song.rating.rating == null)
		song.rating.rating = Math.NaN;

	return song;
}