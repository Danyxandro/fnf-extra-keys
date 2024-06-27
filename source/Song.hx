package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;
	var mania:Int;
	//var noteValues:Array<Float>;

	var player1:String;
	var player2:String;
	var gfVersion:String;
	var noteStyle:String;
	var noteStyle2:String;
	var asRival:Bool;
	var bothSide:Bool;
	var stage:String;
	var validScore:Bool;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Float;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;
	public var mania:Int = 0;

	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var gfVersion:String = '';
	public var noteStyle:String = '';
	public var noteStyle2:String = '';
	public var asRival:Bool = false;
	public var bothSide:Bool = false;
	public var stage:String = '';

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		//trace(jsonInput);

		// pre lowercasing the folder name
		var folderLowercase = StringTools.replace(folder, " ", "-").toLowerCase();
		switch (folderLowercase) {
			case 'dad-battle': folderLowercase = 'dadbattle';
			case 'philly-nice': folderLowercase = 'philly';
		}
		
		//trace('loading ' + folderLowercase + '/' + jsonInput.toLowerCase());

		var cancion:String = jsonInput.toLowerCase();
		var subfix:String = "";

		if(jsonInput.toLowerCase().endsWith("-easy")){
			cancion = jsonInput.toLowerCase().substring(0,cancion.length-5);
			subfix = "-easy";
		}
		if(jsonInput.toLowerCase().endsWith("-hard")){
			cancion = jsonInput.toLowerCase().substring(0,cancion.length-5);
			subfix = "-hard";
		}

		var rawJson:String = "";

		if(openfl.utils.Assets.exists(Paths.json(folderLowercase + '/' + jsonInput.toLowerCase() ) ) )
			rawJson = Assets.getText(Paths.json(folderLowercase + '/' + jsonInput.toLowerCase())).trim();
		else{
			var ruta:String = "assets/data/" + cancion + "/" + jsonInput.toLowerCase() +".json";
			if(sys.FileSystem.exists(ruta) ){
				rawJson = sys.io.File.getContent( ruta ).trim();
			}else
				rawJson = Assets.getText(Paths.json('tutorial/tutorial' + subfix)).trim();				
		}

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
			// LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
		}

		// FIX THE CASTING ON WINDOWS/NATIVE
		// Windows???
		// trace(songData);

		// trace('LOADED FROM JSON: ' + songData.notes);
		/* 
			for (i in 0...songData.notes.length)
			{
				trace('LOADED FROM JSON: ' + songData.notes[i].sectionNotes);
				// songData.notes[i].sectionNotes = songData.notes[i].sectionNotes
			}

				daNotes = songData.notes;
				daSong = songData.song;
				daBpm = songData.bpm; */

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var data = cast Json.parse(rawJson).song;
		var notes:Array<Dynamic> = Reflect.field(data, "notes");
		for(i in 0...notes.length){
			if(notes[i].lengthInSteps == null || notes[i].lengthInSteps < 1){
				trace("Invalid step lenght at section " + i);
				data.notes[i].lengthInSteps = 16;
			}
		}
		var swagShit:SwagSong = data;
		swagShit.validScore = true;
		return swagShit;
	}
}
