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

class ModchartState 
{
	//public static var shaders:Array<LuaShader> = null;

	public static var lua:State = null;
	private var ids:Map<String,Int> = [PlayState.SONG.player2 => 0];
	private var idsBF:Map<String,Int> = [PlayState.SONG.player1 => 0];
	public var gfs:Map<String, Int> = [PlayState.gf.curCharacter => 0];
	public var layers:Map<String, flixel.group.FlxGroup.FlxTypedGroup<FlxSprite>> = [];
	private var sprites:Map<String, FlxSprite> = [];
	private var curChar = 0;
	private var curBF = 0;
	private var curGF = 0;
	private var flags:Array<Bool> = [false,false];
	private var allowChanging:Bool = true;

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
		}
		// lua objects or what ever
		if (luaSprites.get(id) == null)
		{
			if (Std.parseInt(id) == null)
				return Reflect.getProperty(PlayState.instance,id);
			return PlayState.PlayState.strumLineNotes.members[Std.parseInt(id)];
		}
		return luaSprites.get(id);
	}

	function getPropertyByName(id:String)
	{
		return Reflect.field(PlayState.instance,id);
	}

	public static var luaSprites:Map<String,FlxSprite> = [];

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

	function changeMania(newMania:Int)
	{
		PlayState.instance.switchMania(newMania);
	}

	/*function makeAnimatedLuaSprite(spritePath:String,names:Array<String>,prefixes:Array<String>,startAnim:String, id:String)
	{
		#if sys
		// pre lowercasing the song name (makeAnimatedLuaSprite)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}

		var data:BitmapData = BitmapData.fromFile(Sys.getCwd() + "assets/data/" + songLowercase + '/' + spritePath + ".png");

		var sprite:FlxSprite = new FlxSprite(0,0);

		sprite.frames = FlxAtlasFrames.fromSparrow(FlxGraphic.fromBitmapData(data), Sys.getCwd() + "assets/data/" + songLowercase + "/" + spritePath + ".xml");

		trace(sprite.frames.frames.length);

		for (p in 0...names.length)
		{
			var i = names[p];
			var ii = prefixes[p];
			sprite.animation.addByPrefix(i,ii,24,false);
		}

		luaSprites.set(id,sprite);

        PlayState.instance.addObject(sprite);

		sprite.animation.play(startAnim);
		return id;
		#end
	}*/

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

    function new(?fromStage:Bool=false)
    {
        		trace('opening a lua state (because we are cool :))');
				lua = LuaL.newstate();
				LuaL.openlibs(lua);
				trace("Lua version: " + Lua.version());
				trace("LuaJIT version: " + Lua.versionJIT());
				Lua.init_callbacks(lua);
				
				//shaders = new Array<LuaShader>();

				// pre lowercasing the song name (new)
				var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
				switch (songLowercase) {
					case 'dad-battle': songLowercase = 'dadbattle';
					case 'philly-nice': songLowercase = 'philly';
				}

				var result;
				if(fromStage){
					var luaRoute = "assets/stages/"+PlayState.curStage+"/modchart.lua";
					result = LuaL.dofile(lua,luaRoute);
					//result = LuaL.dofile(lua, Paths.lua(luaRoute));
					trace("Loaded lua from stage: " + PlayState.curStage);
				}else
					result = LuaL.dofile(lua, Paths.lua(songLowercase + "/modchart")); // execute le file
	
				if (result != 0)
				{
					Application.current.window.alert("LUA COMPILE ERROR:\n" + Lua.tostring(lua,result),"Kade Engine Modcharts");
					lua = null;
					LoadingState.loadAndSwitchState(new MainMenuState());
				}

				// get some fukin globals up in here bois
	
				setVar("difficulty", PlayState.storyDifficulty);
				setVar("bpm", Conductor.bpm);
				setVar("scrollspeed", FlxG.save.data.scrollSpeed != 1 ? FlxG.save.data.scrollSpeed : PlayState.SONG.speed);
				setVar("fpsCap", FlxG.save.data.fpsCap);
				setVar("downscroll", FlxG.save.data.downscroll);
				setVar("flashing", FlxG.save.data.flashing);
				setVar("distractions", FlxG.save.data.distractions);
				setVar("optimization",PlayStateChangeables.Optimize);
	
				setVar("curStep", 0);
				setVar("curBeat", 0);
				setVar("crochet", Conductor.stepCrochet);
				setVar("safeZoneOffset", Conductor.safeZoneOffset);
	
				setVar("hudZoom", PlayState.instance.camHUD.zoom);
				setVar("cameraZoom", FlxG.camera.zoom);
	
				setVar("cameraAngle", FlxG.camera.angle);
				setVar("camHudAngle", PlayState.instance.camHUD.angle);
	
				setVar("followXOffset",0);
				setVar("followYOffset",0);
	
				setVar("showOnlyStrums", false);
				setVar("strumLine1Visible", true);
				setVar("strumLine2Visible", true);
	
				setVar("screenWidth",FlxG.width);
				setVar("screenHeight",FlxG.height);
				setVar("windowWidth",FlxG.width);
				setVar("windowHeight",FlxG.height);
				setVar("hudWidth", PlayState.instance.camHUD.width);
				setVar("hudHeight", PlayState.instance.camHUD.height);
	
				setVar("mustHit", false);

				setVar("strumLineY", PlayState.instance.strumLine.y);

				setVar("playingAsRival", PlayStateChangeables.flip);
				setVar("playingAsBoth", PlayStateChangeables.bothSide);
				setVar("keyAmount", PlayState.keyAmmo[PlayState.mania]);

				setVar("dadFadeAlpha", 0.001);
				setVar("bfFadeAlpha", 0.001);
				setVar("gfFadeAlpha", 0.001);
				flags[0] = PlayState.instance.iconP1.isCustom;
				flags[1] = PlayState.instance.iconP2.isCustom;
				allowChanging = PlayStateChangeables.allowChanging;

				var character:String = PlayState.SONG.player1;
				if(PlayState.instance.iconP1.isCustom){
					PlayState.instance.animatedIcons[character] = new HealthIcon(character,true);
					PlayState.instance.animatedIcons[character].y = PlayState.instance.iconP1.y;
					PlayState.instance.animatedIcons[character].alpha = 0.001;
					PlayState.instance.layerIcons.add(PlayState.instance.animatedIcons[character]);
				}
				character = PlayState.SONG.player2;
				if(PlayState.instance.iconP2.isCustom){
					PlayState.instance.animatedIcons[character+"2"] = new HealthIcon(character,false);
					PlayState.instance.animatedIcons[character+"2"].y = PlayState.instance.iconP2.y;
					PlayState.instance.animatedIcons[character+"2"].alpha = 0.001;
					PlayState.instance.layerIcons.add(PlayState.instance.animatedIcons[character+"2"]);
				}
				if(PlayStateChangeables.flip){
					ids.clear();
					idsBF.clear();
					ids = [PlayState.SONG.player1 => 0];
					idsBF = [PlayState.SONG.player2 => 0];
					luaSprites.set("bf-" + PlayState.SONG.player1, PlayState.instance.layerFakeBFs.members[0]);
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
					idsBF.set("bf-" + PlayState.SONG.player1, 0);
					if(PlayState.SONG.player2 == "dad"){
						luaSprites.set("daddy", PlayState.instance.layerChars.members[0]);
						ids.set("daddy",0);
					}else{
						luaSprites.set(PlayState.SONG.player2, PlayState.instance.layerChars.members[0]);
						ids.set(PlayState.SONG.player2, 0);
					}
				}
				
				// callbacks
	
				// sprites
	
				Lua_helper.add_callback(lua,"makeSprite", makeLuaSprite);
				
				Lua_helper.add_callback(lua,"changeDadCharacter", changeDadCharacter);

				Lua_helper.add_callback(lua,"changeBoyfriendCharacter", changeBoyfriendCharacter);

				Lua_helper.add_callback(lua,"changeGirlfriendCharacter", changeGirlfriendCharacter);

				Lua_helper.add_callback(lua,"changeMania", changeMania);
	
				Lua_helper.add_callback(lua,"getProperty", getPropertyByName);

				Lua_helper.add_callback(lua,"setNoteWiggle", function(wiggleId) {
					PlayState.instance.camNotes.setFilters([new ShaderFilter(luaWiggles.get(wiggleId).shader)]);
				});
				
				Lua_helper.add_callback(lua,"setSustainWiggle", function(wiggleId) {
					PlayState.instance.camSustains.setFilters([new ShaderFilter(luaWiggles.get(wiggleId).shader)]);
				});

				Lua_helper.add_callback(lua,"createWiggle", function(freq:Float,amplitude:Float,speed:Float) {
					var wiggle = new WiggleEffect();
					wiggle.waveAmplitude = amplitude;
					wiggle.waveSpeed = speed;
					wiggle.waveFrequency = freq;

					var id = Lambda.count(luaWiggles) + 1 + "";

					luaWiggles.set(id,wiggle);
					return id;
				});

				Lua_helper.add_callback(lua,"setWiggleTime", function(wiggleId:String,time:Float) {
					var wiggle = luaWiggles.get(wiggleId);

					wiggle.shader.uTime.value = [time];
				});

				
				Lua_helper.add_callback(lua,"setWiggleAmplitude", function(wiggleId:String,amp:Float) {
					var wiggle = luaWiggles.get(wiggleId);

					wiggle.waveAmplitude = amp;
				});

				
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
				
				Lua_helper.add_callback(lua,"setHealth", function (heal:Float) {
					PlayState.instance.health = heal;
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

				Lua_helper.add_callback(lua, "loadCharacter", function(character:String,x:Float,y:Float,?isPlayer:Bool = false,?sync:Bool = false){
					if(allowChanging){
						if(isPlayer){
							if(PlayStateChangeables.flip){
								var bf:Character = new Character(x,y,character,true,sync);
								trace("loaded rival (bf side): " + character);
								PlayState.instance.layerFakeBFs.add(bf);
								ids[character] = PlayState.instance.layerFakeBFs.members.length-1;
								luaSprites.set("bf-" + character, PlayState.instance.layerFakeBFs.members[ids[character]]);
								bf.active = false;
								bf.hasFocus = false;
								bf.alpha = getVar("dadFadeAlpha","float");
								if(bf.isCustom){
									PlayState.instance.animatedIcons[character] = new HealthIcon(character,true);
									PlayState.instance.animatedIcons[character].y = PlayState.instance.iconP1.y;
									PlayState.instance.animatedIcons[character].alpha = 0.001;
									PlayState.instance.layerIcons.add(PlayState.instance.animatedIcons[character]);
									if(!PlayState.instance.colorsMap.exists(character) && bf.colorCode.length > 0)
										PlayState.instance.colorsMap.set(character, FlxColor.fromRGB(bf.colorCode[0],bf.colorCode[1],bf.colorCode[2]));
								}
							}else{
								var bf:Boyfriend = new Boyfriend(x,y,character,true,sync);
								trace("loaded player: " + character);
								PlayState.instance.layerBFs.add(bf);
								idsBF[character] = PlayState.instance.layerBFs.members.length-1;
								luaSprites.set("bf-" + character, PlayState.instance.layerBFs.members[idsBF[character]]);
								bf.active = false;
								bf.hasFocus = false;
								bf.alpha = getVar("bfFadeAlpha","float");
								if(bf.isCustom){
									PlayState.instance.animatedIcons[character] = new HealthIcon(character,true);
									PlayState.instance.animatedIcons[character].y = PlayState.instance.iconP1.y;
									PlayState.instance.animatedIcons[character].alpha = 0.001;
									PlayState.instance.layerIcons.add(PlayState.instance.animatedIcons[character]);
									if(!PlayState.instance.colorsMap.exists(character) && bf.colorCode.length > 0)
										PlayState.instance.colorsMap.set(character, FlxColor.fromRGB(bf.colorCode[0],bf.colorCode[1],bf.colorCode[2]));
								}
							}
						}else{
							if(PlayStateChangeables.flip){
								var char:Boyfriend = new Boyfriend(x,y,character,false,sync);
								trace("loaded bf? (rival side): " + character);
								PlayState.instance.layerPlayChars.add(char);
								idsBF[character] = PlayState.instance.layerPlayChars.members.length-1;
								if(character == "dad")
									luaSprites.set("daddy", PlayState.instance.layerPlayChars.members[idsBF[character]]);
								else
									luaSprites.set(character, PlayState.instance.layerPlayChars.members[idsBF[character]]);
								char.active = false;
								char.hasFocus = false;
								//char.alpha = 0.5;
								char.alpha = getVar("bfFadeAlpha","float");
								if(char.isCustom){
									PlayState.instance.animatedIcons[character + "2"] = new HealthIcon(character,false);
									PlayState.instance.animatedIcons[character + "2"].y = PlayState.instance.iconP2.y;
									PlayState.instance.animatedIcons[character + "2"].alpha = 0.001;
									PlayState.instance.layerIcons.add(PlayState.instance.animatedIcons[character + "2"]);
									if(!PlayState.instance.colorsMap.exists(character) && char.colorCode.length > 0)
										PlayState.instance.colorsMap.set(character, FlxColor.fromRGB(char.colorCode[0],char.colorCode[1],char.colorCode[2]));
								}
							}else{
								var char:Character = new Character(x,y,character,false,sync);
								trace("loaded rival: " + character);
								PlayState.instance.layerChars.add(char);
								ids[character] = PlayState.instance.layerChars.members.length-1;
								if(character == "dad")
									luaSprites.set("daddy", PlayState.instance.layerChars.members[ids[character]]);
								else
									luaSprites.set(character, PlayState.instance.layerChars.members[ids[character]]);
								char.active = false;
								char.hasFocus = false;
								char.alpha = getVar("dadFadeAlpha","float");
								if(char.isCustom){
									PlayState.instance.animatedIcons[character + "2"] = new HealthIcon(character,false);
									PlayState.instance.animatedIcons[character + "2"].y = PlayState.instance.iconP2.y;
									PlayState.instance.animatedIcons[character + "2"].alpha = 0.001;
									PlayState.instance.layerIcons.add(PlayState.instance.animatedIcons[character + "2"]);
									if(!PlayState.instance.colorsMap.exists(character) && char.colorCode.length > 0)
										PlayState.instance.colorsMap.set(character, FlxColor.fromRGB(char.colorCode[0],char.colorCode[1],char.colorCode[2]));
								}
							}
						}
					}else{					
						if(isPlayer){
							if(PlayState.instance.animatedIcons["default1"].animation.getByName(character) == null){
								PlayState.instance.animatedIcons[character] = new HealthIcon(character,true);
								PlayState.instance.animatedIcons[character].y = PlayState.instance.iconP1.y;
								PlayState.instance.animatedIcons[character].alpha = 0.001;
								PlayState.instance.layerIcons.add(PlayState.instance.animatedIcons[character]);
							}
						}else{
							if(PlayState.instance.animatedIcons["default2"].animation.getByName(character) == null){
								PlayState.instance.animatedIcons[character + "2"] = new HealthIcon(character,false);
								PlayState.instance.animatedIcons[character + "2"].y = PlayState.instance.iconP2.y;
								PlayState.instance.animatedIcons[character + "2"].alpha = 0.001;
								PlayState.instance.layerIcons.add(PlayState.instance.animatedIcons[character + "2"]);
							}
						}
					}
					return character;
				});

				Lua_helper.add_callback(lua, "loadGirlfriend", function(personaje:String, x:Float, y:Float){
					if(allowChanging){
						var char = new Character(x,y,personaje);
						char.active = false;
						char.alpha = getVar("gfFadeAlpha","float");
						char.scrollFactor.set(0.95, 0.95);
						PlayState.instance.layerGF.add(char);
						gfs[personaje] = PlayState.instance.layerGF.members.length-1;
						luaSprites.set(personaje, PlayState.instance.layerGF.members[gfs[personaje]]);
					}
					return personaje;
				});

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

				Lua_helper.add_callback(lua, "changeNoteStyle", function(style:String,?mode:Int=0)
				{
					PlayState.instance.changeStyle(style,mode);
				});
	
				Lua_helper.add_callback(lua, "shakeCam", function(intensity:Float, duration:Float){
					@:privateAccess
					FlxG.camera.shake(intensity, duration);
				});

				Lua_helper.add_callback(lua, "flash", function(red:Int, green:Int, blue:Int, duration:Float){
					@:privateAccess
						FlxG.camera.flash(flixel.util.FlxColor.fromRGB(red, green, blue, 255), duration);
				});

				Lua_helper.add_callback(lua, "heal", function (heal:Float) {
					PlayState.instance.health += heal;
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

				Lua_helper.add_callback(lua,"setGhostTapping", function(mode:Int) {
					switch(mode){
						case 0:
							PlayStateChangeables.ghost = false;
						case 1:
							PlayStateChangeables.ghost = true;
						case 2:
							PlayStateChangeables.ghost = FlxG.save.data.ghost;
					}
				});

				Lua_helper.add_callback(lua,"changeSpeed", function(speed:Float) {
					if(speed > 0){
						if(speed == PlayState.SONG.speed){
							PlayStateChangeables.scrollSpeed = 1;
						}else{
							PlayStateChangeables.scrollSpeed = speed;
						}
					}
				});

				Lua_helper.add_callback(lua,"characterFocusFactor", function(distance:Float) {
					if(!PlayStateChangeables.Optimize){
						var d:Float = distance;
						if(distance < 0)
							d = distance * -1;
						PlayState.instance.camFactor = d;
					}
				});

				Lua_helper.add_callback(lua,"tweenStrumAngle", function(id:Int, toAngle:Int, time:Float, ?finalAngle:Int) {
					var a:Int = toAngle;
					var f:Int = 0;
					if(finalAngle == null)
						f = toAngle;
					if(a < 720 && a >= 360){
						a -= 360;
					}
					if(a > -720 && a <= -360){
						a += 360;
					}
					if(id >= 0 && id <= PlayState.keyAmmo[PlayState.mania]-1){
						trace("twist cpu " + id);
						FlxTween.tween(PlayState.cpuStrums.members[id], {angle: toAngle}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) {PlayState.cpuStrums.members[id].angle = f; }});
					}
					if(id >= PlayState.keyAmmo[PlayState.mania] && id <= (PlayState.keyAmmo[PlayState.mania]*2)-1){
						trace("twist player " + id);
						FlxTween.tween(PlayState.playerStrums.members[id - PlayState.keyAmmo[PlayState.mania]], {angle: toAngle}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) {PlayState.playerStrums.members[id - PlayState.keyAmmo[PlayState.mania]].angle = f; }});
					}
				});

				Lua_helper.add_callback(lua,"spritePlayAnim", function(id:String, anim:String, ?force:Bool = false, ?reverse:Bool=false){
					if(sprites[id] != null)
					sprites[id].animation.play(anim, force, reverse);
				});

				Lua_helper.add_callback(lua,"addAnim", function(id:String, name:String, prefix:String, ?fps:Int = 24, ?looped:Bool = false){
					if(sprites[id] != null)
						sprites[id].animation.addByPrefix(name, prefix, fps, looped);
					else{
						var r = new EReg("^[0-7]", "i");
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

				Lua_helper.add_callback(lua,"preloadNotes", function():Int {
					PlayState.instance.preloadNotes(true);
					return 0;
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

				Lua_helper.add_callback(lua, "setHealthValue", function (property:String,value:Float,?noteType:Int=0,?setDamage) {
					if(PlayStateChangeables.botPlay && value < 0){
						value = value * -1;
					}
					if(PlayState.instance.healthValues.exists(""+noteType)){
						switch(property){
							case "shit":
							PlayState.instance.healthValues[""+noteType].get(PlayState.instance.storyDifficultyText).set("shit",value);
							case "bad":
							PlayState.instance.healthValues[""+noteType].get(PlayState.instance.storyDifficultyText).set("bad",value);
							case "good":
							PlayState.instance.healthValues[""+noteType].get(PlayState.instance.storyDifficultyText).set("good",value);
							case "sick":
							PlayState.instance.healthValues[""+noteType].get(PlayState.instance.storyDifficultyText).set("sick",value);
							case "miss":
							PlayState.instance.healthValues[""+noteType].get(PlayState.instance.storyDifficultyText).set("miss",value);
							case "missLN":
							PlayState.instance.healthValues[""+noteType].get(PlayState.instance.storyDifficultyText).set("missLN",value);
							case "longN":
							PlayState.instance.healthValues[""+noteType].get(PlayState.instance.storyDifficultyText).set("longN",value);
						}
						if(setDamage != null && noteType != 4){
							PlayState.instance.healthValues[""+noteType].set("damage",setDamage);
						}
						if(property == "missPressed"){
							PlayState.instance.healthValues["missPressed"].set(PlayState.instance.storyDifficultyText,value);
							trace(property + " is: " + PlayState.instance.healthValues["missPressed"].get(PlayState.instance.storyDifficultyText));
						}else
						trace(property + " is: " + PlayState.instance.healthValues[""+noteType].get(PlayState.instance.storyDifficultyText).get(property) + " damage note set to:"
							+ PlayState.instance.healthValues[""+noteType].get("damage"));
					}
				});

				Lua_helper.add_callback(lua, "setScoreValue", function (property:String,value:Float,?noteType:Int=0) {
					if(PlayState.instance.healthValues.exists(""+noteType)){
						switch(property){
							case "shit":
							PlayState.instance.healthValues[""+noteType].get("score").set("shitScore",value);
							case "bad":
							PlayState.instance.healthValues[""+noteType].get("score").set("badScore",value);
							case "good":
							PlayState.instance.healthValues[""+noteType].get("score").set("goodScore",value);
							case "sick":
							PlayState.instance.healthValues[""+noteType].get("score").set("sickScore",value);
							case "miss":
							PlayState.instance.healthValues[""+noteType].get("score").set("missScore",value);
							case "missLN":
							PlayState.instance.healthValues[""+noteType].get("score").set("missLNScore",value);
							case "longN":
							PlayState.instance.healthValues[""+noteType].get("score").set("LNScore",value);
						}
						trace(property + " is: " + PlayState.instance.healthValues[""+noteType].get("score").get(property+"Score"));
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
							case "longN":
							value = PlayState.instance.healthValues[""+noteType].get("score").get("LNScore");
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
						case "longN":
						value = PlayState.instance.healthValues[""+noteType].get(PlayState.instance.storyDifficultyText).get("longN");
					}
					if(property == "missPressed")
						value = PlayState.instance.healthValues["missPressed"].get(PlayState.instance.storyDifficultyText);
					
					return value;
				});

				Lua_helper.add_callback(lua,"setGoldAnim", function(anim:String, isPlayer:Bool):Void {
					var id:Int = 0;
					if(PlayStateChangeables.flip)
						isPlayer = !isPlayer;
					if(!isPlayer)
						id = 1;
					PlayState.instance.goldAnim[id] = anim;
				});
				// actors
				
				Lua_helper.add_callback(lua,"getRenderedNotes", function() {
					return PlayState.instance.notes.length;
				});
	
				Lua_helper.add_callback(lua,"getRenderedNoteX", function(id:Int) {
					return PlayState.instance.notes.members[id].x;
				});
	
				Lua_helper.add_callback(lua,"getRenderedNoteY", function(id:Int) {
					return PlayState.instance.notes.members[id].y;
				});

				Lua_helper.add_callback(lua,"getRenderedNoteType", function(id:Int) {
					return PlayState.instance.notes.members[id].noteData;
				});

				Lua_helper.add_callback(lua,"isSustain", function(id:Int) {
					return PlayState.instance.notes.members[id].isSustainNote;
				});

				Lua_helper.add_callback(lua,"isParentSustain", function(id:Int) {
					return PlayState.instance.notes.members[id].prevNote.isSustainNote;
				});

				
				Lua_helper.add_callback(lua,"getRenderedNoteParentX", function(id:Int) {
					return PlayState.instance.notes.members[id].prevNote.x;
				});

				Lua_helper.add_callback(lua,"getRenderedNoteParentY", function(id:Int) {
					return PlayState.instance.notes.members[id].prevNote.y;
				});

				Lua_helper.add_callback(lua,"getRenderedNoteHit", function(id:Int) {
					return PlayState.instance.notes.members[id].mustPress;
				});

				Lua_helper.add_callback(lua,"getRenderedNoteCalcX", function(id:Int) {
					if (PlayState.instance.notes.members[id].mustPress)
						return PlayState.playerStrums.members[Math.floor(Math.abs(PlayState.instance.notes.members[id].noteData))].x;
					return PlayState.strumLineNotes.members[Math.floor(Math.abs(PlayState.instance.notes.members[id].noteData))].x;
				});

				Lua_helper.add_callback(lua,"anyNotes", function() {
					return PlayState.instance.notes.members.length != 0;
				});

				Lua_helper.add_callback(lua,"getRenderedNoteStrumtime", function(id:Int) {
					return PlayState.instance.notes.members[id].strumTime;
				});
	
				Lua_helper.add_callback(lua,"getRenderedNoteScaleX", function(id:Int) {
					return PlayState.instance.notes.members[id].scale.x;
				});
	
				Lua_helper.add_callback(lua,"setRenderedNotePos", function(x:Float,y:Float, id:Int) {
					if (PlayState.instance.notes.members[id] == null)
						throw('error! you cannot set a rendered notes position when it doesnt exist! ID: ' + id);
					else
					{
						PlayState.instance.notes.members[id].modifiedByLua = true;
						PlayState.instance.notes.members[id].x = x;
						PlayState.instance.notes.members[id].y = y;
					}
				});
	
				Lua_helper.add_callback(lua,"setRenderedNoteAlpha", function(alpha:Float, id:Int) {
					PlayState.instance.notes.members[id].modifiedByLua = true;
					PlayState.instance.notes.members[id].alpha = alpha;
				});
	
				Lua_helper.add_callback(lua,"setRenderedNoteScale", function(scale:Float, id:Int) {
					PlayState.instance.notes.members[id].modifiedByLua = true;
					PlayState.instance.notes.members[id].setGraphicSize(Std.int(PlayState.instance.notes.members[id].width * scale));
				});

				Lua_helper.add_callback(lua,"setRenderedNoteScale", function(scaleX:Int, scaleY:Int, id:Int) {
					PlayState.instance.notes.members[id].modifiedByLua = true;
					PlayState.instance.notes.members[id].setGraphicSize(scaleX,scaleY);
				});

				Lua_helper.add_callback(lua,"getRenderedNoteWidth", function(id:Int) {
					return PlayState.instance.notes.members[id].width;
				});


				Lua_helper.add_callback(lua,"setRenderedNoteAngle", function(angle:Float, id:Int) {
					PlayState.instance.notes.members[id].modifiedByLua = true;
					PlayState.instance.notes.members[id].angle = angle;
				});
	
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
					trace(PlayState.strumLineNotes.members[i].x + " " + PlayState.strumLineNotes.members[i].y + " " + PlayState.strumLineNotes.members[i].angle + " | strum" + i);
					//setVar("strum" + i + "X", Math.floor(member.x));
					setVar("defaultStrum" + i + "X", Math.floor(member.x));
					//setVar("strum" + i + "Y", Math.floor(member.y));
					setVar("defaultStrum" + i + "Y", Math.floor(member.y));
					//setVar("strum" + i + "Angle", Math.floor(member.angle));
					setVar("defaultStrum" + i + "Angle", Math.floor(member.angle));
					trace("Adding strum" + i);
				}
    }

	public function changeIcon(char:String, isPlayer, ?isCustom:Bool = false){
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

    public static function createModchartState(?fromStage:Bool = false):ModchartState
    {
        return new ModchartState(fromStage);
    }

	private function addToLayer(layer:Dynamic,sprite:FlxSprite):Void{
		if (layer == null) layer = false;
		trace("agregando sprite en capa " + layer);
		@:privateAccess
		{
			/*if (layer)
			{
				PlayState.instance.removeObject(gfs);
				PlayState.instance.removeObject(chars);
				PlayState.instance.removeObject(bfs);
				PlayState.instance.layerBG.add(sprite);
			}else
			PlayState.instance.addObject(sprite);
			if (layer)
			{
				PlayState.instance.addObject(gfs);
				PlayState.instance.addObject(chars);
				PlayState.instance.addObject(bfs);
			}*/
			switch(""+layer){
				case "0" | "true":
					PlayState.instance.layerBGs[0].add(sprite);
				case "1":
					PlayState.instance.layerBGs[1].add(sprite);
				case "3":
					PlayState.instance.layerBGs[3].add(sprite);
				case "4":
					PlayState.instance.layerBGs[4].add(sprite);
				default:
					if(layers.exists(""+layer)){
						layers.get(""+layer).add(sprite);
						trace("agregado en capa: "+layer);
					}else
						PlayState.instance.layerBGs[2].add(sprite);
			}
		}
	}
}
#end
