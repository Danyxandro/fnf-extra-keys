// this file is for modchart things, this is to declutter playstate.hx

// Lua
import openfl.display3D.textures.VideoTexture;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
#if windows
import flixel.tweens.FlxEase;
import openfl.filters.ShaderFilter;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import lime.app.Application;
import flixel.FlxSprite;
import llua.Convert;
import llua.Lua;
import llua.State;
import llua.LuaL;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import haxe.Json;
import haxe.format.JsonParser;
import openfl.display.BlendMode;
import flixel.group.FlxSpriteGroup;

using StringTools;

class DialogueLUA 
{
	//public static var shaders:Array<LuaShader> = null;

	public static var lua:State = null;
	private var ids:Map<String,Int> = [PlayState.SONG.player2 => 0];
	private var idsBF:Map<String,Int> = [PlayState.SONG.player1 => 0];
	public var gfs:Map<String, Int> = [PlayState.gf.curCharacter => 0];
	private var sprites:Map<String, FlxSprite> = [];
	private var curChar = 0;
	private var curBF = 0;
	private var curGF = 0;
	private var flags:Array<Bool> = [false,false];
	private var allowChanging:Bool = true;
	private var doof:FlxSpriteGroup;
	private var luaSprites:Map<String,FlxSprite> = [];
	private var luaTrails:Map<String,ui.DeltaTrail> = [];
	public var timerSecs:Float = 0;

	function callLua(func_name : String, args : Array<Dynamic>, ?type : String) : Dynamic
	{
		var result : Any = null;

		Lua.getglobal(lua, func_name);

		for( arg in args ) {
		Convert.toLua(lua, arg);
		}

		result = Lua.pcall(lua, args.length, 1, 0);
		var p = Lua.tostring(lua,result);
		var e = getLuaErrorMessage(lua);

		if (e != null)
		{
			if (p != null)
				{
					Application.current.window.alert("LUA ERROR:\n" + p + "\nhaxe things: " + e,"Kade Engine Modcharts");
					lua = null;
					LoadingState.loadAndSwitchState(new MainMenuState());
				}
			// trace('err: ' + e);
		}
		if( result == null) {
			return null;
		} else {
			return convert(result, type);
		}

	}

	static function toLua(l:State, val:Any):Bool {
		switch (Type.typeof(val)) {
			case Type.ValueType.TNull:
				Lua.pushnil(l);
			case Type.ValueType.TBool:
				Lua.pushboolean(l, val);
			case Type.ValueType.TInt:
				Lua.pushinteger(l, cast(val, Int));
			case Type.ValueType.TFloat:
				Lua.pushnumber(l, val);
			case Type.ValueType.TClass(String):
				Lua.pushstring(l, cast(val, String));
			case Type.ValueType.TClass(Array):
				Convert.arrayToLua(l, val);
			case Type.ValueType.TObject:
				objectToLua(l, val);
			default:
				trace("haxe value not supported - " + val + " which is a type of " + Type.typeof(val));
				return false;
		}

		return true;

	}

	static function objectToLua(l:State, res:Any) {

		var FUCK = 0;
		for(n in Reflect.fields(res))
		{
			trace(Type.typeof(n).getName());
			FUCK++;
		}

		Lua.createtable(l, FUCK, 0); // TODONE: I did it

		for (n in Reflect.fields(res)){
			if (!Reflect.isObject(n))
				continue;
			Lua.pushstring(l, n);
			toLua(l, Reflect.field(res, n));
			Lua.settable(l, -3);
		}

	}

	function getType(l, type):Any
	{
		return switch Lua.type(l,type) {
			case t if (t == Lua.LUA_TNIL): null;
			case t if (t == Lua.LUA_TNUMBER): Lua.tonumber(l, type);
			case t if (t == Lua.LUA_TSTRING): (Lua.tostring(l, type):String);
			case t if (t == Lua.LUA_TBOOLEAN): Lua.toboolean(l, type);
			case t: throw 'you don goofed up. lua type error ($t)';
		}
	}

	function getReturnValues(l) {
		var lua_v:Int;
		var v:Any = null;
		while((lua_v = Lua.gettop(l)) != 0) {
			var type:String = getType(l,lua_v);
			v = convert(lua_v, type);
			Lua.pop(l, 1);
		}
		return v;
	}


	private function convert(v : Any, type : String) : Dynamic { // I didn't write this lol
		if( Std.is(v, String) && type != null ) {
		var v : String = v;
		if( type.substr(0, 4) == 'array' ) {
			if( type.substr(4) == 'float' ) {
			var array : Array<String> = v.split(',');
			var array2 : Array<Float> = new Array();

			for( vars in array ) {
				array2.push(Std.parseFloat(vars));
			}

			return array2;
			} else if( type.substr(4) == 'int' ) {
			var array : Array<String> = v.split(',');
			var array2 : Array<Int> = new Array();

			for( vars in array ) {
				array2.push(Std.parseInt(vars));
			}

			return array2;
			} else {
			var array : Array<String> = v.split(',');
			return array;
			}
		} else if( type == 'float' ) {
			return Std.parseFloat(v);
		} else if( type == 'int' ) {
			return Std.parseInt(v);
		} else if( type == 'bool' ) {
			if( v == 'true' ) {
			return true;
			} else {
			return false;
			}
		} else {
			return v;
		}
		} else {
		return v;
		}
	}

	function getLuaErrorMessage(l) {
		var v:String = Lua.tostring(l, -1);
		Lua.pop(l, 1);
		return v;
	}

	public function setVar(var_name : String, object : Dynamic){
		// trace('setting variable ' + var_name + ' to ' + object);

		Lua.pushnumber(lua,object);
		Lua.setglobal(lua, var_name);
	}

	public function getVar(var_name : String, type : String) : Dynamic {
		var result : Any = null;

		// trace('getting variable ' + var_name + ' with a type of ' + type);

		Lua.getglobal(lua, var_name);
		result = Convert.fromLua(lua,-1);
		Lua.pop(lua,1);

		if( result == null ) {
		return null;
		} else {
		var result = convert(result, type);
		//trace(var_name + ' result: ' + result);
		return result;
		}
	}

	function getActorByName(id:String):Dynamic
	{
		// pre defined names
		switch(id)
		{
			case 'boyfriend':
                @:privateAccess{
				if(PlayStateChangeables.flip)
					return PlayState.dad;
				return PlayState.boyfriend;
				}
			case 'girlfriend':
                @:privateAccess
				return PlayState.gf;
			case 'dad':
                @:privateAccess{
				if(PlayStateChangeables.flip)
					return PlayState.boyfriend;
				return PlayState.dad;
				}
			case "healthbar":
				@:privateAccess{
					return PlayState.instance.healthGrp;
				}
			case "box":
				return getDoof().getBox();
			case "blue":
				@:privateAccess
				return getDoof().bgFade;
		}
		// lua objects or what ever
		if(luaSprites.get(id) != null)
			return luaSprites.get(id);
		if (ModchartState.luaSprites.get(id) == null)
		{
			if (ModchartState.luaTrails.get(id) == null)
			{
				if (Std.parseInt(id) == null)
					return Reflect.getProperty(PlayState.instance,id);
				return PlayState.PlayState.strumLineNotes.members[Std.parseInt(id)];
			}
			return ModchartState.luaTrails.get(id);
		}
		return ModchartState.luaSprites.get(id);
	}

	function getPropertyByName(id:String)
	{
		return Reflect.field(PlayState.instance,id);
	}

	function changeDadCharacter(id:String,?swap:Bool = true,?noteStyle:String)
	{
		if(PlayStateChangeables.flip){
			if(idsBF[id] != null && !PlayState.instance.layerPlayChars.members[idsBF[id]].isSynchronous()){
				if(idsBF[id] != curBF){
					PlayState.instance.layerPlayChars.members[idsBF[id]].active = true;
					PlayState.instance.layerPlayChars.members[idsBF[id]].hasFocus = true;
					PlayState.instance.layerPlayChars.members[idsBF[id]].alpha = 1;
					PlayState.instance.layerPlayChars.members[curBF].hasFocus = false;
					if(swap){
						PlayState.instance.layerPlayChars.members[curBF].alpha = getVar("bfFadeAlpha","float");
						PlayState.instance.layerPlayChars.members[curBF].active = false;
					}
					curBF = idsBF[id];
					PlayState.instance.bfID = idsBF[id];
					PlayState.boyfriend = PlayState.instance.layerPlayChars.members[idsBF[id]];
					changeIcon(id,false, PlayState.instance.layerPlayChars.members[idsBF[id]].isCustom);
				}
			}
		}else{
			if(ids[id] != null && !PlayState.instance.layerChars.members[ids[id]].isSynchronous()){
				if(ids[id] != curChar){
					PlayState.instance.layerChars.members[ids[id]].active = true;
					PlayState.instance.layerChars.members[ids[id]].hasFocus = true;
					PlayState.instance.layerChars.members[ids[id]].alpha = 1;
					PlayState.instance.layerChars.members[curChar].hasFocus = false;
					if(swap){
						PlayState.instance.layerChars.members[curChar].alpha = getVar("dadFadeAlpha","float");
						PlayState.instance.layerChars.members[curChar].active = false;
					}
					curChar = ids[id];
					PlayState.instance.dadID = ids[id];
					PlayState.dad = PlayState.instance.layerChars.members[ids[id]];
					changeIcon(id,false, PlayState.instance.layerChars.members[ids[id]].isCustom);
				}
			}
		}
		if(!PlayStateChangeables.allowChanging){
			if(PlayState.instance.animatedIcons["default2"].animation.getByName(id) != null){
				changeIcon(id,false);
			}else
				changeIcon(id,false,true);
		}
		PlayState.instance.setColorBar(false,id);
		if(noteStyle != null){
			PlayState.instance.changeStyle(noteStyle,2);
		}
	}

	function changeBoyfriendCharacter(id:String,?swap:Bool = true,?noteStyle:String)
	{
		if(!PlayStateChangeables.flip){
			if(idsBF[id] != null && !PlayState.instance.layerBFs.members[idsBF[id]].isSynchronous()){
				if(idsBF[id] != curBF){
					PlayState.instance.layerBFs.members[idsBF[id]].active = true;
					PlayState.instance.layerBFs.members[idsBF[id]].hasFocus = true;
					PlayState.instance.layerBFs.members[idsBF[id]].alpha = 1;
					PlayState.instance.layerBFs.members[curBF].hasFocus = false;
					if(swap){
						PlayState.instance.layerBFs.members[curBF].alpha = getVar("bfFadeAlpha","float");
						PlayState.instance.layerBFs.members[curBF].active = false;
					}
					curBF = idsBF[id];
					PlayState.instance.bfID = idsBF[id];
					PlayState.boyfriend = PlayState.instance.layerBFs.members[idsBF[id]];
					changeIcon(id,true, PlayState.instance.layerBFs.members[idsBF[id]].isCustom);
				}
			}
		}else{
			if(ids[id] != null && !PlayState.instance.layerFakeBFs.members[ids[id]].isSynchronous()){
				if(ids[id] != curChar){
					PlayState.instance.layerFakeBFs.members[ids[id]].active = true;
					PlayState.instance.layerFakeBFs.members[ids[id]].hasFocus = true;
					PlayState.instance.layerFakeBFs.members[ids[id]].alpha = 1;
					PlayState.instance.layerFakeBFs.members[curChar].hasFocus = false;
					if(swap){
						PlayState.instance.layerFakeBFs.members[curChar].alpha = getVar("dadFadeAlpha","float");
						PlayState.instance.layerFakeBFs.members[curChar].active = false;
					}
					curChar = ids[id];
					PlayState.instance.dadID = ids[id];
					PlayState.dad = PlayState.instance.layerFakeBFs.members[ids[id]];
					changeIcon(id,true, PlayState.instance.layerFakeBFs.members[ids[id]].isCustom);
				}
			}
		}
		if(!PlayStateChangeables.allowChanging){
			if(PlayState.instance.animatedIcons["default1"].animation.getByName(id) != null){
				changeIcon(id,true);
			}else
				changeIcon(id,true,true);
		}
		PlayState.instance.setColorBar(true,id);
		if(noteStyle != null){
			PlayState.instance.changeStyle(noteStyle,1);
		}
	}

	function changeGirlfriendCharacter(id:String)
	{
		if(gfs[id] != null){
			PlayState.instance.layerGF.members[curGF].active = false;
			PlayState.instance.layerGF.members[curGF].alpha = getVar("gfFadeAlpha","float");
			curGF = gfs[id];
			PlayState.instance.layerGF.members[curGF].active = true;
			PlayState.instance.layerGF.members[curGF].alpha = 1;
			PlayState.gf = PlayState.instance.layerGF.members[curGF];
		}
	}

	function makeAnimatedSprite(name:String,fileName:String,initialAnimation:String,prefix:String,?drawBehind:Dynamic=false){
		var sprite:FlxSprite = new FlxSprite();

		var songLowercase:String = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}

		if(sys.FileSystem.exists("assets/data/" + songLowercase + '/' + fileName + ".png") && sys.FileSystem.exists("assets/data/" + songLowercase + '/' + fileName + ".xml")){
			sprite.frames = FlxAtlasFrames.fromSparrow(openfl.display.BitmapData.fromFile("assets/data/" + songLowercase + '/' + fileName + ".png"),sys.io.File.getContent("assets/data/" + songLowercase + '/' + fileName + ".xml"));
			
			sprite.animation.addByPrefix(initialAnimation,prefix,24,true);

			/*var chars = PlayState.instance.layerChars;
			var bfs = PlayState.instance.layerBFs;
			var gfs = PlayState.instance.layerGF;*/

			addToLayer(drawBehind,sprite);
			sprites[name] = sprite;
			luaSprites.set(name,sprite);
			sprite.animation.play(initialAnimation);
		}

		return name;
	}

	function makeLuaSprite(spritePath:String,toBeCalled:String, ?drawBehind:Dynamic=false)
	{
		#if sys
		// pre lowercasing the song name (makeLuaSprite)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}

		var data:BitmapData = BitmapData.fromFile(Sys.getCwd() + "assets/data/" + songLowercase + '/' + spritePath + ".png");

		var sprite:FlxSprite = new FlxSprite(0,0);
		var imgWidth:Float = FlxG.width / data.width;
		var imgHeight:Float = FlxG.height / data.height;
		var scale:Float = imgWidth <= imgHeight ? imgWidth : imgHeight;

		// Cap the scale at x1
		if (scale > 1)
			scale = 1;

		sprite.makeGraphic(Std.int(data.width * scale),Std.int(data.width * scale),FlxColor.TRANSPARENT);

		var data2:BitmapData = sprite.pixels.clone();
		var matrix:Matrix = new Matrix();
		matrix.identity();
		matrix.scale(scale, scale);
		data2.fillRect(data2.rect, FlxColor.TRANSPARENT);
		data2.draw(data, matrix, null, null, null, true);
		sprite.pixels = data2;
		
		luaSprites.set(toBeCalled,sprite);
		// and I quote:
		// shitty layering but it works!
        addToLayer(drawBehind,sprite);
		#end
		return toBeCalled;
	}

    public function die()
    {
        Lua.close(lua);
		lua = null;
    }

	public var luaWiggles:Map<String,WiggleEffect> = new Map<String,WiggleEffect>();
    // LUA SHIT

    function new(doof: DialogueBox)
    {
        		trace('opening a lua dialogue script (' + ((doof is DialogueBox) ? "intro" : "outro") + ")");
				lua = LuaL.newstate();
				LuaL.openlibs(lua);
				Lua.init_callbacks(lua);
				
				//shaders = new Array<LuaShader>();

				// pre lowercasing the song name (new)
				var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
				switch (songLowercase) {
					case 'dad-battle': songLowercase = 'dadbattle';
					case 'philly-nice': songLowercase = 'philly';
				}

				var result;
				result = LuaL.dofile(lua, Paths.lua(songLowercase + "/dialogue")); // execute le file
	
				if (result != 0)
				{
					Application.current.window.alert("LUA COMPILE ERROR:\n" + Lua.tostring(lua,result),"Kade Engine Modcharts");
					lua = null;
					LoadingState.loadAndSwitchState(new MainMenuState());
				}

				// get some fukin globals up in here bois
				this.doof = doof;
				if(PlayState.luaModchart != null){
					for(key in ModchartState.luaSprites.keys()){
						luaSprites.set(key,ModchartState.luaSprites.get(key));
					}
					for(key in ModchartState.luaTrails.keys()){
						luaTrails.set(key,ModchartState.luaTrails.get(key));
					}
					gfs = PlayState.luaModchart.gfs;
					@:privateAccess{
						ids = PlayState.luaModchart.ids;
						idsBF = PlayState.luaModchart.idsBF;
						sprites = PlayState.luaModchart.sprites;
						curChar = PlayState.luaModchart.curChar;
						curBF = PlayState.luaModchart.curBF;
						curGF = PlayState.luaModchart.curGF;
						flags[0] = PlayState.luaModchart.flags[0];
						flags[1] = PlayState.luaModchart.flags[1];
						allowChanging = PlayState.luaModchart.allowChanging;
					}
					setVar("showOnlyStrums", PlayState.luaModchart.getVar("showOnlyStrums","bool"));
					setVar("strumLine1Visible", PlayState.luaModchart.getVar("strumLine1Visible","bool"));
					setVar("strumLine2Visible", PlayState.luaModchart.getVar("strumLine2Visible","bool"));
					setVar("followXOffset",PlayState.luaModchart.getVar("followXOffset","float"));
					setVar("followYOffset",PlayState.luaModchart.getVar("followYOffset","float"));
					setVar("dadFadeAlpha", PlayState.luaModchart.getVar("dadFadeAlpha","float"));
					setVar("bfFadeAlpha", PlayState.luaModchart.getVar("bfFadeAlpha","float"));
					setVar("gfFadeAlpha", PlayState.luaModchart.getVar("gfFadeAlpha","float"));
				}else{
					if(PlayStateChangeables.flip){
						ids.clear();
						idsBF.clear();
						ids = [PlayState.SONG.player1 => 0];
						idsBF = [PlayState.SONG.player2 => 0];
						luaSprites.set("bf-" + PlayState.SONG.player1, PlayState.instance.layerFakeBFs.members[0]);
						luaSprites.set("icon2", PlayState.instance.iconP1);
						luaSprites.set("icon1", PlayState.instance.iconP2);
						ids.set("bf-" + PlayState.SONG.player1, 0);
						if(PlayState.SONG.player2 == "dad"){
							luaSprites.set("daddy", PlayState.instance.layerPlayChars.members[0]);
							idsBF.set("daddy",0);
						}else{
							luaSprites.set(PlayState.SONG.player2, PlayState.instance.layerPlayChars.members[0]);
							idsBF.set(PlayState.SONG.player2, 0);
						}
					}else{
						luaSprites.set("bf-" + PlayState.SONG.player1, PlayState.instance.layerBFs.members[0]);
						luaSprites.set("icon2", PlayState.instance.iconP2);
						luaSprites.set("icon1", PlayState.instance.iconP1);
						idsBF.set("bf-" + PlayState.SONG.player1, 0);
						if(PlayState.SONG.player2 == "dad"){
							luaSprites.set("daddy", PlayState.instance.layerChars.members[0]);
							ids.set("daddy",0);
						}else{
							luaSprites.set(PlayState.SONG.player2, PlayState.instance.layerChars.members[0]);
							ids.set(PlayState.SONG.player2, 0);
						}
					}
					setVar("followXOffset",0);
					setVar("followYOffset",0);
					setVar("dadFadeAlpha", 0.001);
					setVar("bfFadeAlpha", 0.001);
					setVar("gfFadeAlpha", 0.001);
					setVar("showOnlyStrums", false);
					setVar("strumLine1Visible", true);
					setVar("strumLine2Visible", true);
					allowChanging = PlayStateChangeables.allowChanging;
				}
				setVar("difficulty", PlayState.storyDifficulty);
				setVar("bpm", Conductor.bpm);
				setVar("scrollspeed", FlxG.save.data.scrollSpeed != 1 ? FlxG.save.data.scrollSpeed : PlayState.SONG.speed);
				setVar("fpsCap", FlxG.save.data.fpsCap);
				setVar("downscroll", PlayStateChangeables.useDownscroll);
				setVar("cpuDownscroll", PlayStateChangeables.cpuDownscroll);
				setVar("flashing", FlxG.save.data.flashing);
				setVar("distractions", FlxG.save.data.distractions);
				setVar("optimization",PlayStateChangeables.Optimize);
				setVar("zooming",(FlxG.save.data.camzoom && PlayState.SONG.song.toLowerCase() != "tutorial"));
	
				setVar("crochet", Conductor.stepCrochet);
				setVar("safeZoneOffset", Conductor.safeZoneOffset);
	
				setVar("hudZoom", PlayState.instance.camHUD.zoom);
				setVar("cameraZoom", FlxG.camera.zoom);
	
				setVar("cameraAngle", FlxG.camera.angle);
				setVar("camHudAngle", PlayState.instance.camHUD.angle);
	
				setVar("screenWidth",FlxG.width);
				setVar("screenHeight",FlxG.height);
				setVar("windowWidth",FlxG.width);
				setVar("windowHeight",FlxG.height);
				setVar("hudWidth", PlayState.instance.camHUD.width);
				setVar("hudHeight", PlayState.instance.camHUD.height);

				setVar("strumLineY", PlayState.instance.strumLine.y);

				setVar("playingAsRival", PlayStateChangeables.flip);
				setVar("playingAsBoth", PlayStateChangeables.bothSide);
				setVar("keyAmount", PlayState.keyAmmo[PlayState.mania]);

				setVar("mustHit", false);
				
				// callbacks
	
				// sprites
	
				Lua_helper.add_callback(lua,"makeSprite", makeLuaSprite);
				
				Lua_helper.add_callback(lua,"changeDadCharacter", changeDadCharacter);

				Lua_helper.add_callback(lua,"changeBoyfriendCharacter", changeBoyfriendCharacter);

				Lua_helper.add_callback(lua,"changeGirlfriendCharacter", changeGirlfriendCharacter);
	
				Lua_helper.add_callback(lua,"getProperty", getPropertyByName);

				
				Lua_helper.add_callback(lua,"makeAnimatedSprite", makeAnimatedSprite);
				// this one is still in development

				Lua_helper.add_callback(lua,"destroySprite", function(id:String) {
					var sprite = luaSprites.get(id);
					if (sprite == null)
						return false;
					PlayState.instance.removeObject(sprite);
					return true;
				});
	
				// hud/camera

				Lua_helper.add_callback(lua,"initBackgroundVideo", function(videoName:String) {
					trace('playing assets/videos/' + videoName + '.webm');
					PlayState.instance.backgroundVideo("assets/videos/" + videoName + ".webm");
				});

				Lua_helper.add_callback(lua,"pauseVideo", function() {
					if (!GlobalVideo.get().paused)
						GlobalVideo.get().pause();
				});

				Lua_helper.add_callback(lua,"resumeVideo", function() {
					if (GlobalVideo.get().paused)
						GlobalVideo.get().pause();
				});
				
				Lua_helper.add_callback(lua,"restartVideo", function() {
					GlobalVideo.get().restart();
				});

				Lua_helper.add_callback(lua,"getVideoSpriteX", function() {
					return PlayState.instance.videoSprite.x;
				});

				Lua_helper.add_callback(lua,"getVideoSpriteY", function() {
					return PlayState.instance.videoSprite.y;
				});

				Lua_helper.add_callback(lua,"setVideoSpritePos", function(x:Int,y:Int) {
					PlayState.instance.videoSprite.setPosition(x,y);
				});
				
				Lua_helper.add_callback(lua,"setVideoSpriteScale", function(scale:Float) {
					PlayState.instance.videoSprite.setGraphicSize(Std.int(PlayState.instance.videoSprite.width * scale));
				});
	
				Lua_helper.add_callback(lua,"setHudAngle", function (x:Float) {
					PlayState.instance.camHUD.angle = x;
				});

				Lua_helper.add_callback(lua,"setHudPosition", function (x:Int, y:Int) {
					PlayState.instance.camHUD.x = x;
					PlayState.instance.camHUD.y = y;
				});
	
				Lua_helper.add_callback(lua,"getHudX", function () {
					return PlayState.instance.camHUD.x;
				});
	
				Lua_helper.add_callback(lua,"getHudY", function () {
					return PlayState.instance.camHUD.y;
				});
				
				Lua_helper.add_callback(lua,"setCamPosition", function (x:Int, y:Int) {
					FlxG.camera.x = x;
					FlxG.camera.y = y;
				});
	
				Lua_helper.add_callback(lua,"getCameraX", function () {
					return FlxG.camera.x;
				});
	
				Lua_helper.add_callback(lua,"getCameraY", function () {
					return FlxG.camera.y;
				});
	
				Lua_helper.add_callback(lua,"setCamZoom", function(zoomAmount:Float) {
					FlxG.camera.zoom = zoomAmount;
				});
	
				Lua_helper.add_callback(lua,"setHudZoom", function(zoomAmount:Float) {
					PlayState.instance.camHUD.zoom = zoomAmount;
				});
	
				// strumline

				Lua_helper.add_callback(lua, "setStrumlineY", function(y:Float)
				{
					PlayState.instance.strumLine.y = y;
				});

				//custom

				Lua_helper.add_callback(lua, "swapBF", function(id:String,?swap:Bool = true,?noteStyle:String){
					if(PlayStateChangeables.flip){
						if(ids[id] != null){
						PlayState.instance.layerFakeBFs.members[ids[id]].alpha = 1;
						if(swap){
							PlayState.instance.layerFakeBFs.members[curChar].alpha = getVar("dadFadeAlpha","float");
							PlayState.instance.layerFakeBFs.members[curChar].active = false;
						}
						curChar = ids[id];
						PlayState.instance.layerFakeBFs.members[ids[id]].active = true;
						PlayState.instance.dadID = ids[id];
						changeIcon(id,true,PlayState.instance.layerFakeBFs.members[ids[id]].isCustom);
					}
					}else{
						if(idsBF[id] != null){
							if(swap){
								PlayState.instance.layerBFs.members[curBF].alpha = getVar("bfFadeAlpha","float");
								PlayState.instance.layerBFs.members[curBF].active = false;
							}
							PlayState.instance.layerBFs.members[idsBF[id]].alpha = 1;
							PlayState.instance.layerBFs.members[idsBF[id]].active = true;
							curBF = idsBF[id];
							PlayState.instance.bfID = idsBF[id];
							changeIcon(id,true,PlayState.instance.layerBFs.members[idsBF[id]].isCustom);
						}
					}
					if(!allowChanging){
						if(PlayState.instance.animatedIcons["default1"].animation.getByName(id) != null)
							changeIcon(id,true);
						else
							changeIcon(id,true,true);
					}
					PlayState.instance.setColorBar(true,id);
					if(noteStyle != null){
						PlayState.instance.changeStyle(noteStyle,1);
					}
				});

				Lua_helper.add_callback(lua, "swapDad", function(id:String,?swap:Bool = true,?noteStyle:String){
					if(PlayStateChangeables.flip){
						if(idsBF[id] != null){
							if(swap){
								PlayState.instance.layerPlayChars.members[curBF].alpha = getVar("bfFadeAlpha","float");
								PlayState.instance.layerPlayChars.members[curBF].active = false;
							}
							PlayState.instance.layerPlayChars.members[idsBF[id]].alpha = 1;
							PlayState.instance.layerPlayChars.members[idsBF[id]].active = true;
							curBF = idsBF[id];
							PlayState.instance.bfID = idsBF[id];
							changeIcon(id,false,PlayState.instance.layerPlayChars.members[idsBF[id]].isCustom);
						}
					}else{
						if(ids[id] != null){
							PlayState.instance.layerChars.members[ids[id]].alpha = 1;
							if(swap){
								PlayState.instance.layerChars.members[curChar].alpha = getVar("dadFadeAlpha","float");
								PlayState.instance.layerChars.members[curChar].active = false;
							}
							curChar = ids[id];
							PlayState.instance.layerChars.members[ids[id]].active = true;
							PlayState.instance.dadID = ids[id];
							changeIcon(id,false,PlayState.instance.layerChars.members[ids[id]].isCustom);
						}
					}
					if(!allowChanging){
						if(PlayState.instance.animatedIcons["default2"].animation.getByName(id) != null)
							changeIcon(id,false);
						else
							changeIcon(id,false,true);
					}
					PlayState.instance.setColorBar(false,id);
					if(noteStyle != null){
						PlayState.instance.changeStyle(noteStyle,2);
					}
				});

				Lua_helper.add_callback(lua, "visibleChar", function(id:String,visible:Bool,isPlayer:Bool){
					if(PlayStateChangeables.flip){
						if(isPlayer){
							if(visible){
								if(ids[id] != null){
									PlayState.instance.layerFakeBFs.members[ids[id]].alpha = 1;
									PlayState.instance.layerFakeBFs.members[ids[id]].active = true;
								}
							}else{
								if(ids[id] != null){
									PlayState.instance.layerFakeBFs.members[ids[id]].alpha = getVar("bfFadeAlpha","float");
									PlayState.instance.layerFakeBFs.members[ids[id]].active = false;
								}
							}
						}else{
							if(visible){
								if(idsBF[id] != null){
									PlayState.instance.layerPlayChars.members[idsBF[id]].alpha = 1;
									PlayState.instance.layerPlayChars.members[idsBF[id]].active = true;
								}
							}else{
								if(idsBF[id] != null){
									PlayState.instance.layerPlayChars.members[idsBF[id]].alpha =getVar("dadFadeAlpha","float");
									PlayState.instance.layerPlayChars.members[idsBF[id]].active = false;
								}
							}
						}
					}else{
						if(isPlayer){
							if(visible){
								if(idsBF[id] != null){
									PlayState.instance.layerBFs.members[idsBF[id]].alpha = 1;
									PlayState.instance.layerBFs.members[idsBF[id]].active = true;
								}
							}else{
								if(idsBF[id] != null){
									PlayState.instance.layerBFs.members[idsBF[id]].alpha = getVar("bfFadeAlpha","float");
									PlayState.instance.layerBFs.members[idsBF[id]].active = false;
								}
							}
						}else{
							if(visible){
								if(ids[id] != null){
									PlayState.instance.layerChars.members[ids[id]].alpha = 1;
									PlayState.instance.layerChars.members[ids[id]].active = true;
								}
							}else{
								if(ids[id] != null){
									PlayState.instance.layerChars.members[ids[id]].alpha =getVar("dadFadeAlpha","float");
									PlayState.instance.layerChars.members[ids[id]].active = false;
								}
							}
						}
					}//fin del data.flip
				});

				Lua_helper.add_callback(lua, "syncChar", function(id:String,synchronous:Bool,isPlayer:Bool){
					if(PlayStateChangeables.flip){
						if(isPlayer){
							if(ids[id] != null)
								PlayState.instance.layerFakeBFs.members[ids[id]].setSynchronous(synchronous);
						}else{
							if(idsBF[id] != null)
								PlayState.instance.layerPlayChars.members[idsBF[id]].setSynchronous(synchronous);
						}
					}else{
						if(isPlayer){
							if(idsBF[id] != null)
								PlayState.instance.layerBFs.members[idsBF[id]].setSynchronous(synchronous);
						}else{
							if(ids[id] != null)
								PlayState.instance.layerChars.members[ids[id]].setSynchronous(synchronous);
						}
					}
				});

				Lua_helper.add_callback(lua, "allowCharacterChanging", function():Bool{
					return allowChanging;
				});

				Lua_helper.add_callback(lua, "setCharacterChanging", function(setting:Bool){
					allowChanging = setting;
				});

				Lua_helper.add_callback(lua, "getDifficulty", function(){
					return PlayState.storyDifficulty;
				});
	
				Lua_helper.add_callback(lua, "shakeCam", function(intensity:Float, duration:Float){
					@:privateAccess
					FlxG.camera.shake(intensity, duration);
				});

				Lua_helper.add_callback(lua, "shakeHUD", function(intensity:Float, duration:Float){
					@:privateAccess
					PlayState.instance.camHUD.shake(intensity, duration);
				});

				Lua_helper.add_callback(lua, "flash", function(red:Int, green:Int, blue:Int, duration:Float){
					@:privateAccess
						PlayState.instance.camHUD.flash(flixel.util.FlxColor.fromRGB(red, green, blue, 255), duration);
				});

				Lua_helper.add_callback(lua, "getHealth", function () {
					return PlayState.instance.health;
				});

				Lua_helper.add_callback(lua,"setAntialiasing", function(anti:Bool,id:String){
					getActorByName(id).antialiasing = anti;
				});

				Lua_helper.add_callback(lua,"setColorBar", function(isPlayer:Bool,character:String):Void {
					PlayState.instance.setColorBar(isPlayer,character);
				});

				Lua_helper.add_callback(lua,"setRGBColorBar", function(isPlayer:Bool,red:Int,green:Int,blue:Int):Void {
					PlayState.instance.setRGBColorBar(isPlayer,red,green,blue);
				});

				Lua_helper.add_callback(lua,"setFlyingOffset", function(id:String, isPlayer:Bool, amount:Float){
					if(PlayStateChangeables.flip){
						if(isPlayer){
							if(ids[id] != null)
								PlayState.instance.layerFakeBFs.members[ids[id]].flyingOffset = amount;
						}else{
							if(idsBF[id] != null)
								PlayState.instance.layerPlayChars.members[idsBF[id]].flyingOffset = amount;
						}
					}else{
						if(isPlayer){
							if(idsBF[id] != null)
								PlayState.instance.layerBFs.members[idsBF[id]].flyingOffset = amount;
						}else{
							if(ids[id] != null)
								PlayState.instance.layerChars.members[ids[id]].flyingOffset = amount;
						}
					}
				});

				Lua_helper.add_callback(lua, "setScrollFactor", function(x:Float,y:Float,id:String){
					getActorByName(id).scrollFactor.set(x,y);
				});

				Lua_helper.add_callback(lua,"setDefaultCamZoom", function(zoomAmount:Float) {
					PlayState.instance.setDefaultZoom(zoomAmount);
				});

				Lua_helper.add_callback(lua,"setBotplaytextVisible", function(visible:Bool) {
					//FlxG.camera.zoom = zoomAmount;
					@:privateAccess
						PlayState.instance.botPlayState.visible = visible;
				});

				Lua_helper.add_callback(lua,"spritePlayAnim", function(id:String, anim:String, ?force:Bool = false, ?reverse:Bool=false){
					if(sprites[id] != null)
					sprites[id].animation.play(anim, force, reverse);
				});

				Lua_helper.add_callback(lua,"addAnim", function(id:String, name:String, prefix:String, ?fps:Int = 24, ?looped:Bool = false){
					if(sprites[id] != null)
						sprites[id].animation.addByPrefix(name, prefix, fps, looped);
					else{
						var r = new EReg("^[0-9]", "i");
						if(!r.match(id) && getActorByName(id) != null){
							getActorByName(id).animation.addByPrefix(name, prefix, fps, looped);
						}
					}
				});

				Lua_helper.add_callback(lua,"addOffset", function(char:String,anim:String,x:Float,y:Float, type:Int){
					switch(type){
						case 0:
							if(idsBF[char] != null)
							PlayState.instance.layerBFs.members[idsBF[char]].addOffset(anim,x,y);
						case 1:
							if(ids[char] != null)
							PlayState.instance.layerChars.members[ids[char]].addOffset(anim,x,y);
						case 2:
							if(gfs[char] != null)
							PlayState.instance.layerGF.members[gfs[char]].addOffset(anim,x,y);
					}
				});

				Lua_helper.add_callback(lua,"setAntialiasing", function(anti:Bool,id:String){
					if(FlxG.save.data.antialiasing)
						getActorByName(id).antialiasing = anti;
				});

				Lua_helper.add_callback(lua,"mustHit", function():Bool {
					return PlayState.instance.mustHitSection;
				});

				Lua_helper.add_callback(lua, "playAnim", function(character:String, animation:String, ?force:Bool = false){
					switch(character){
						case 'dad' | 'boyfriend' | 'girlfriend':
							getActorByName(character).playAnim(animation, force);
						default:
							if(PlayStateChangeables.flip){
								if(!sprites.exists(character) && idsBF.exists(character)){
									trace("Entro jugador en lado rival " + character);
									PlayState.instance.layerPlayChars.members[idsBF[character]].playAnim(animation,force);
								}else{
									if(character.length > 3)
										if(!sprites.exists(character) && ids.exists(character.substr(3))){
											trace("Entro rial en lado del jugador " + character.substr(3));
											PlayState.instance.layerFakeBFs.members[ids[character]].playAnim(animation,force);
										}
								}
							}else{
								if(!sprites.exists(character) && ids.exists(character)){
									trace("Entro rival " + character);
									PlayState.instance.layerChars.members[ids[character]].playAnim(animation,force);
								}else{
									if(character.length > 3)
										if(!sprites.exists(character) && idsBF.exists(character.substr(3))){
											trace("Entro jugador " + character.substr(3));
											PlayState.instance.layerBFs.members[idsBF[character]].playAnim(animation,force);
										}
								}
							}
					}
				});

				Lua_helper.add_callback(lua, "getScoreValue", function (property:String,?noteType:Int=0):Float {
					var value:Float = -31.4;
					if(PlayState.instance.healthValues.exists(""+noteType)){
						switch(property){
							case "shit":
							value = PlayState.instance.healthValues[""+noteType].get("score").get("shitScore");
							case "bad":
							value = PlayState.instance.healthValues[""+noteType].get("score").get("badScore");
							case "good":
							value = PlayState.instance.healthValues[""+noteType].get("score").get("goodScore");
							case "sick":
							value = PlayState.instance.healthValues[""+noteType].get("score").get("sickScore");
							case "miss":
							value = PlayState.instance.healthValues[""+noteType].get("score").get("missScore");
							case "missLN":
							value = PlayState.instance.healthValues[""+noteType].get("score").get("missLNScore");
						}
					}
					return value;
				});

				Lua_helper.add_callback(lua, "getHealthValue", function(property:String,?noteType:Int=0):Float{
					var value:Float = -31.4;
					if(PlayState.instance.healthValues.exists(""+noteType))
					switch(property){
						case "shit":
						value = PlayState.instance.healthValues[""+noteType].get(PlayState.instance.storyDifficultyText).get("shit");
						case "bad":
						value = PlayState.instance.healthValues[""+noteType].get(PlayState.instance.storyDifficultyText).get("bad");
						case "good":
						value = PlayState.instance.healthValues[""+noteType].get(PlayState.instance.storyDifficultyText).get("good");
						case "sick":
						value = PlayState.instance.healthValues[""+noteType].get(PlayState.instance.storyDifficultyText).get("sick");
						case "miss":
						value = PlayState.instance.healthValues[""+noteType].get(PlayState.instance.storyDifficultyText).get("miss");
						case "missLN":
						value = PlayState.instance.healthValues[""+noteType].get(PlayState.instance.storyDifficultyText).get("missLN");
					}
					if(property == "missPressed")
						value = PlayState.instance.healthValues["missPressed"].get(PlayState.instance.storyDifficultyText);
					
					return value;
				});

				Lua_helper.add_callback(lua,"jsonParse", function(file:String) {
					var object = {};
					var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
					switch (songLowercase) {
						case 'dad-battle': songLowercase = 'dadbattle';
						case 'philly-nice': songLowercase = 'philly';
					}
					var ruta:String = "assets/data/" + songLowercase + "/" + file +".json";
					if(sys.FileSystem.exists(ruta) ){
						object = cast Json.parse(sys.io.File.getContent( ruta ).trim());
					}
						trace("Object returned: "+object);
						return object;
				});

				Lua_helper.add_callback(lua,"getObjectProperty",function(id:String,property:String) {
					var obj:Dynamic;
					switch(id)
					{
						case 'this' | 'instance' | 'game':
							obj = PlayState.instance;
						case 'camera':
							obj = FlxG.camera;
						case 'hud':
							obj = PlayState.instance.camHUD;
						default:
							obj = getActorByName(id);
					}
					var split:Array<String> = property.split('.');
					for (i in 0...split.length){
						var aux:Dynamic = Reflect.getProperty(obj, split[i]);
						if (aux == null){
							obj = "null";
							break;
						}else
							obj = aux;
					}
					return obj;
				});

				Lua_helper.add_callback(lua,"setObjectProperty",function(id:String,property:String,value:Dynamic) {
					var obj:Dynamic;
					switch(id)
					{
						case 'this' | 'instance' | 'game':
							obj = PlayState.instance;
						case 'camera':
							obj = FlxG.camera;
						case 'hud':
							obj = PlayState.instance.camHUD;
						default:
							obj = getActorByName(id);
					}
					setPropertyFromString(obj,property,value);
				});

				Lua_helper.add_callback(lua,"setActorColor",function(id:String,red:Dynamic,?green:Int = -1,?blue:Int = -1,?alpha:Int = 255) {
					var sprite:FlxSprite = getActorByName(id);
					if(green == -1 || blue == -1){
						if(Std.is(red, String)){
							sprite.color = FlxColor.fromString(red);
						}
					}else if(Std.is(red, Int)){
						sprite.color = FlxColor.fromRGB(red,green,blue,alpha);
					}
				});

				Lua_helper.add_callback(lua,"setBlendMode",function(id:String,blend:String) {
					switch(blend.toLowerCase().trim()) {
						case 'add': getActorByName(id).blend = ADD;
						case 'alpha': getActorByName(id).blend = ALPHA;
						case 'darken': getActorByName(id).blend = DARKEN;
						case 'difference': getActorByName(id).blend = DIFFERENCE;
						case 'erase': getActorByName(id).blend = ERASE;
						case 'hardlight': getActorByName(id).blend = HARDLIGHT;
						case 'invert': getActorByName(id).blend = INVERT;
						case 'layer': getActorByName(id).blend = LAYER;
						case 'lighten': getActorByName(id).blend = LIGHTEN;
						case 'multiply': getActorByName(id).blend = MULTIPLY;
						case 'overlay': getActorByName(id).blend = OVERLAY;
						case 'screen': getActorByName(id).blend = SCREEN;
						case 'shader': getActorByName(id).blend = SHADER;
						case 'subtract': getActorByName(id).blend = SUBTRACT;
						default: getActorByName(id).blend = NORMAL;
					}
					
				});

				Lua_helper.add_callback(lua,"loadTrail", function(id:String,?Lenght:Int = 4,?Delay:Float = 12/60,?Alpha:Float = 0.3,?Diff:Float = 0.069):String {
					var character:Character;
					var name:String = "null";
					switch(id){
						/*case "boyfriend":
							character = getActorByName(id);
							var name:String = "sprite-" + character.curCharacter;
							if(!PlayStateChangeables.flip){
								name = "sprite-bf-" + character.curCharacter;
							}
							var trail:ui.DeltaTrail = new ui.DeltaTrail(character,null,Lenght,Delay,Alpha,Diff);
							PlayState.instance.layerTrails.add(trail);
							luaTrails.set(name,trail);
							trace("agregado trail "+name);*/
						case "boyfriend" | "dad":
							character = getActorByName(id);
							if(Std.is(getActorByName(id),Boyfriend))
								name = "trail-bf-" + character.curCharacter;
							else
								name = "trail-" + character.curCharacter;
							var trail:ui.DeltaTrail = new ui.DeltaTrail(character,null,Lenght,Delay,Alpha,Diff);
							PlayState.instance.layerTrails.add(trail);
							luaTrails.set(name,trail);
							trace("agregado trail "+name);
						default:
							if(PlayStateChangeables.flip){
								if(!sprites.exists(id) && idsBF.exists(id)){
									character = PlayState.instance.layerPlayChars.members[idsBF[id]];
									name = "trail-" + character.curCharacter;
									var trail:ui.DeltaTrail = new ui.DeltaTrail(character,null,Lenght,Delay,Alpha,Diff);
									PlayState.instance.layerTrails.add(trail);
									luaTrails.set(name,trail);
									trace("3 agregado trail "+name);
								}else{
									if(id.length > 3)
										if(!sprites.exists(id) && ids.exists(id.substr(3))){
											character = PlayState.instance.layerFakeBFs.members[ids[id]];
											name = "trail-" + character.curCharacter;
											var trail:ui.DeltaTrail = new ui.DeltaTrail(character,null,Lenght,Delay,Alpha,Diff);
											PlayState.instance.layerTrails.add(trail);
											luaTrails.set(name,trail);
											trace("3 agregado trail "+name);
										}
								}
							}else{
								if(!sprites.exists(id) && ids.exists(id)){
									character = PlayState.instance.layerChars.members[ids[id]];
									name = "trail-" + character.curCharacter;
									var trail:ui.DeltaTrail = new ui.DeltaTrail(character,null,Lenght,Delay,Alpha,Diff);
									PlayState.instance.layerTrails.add(trail);
									luaTrails.set(name,trail);
									trace("3 agregado trail "+name);
								}else{
									if(id.length > 3)
										if(!sprites.exists(id) && idsBF.exists(id.substr(3))){
											character = PlayState.instance.layerBFs.members[idsBF[id]];
											name = "trail-" + character.curCharacter;
											var trail:ui.DeltaTrail = new ui.DeltaTrail(character,null,Lenght,Delay,Alpha,Diff);
											PlayState.instance.layerTrails.add(trail);
											luaTrails.set(name,trail);
											trace("3 agregado trail "+name);
										}
								}
							}
					}
					return name;
				});

				Lua_helper.add_callback(lua,"createText", function(toBeCalled:String,text:String,size:Int = 30,?drawBehind:Dynamic=false,?font:String) {
					if(!sprites.exists(toBeCalled)){
						var textobj:FlxText = new FlxText(0,0,0,text,size);
						if(font!=null)
							textobj.setFormat("assets/fonts/" + font,size);
						sprites.set(toBeCalled,textobj);
						luaSprites.set(toBeCalled,textobj);
						addToLayer(drawBehind,textobj);
					}
				});

				Lua_helper.add_callback(lua,"changeFont", function(id:String,font:String) {
					if(sprites.exists(id)){
						if(Std.is(sprites.get(id), FlxText)){
							var text:FlxText = cast sprites.get(id);
							text.setFormat("assets/fonts/" + font,text.size);
						}
					}
				});

				Lua_helper.add_callback(lua,"pauseDialogue", function(seconds:Float){
					trace("delayed " + ((this.doof is DialogueBox) ? "intro" : "outro"));
					/*getDoof().pauseDialogue = true;
					var startFlag:Bool = false;
					@:privateAccess{
						startFlag = getDoof().dialogueOpened;
					}
					trace("Checking: "+startFlag);
					if(startFlag){
					new flixel.util.FlxTimer().start(seconds,
						function(timer:flixel.util.FlxTimer){
							getDoof().nextDialogue();
							getDoof().pauseDialogue=false;
						}
					);
					}else{
						getDoof().delayedDialogue(seconds);
					}*/
					@:privateAccess{
						if((this.doof is DialogueBox)){
							var box:DialogueBox = cast this.doof;
							box.pauseDialogue = true;
							if(box.dialogueOpened)
								new flixel.util.FlxTimer().start(seconds,
								function(timer:flixel.util.FlxTimer){
									box.nextDialogue();
									box.pauseDialogue=false;
								});
							else
								box.delayedDialogue(seconds);
						}else{
							PlayState.instance.doof2.pauseDialogue = true;
							if(PlayState.instance.doof2 != null && PlayState.instance.doof2.showDialog){
								var box:DialogueEnd = PlayState.instance.doof2;
								if(box.dialogueOpened)
									new flixel.util.FlxTimer().start(seconds,
									function(timer:flixel.util.FlxTimer){
										box.nextDialogue();
										box.pauseDialogue=false;
									});
								else
									box.delayedDialogue(seconds);
							}
						}
					}
				});

				Lua_helper.add_callback(lua,"isIntro", function():Bool{
					return (this.doof is DialogueBox);
				});

				Lua_helper.add_callback(lua,"setCamFollowPosition", function(x:Int,y:Int) {
					@:privateAccess
						PlayState.instance.camFollow.setPosition(x, y);
				});

				Lua_helper.add_callback(lua,"actorScreenCenter", function(id:String,axis:String="") {
					var spr:FlxSprite;
					spr = getActorByName(id);
					if (spr != null){
						switch(axis.toLowerCase()){
							case "y":
								spr.screenCenter(Y);
							case "x":
								spr.screenCenter(X);
							default:
								spr.screenCenter();
						}
					}
				});

				Lua_helper.add_callback(lua,"setColorTransform", function(id:String,rOffset:Int=0,gOffset:Int=0,bOffset:Int=0,aOffset:Int=255) {
					var spr:FlxSprite;
					spr = getActorByName(id);
					if(spr != null){
						spr.setColorTransform(1,1,1,1,rOffset,gOffset,bOffset,aOffset);
					}
				});

				// actors
				
				Lua_helper.add_callback(lua,"setActorX", function(x:Int,id:String) {
					getActorByName(id).x = x;
				});
				
				Lua_helper.add_callback(lua,"setActorAccelerationX", function(x:Int,id:String) {
					getActorByName(id).acceleration.x = x;
				});
				
				Lua_helper.add_callback(lua,"setActorDragX", function(x:Int,id:String) {
					getActorByName(id).drag.x = x;
				});
				
				Lua_helper.add_callback(lua,"setActorVelocityX", function(x:Int,id:String) {
					getActorByName(id).velocity.x = x;
				});
				
				Lua_helper.add_callback(lua,"playActorAnimation", function(id:String,anim:String,force:Bool = false,reverse:Bool = false) {
					getActorByName(id).playAnim(anim, force, reverse);
				});
	
				Lua_helper.add_callback(lua,"setActorAlpha", function(alpha:Float,id:String) {
					getActorByName(id).alpha = alpha;
				});
	
				Lua_helper.add_callback(lua,"setActorY", function(y:Int,id:String) {
					getActorByName(id).y = y;
				});

				Lua_helper.add_callback(lua,"setActorAccelerationY", function(y:Int,id:String) {
					getActorByName(id).acceleration.y = y;
				});
				
				Lua_helper.add_callback(lua,"setActorDragY", function(y:Int,id:String) {
					getActorByName(id).drag.y = y;
				});
				
				Lua_helper.add_callback(lua,"setActorVelocityY", function(y:Int,id:String) {
					getActorByName(id).velocity.y = y;
				});
				
				Lua_helper.add_callback(lua,"setActorAngle", function(angle:Int,id:String) {
					getActorByName(id).angle = angle;
				});
	
				Lua_helper.add_callback(lua,"setActorScale", function(scale:Float,id:String) {
					getActorByName(id).setGraphicSize(Std.int(getActorByName(id).width * scale));
				});
				
				Lua_helper.add_callback(lua, "setActorScaleXY", function(scaleX:Float, scaleY:Float, id:String)
				{
					getActorByName(id).setGraphicSize(Std.int(getActorByName(id).width * scaleX), Std.int(getActorByName(id).height * scaleY));
				});
	
				Lua_helper.add_callback(lua, "setActorFlipX", function(flip:Bool, id:String)
				{
					getActorByName(id).flipX = flip;
					@:privateAccess{
						if(id=="healthbar"){
							if(flip){
								PlayState.instance.healthBar.flipX = false;
							}
						}
						
					}
				});

				Lua_helper.add_callback(lua, "setActorFlipY", function(flip:Bool, id:String)
				{
					getActorByName(id).flipY = flip;
				});
	
				Lua_helper.add_callback(lua,"getActorWidth", function (id:String) {
					return getActorByName(id).width;
				});
	
				Lua_helper.add_callback(lua,"getActorHeight", function (id:String) {
					return getActorByName(id).height;
				});
	
				Lua_helper.add_callback(lua,"getActorAlpha", function(id:String) {
					return getActorByName(id).alpha;
				});
	
				Lua_helper.add_callback(lua,"getActorAngle", function(id:String) {
					return getActorByName(id).angle;
				});
	
				Lua_helper.add_callback(lua,"getActorX", function (id:String) {
					return getActorByName(id).x;
				});
	
				Lua_helper.add_callback(lua,"getActorY", function (id:String) {
					return getActorByName(id).y;
				});

				Lua_helper.add_callback(lua,"setWindowPos",function(x:Int,y:Int) {
					Application.current.window.x = x;
					Application.current.window.y = y;
				});

				Lua_helper.add_callback(lua,"getWindowX",function() {
					return Application.current.window.x;
				});

				Lua_helper.add_callback(lua,"getWindowY",function() {
					return Application.current.window.y;
				});

				Lua_helper.add_callback(lua,"resizeWindow",function(Width:Int,Height:Int) {
					Application.current.window.resize(Width,Height);
				});
				
				Lua_helper.add_callback(lua,"getScreenWidth",function() {
					return Application.current.window.display.currentMode.width;
				});

				Lua_helper.add_callback(lua,"getScreenHeight",function() {
					return Application.current.window.display.currentMode.height;
				});

				Lua_helper.add_callback(lua,"getWindowWidth",function() {
					return Application.current.window.width;
				});

				Lua_helper.add_callback(lua,"getWindowHeight",function() {
					return Application.current.window.height;
				});

	
				// tweens
				
				Lua_helper.add_callback(lua,"tweenCameraPos", function(toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {x: toX, y: toY}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});
								
				Lua_helper.add_callback(lua,"tweenCameraAngle", function(toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {angle:toAngle}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenCameraZoom", function(toZoom:Float, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {zoom:toZoom}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenHudPos", function(toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {x: toX, y: toY}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});
								
				Lua_helper.add_callback(lua,"tweenHudAngle", function(toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {angle:toAngle}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenHudZoom", function(toZoom:Float, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {zoom:toZoom}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenPos", function(id:String, toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, y: toY}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosXAngle", function(id:String, toX:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, angle: toAngle}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosYAngle", function(id:String, toY:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {y: toY, angle: toAngle}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenAngle", function(id:String, toAngle:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {angle: toAngle}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});

				Lua_helper.add_callback(lua,"tweenCameraPosOut", function(toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {x: toX, y: toY}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});
								
				Lua_helper.add_callback(lua,"tweenCameraAngleOut", function(toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {angle:toAngle}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenCameraZoomOut", function(toZoom:Float, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {zoom:toZoom}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenHudPosOut", function(toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {x: toX, y: toY}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});
								
				Lua_helper.add_callback(lua,"tweenHudAngleOut", function(toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {angle:toAngle}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenHudZoomOut", function(toZoom:Float, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {zoom:toZoom}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenPosOut", function(id:String, toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, y: toY}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosXAngleOut", function(id:String, toX:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, angle: toAngle}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosYAngleOut", function(id:String, toY:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {y: toY, angle: toAngle}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenAngleOut", function(id:String, toAngle:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {angle: toAngle}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});

				Lua_helper.add_callback(lua,"tweenCameraPosIn", function(toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {x: toX, y: toY}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});
								
				Lua_helper.add_callback(lua,"tweenCameraAngleIn", function(toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {angle:toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenCameraZoomIn", function(toZoom:Float, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {zoom:toZoom}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenHudPosIn", function(toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {x: toX, y: toY}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});
								
				Lua_helper.add_callback(lua,"tweenHudAngleIn", function(toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {angle:toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenHudZoomIn", function(toZoom:Float, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {zoom:toZoom}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenPosIn", function(id:String, toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, y: toY}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosXAngleIn", function(id:String, toX:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosYAngleIn", function(id:String, toY:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {y: toY, angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenAngleIn", function(id:String, toAngle:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenFadeIn", function(id:String, toAlpha:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {alpha: toAlpha}, time, {ease: FlxEase.circIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenFadeOut", function(id:String, toAlpha:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {alpha: toAlpha}, time, {ease: FlxEase.circOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});

				//forgot and accidentally commit to master branch
				// shader
				
				/*Lua_helper.add_callback(lua,"createShader", function(frag:String,vert:String) {
					var shader:LuaShader = new LuaShader(frag,vert);

					trace(shader.glFragmentSource);

					shaders.push(shader);
					// if theres 1 shader we want to say theres 0 since 0 index and length returns a 1 index.
					return shaders.length == 1 ? 0 : shaders.length;
				});

				
				Lua_helper.add_callback(lua,"setFilterHud", function(shaderIndex:Int) {
					PlayState.instance.camHUD.setFilters([new ShaderFilter(shaders[shaderIndex])]);
				});

				Lua_helper.add_callback(lua,"setFilterCam", function(shaderIndex:Int) {
					FlxG.camera.setFilters([new ShaderFilter(shaders[shaderIndex])]);
				});*/

				// default strums

				for (i in 0...PlayState.strumLineNotes.length) {
					var member = PlayState.strumLineNotes.members[i];
					//setVar("strum" + i + "X", Math.floor(member.x));
					setVar("defaultStrum" + i + "X", Math.floor(member.x));
					//setVar("strum" + i + "Y", Math.floor(member.y));
					setVar("defaultStrum" + i + "Y", Math.floor(member.y));
					//setVar("strum" + i + "Angle", Math.floor(member.angle));
					setVar("defaultStrum" + i + "Angle", Math.floor(member.angle));
				}
    }

	public function changeIcon(char:String, isPlayer, ?isCustom:Bool = false){
		var suffix:String = "-flipped";
        if (char.endsWith(suffix)) {
            char = char.substr(0, char.length - suffix.length);
        } 
		if(isPlayer){
			if(isCustom){
				PlayState.instance.iconP1.alpha = 0.001;
				PlayState.instance.animatedIcons[char].alpha = 1;
				PlayState.instance.iconP1 = PlayState.instance.animatedIcons[char];
				flags[0] = true;
			}else{
				if(flags[0]){
					PlayState.instance.iconP1.alpha = 0.001;
					PlayState.instance.animatedIcons["default1"].alpha = 1;
					PlayState.instance.iconP1 = PlayState.instance.animatedIcons["default1"];
					flags[0] = false;
				}
			}
			PlayState.instance.iconP1.char = char;
			PlayState.instance.iconP1.animation.play(char);
		}else{
			if(isCustom){
				PlayState.instance.iconP2.alpha = 0.001;
				PlayState.instance.animatedIcons[char + "2"].alpha = 1;
				PlayState.instance.iconP2 = PlayState.instance.animatedIcons[char + "2"];
				flags[1] = true;
			}else{
				if(flags[1]){
					PlayState.instance.iconP2.alpha = 0.001;
					PlayState.instance.animatedIcons["default2"].alpha = 1;
					PlayState.instance.iconP2 = PlayState.instance.animatedIcons["default2"];
					flags[1] = false;
				}
			}
			PlayState.instance.iconP2.char = char;
			PlayState.instance.iconP2.animation.play(char);
		}
	}

    public function executeState(name,args:Array<Dynamic>)
    {
        return Lua.tostring(lua,callLua(name, args));
    }

    public static function createDialogueLUAState(doof:Dynamic):DialogueLUA
    {
        return new DialogueLUA(doof);
    }

	public function setDialogueBox(doof:DialogueEnd)
    {
        if(this.doof != null){
			var box:DialogueBox = cast this.doof;
			for(i in 0...box.layerBGs.length){
				for(spr in box.layerBGs[i].members){
					doof.layerBGs[i].add(spr);
				}
				box.layerBGs[i].clear();
			}
		}
		this.doof = doof;
    }

	private function addToLayer(layer:Dynamic,sprite:FlxSprite):Void{
		if (layer == null) layer = false;
		trace("agregando sprite en capa " + layer);
		@:privateAccess
		{
			switch(""+layer){
				case "0":
					PlayState.instance.layerBGs[0].add(sprite); //behind characters in stage and GF
				case "1":
					PlayState.instance.layerBGs[1].add(sprite); //between GF and characters in stage
				case "2":
					getDoof().layerBGs[0].add(sprite); //behind dialogue box BG
				case "3" | "true":
					getDoof().layerBGs[1].add(sprite); //between dialogue box BG and portraits
				case "4":
					getDoof().layerBGs[2].add(sprite); //between portraits and text
				case "5":
					getDoof().layerBGs[3].add(sprite); //in front of everything
				default:
					if(PlayState.luaModchart != null && PlayState.luaModchart.layers.exists(""+layer)){
						PlayState.luaModchart.layers.get(""+layer).add(sprite);
						trace("agregado en capa: "+layer);
					}else
						PlayState.instance.layerBGs[2].add(sprite); //in front of characters in stage
			}
		}
	}

    private function setPropertyFromString(obj:Dynamic, path:String, value:Dynamic):Void { //thanks chatGPT
        // Split the path into parts
        var parts:Array<String> = path.split(".");

        // Traverse the object hierarchy
        var currentObj:Dynamic = obj;
        for (part in parts) {
            if (Reflect.getProperty(currentObj, part) != null) {
                // Check if the current part exists as a field
                if (part == parts[parts.length - 1]) {
                    // If it's the last part, set the value
                    Reflect.setProperty(currentObj, part, value);
                } else {
                    // Otherwise, update the current object
                    currentObj = Reflect.getProperty(currentObj, part);
                }
            } else {
                // If any part of the path does not exist, return
                trace("Path does not exist: " + path);
                return;
            }
        }
    }

	private function getDoof():Dynamic{
		if((this.doof is DialogueEnd)){
			var box2:DialogueEnd = cast this.doof;
			return box2;
		}
		var box:DialogueBox = cast this.doof;
		return box;
	}
}
#end
