package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import flixel.system.FlxSound;

using StringTools;

class DialogueEnd extends FlxSpriteGroup
{
	var boxes:Map<String,Dynamic> = [];
	private var dialogueCount:Int = 1;
	private var defaultBubble:Bool = false;
	private var sound:FlxSound = new FlxSound();
	private var face = new FlxSprite();
	var portraitExtra:FlxSprite = new FlxSprite();
	var portraitGF:FlxSprite = new FlxSprite();
	private var originalColor:FlxColor;
	private var dropColor:FlxColor;
	private var colors = [FlxColor.fromRGB(0, 0, 0),FlxColor.fromRGB(96, 96, 96)];
	private var background:FlxSpriteGroup = new FlxSpriteGroup();
	private var splitBack:String = "";
	private var BGid:Int = -1;
	private var hint:FlxText;
	private var r = new EReg("[^0-9]", "i");
	private var portraits:Map<String,Dynamic> = [];
	private var curPortrait:String = '';
	private var curBox:String = '';
	private var fontFile:String = 'Pixel Arial 11 Bold';
	private var iniciar:Bool = false;
	public var black:FlxSprite;
	public var bgFlag:Bool = false;
	
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		FlxG.sound.list.add(sound);
		var hasDialog = false;

		black = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		black.alpha = 0;
		add(black);
		
		add(background);

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();

		hint = new FlxText(0, FlxG.height - 45, 0, 'PRESS "SPACE" TO SKIP', 16);
		hint.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		hint.scrollFactor.set();
		hint.borderSize = 4;
		hint.borderQuality = 2;
		hint.screenCenter(X);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
			background.alpha += (1 / 5) * 0.7; //lo agregue yo
			if (background.alpha > 1)
				background.alpha = 1;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

			default:
				if(sys.FileSystem.exists("assets/data/" + PlayState.SONG.song.toLowerCase() + "/outroDialogue.json"))
					hasDialog = true;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		if(sys.FileSystem.exists("assets/data/" + PlayState.SONG.song.toLowerCase() + "/outroDialogue.json")){
			var datos = cast Json.parse( sys.io.File.getContent( "assets/data/" + PlayState.SONG.song.toLowerCase() + "/outroDialogue.json" ).trim() );
			trace(datos);
			var bgJson:Array<Dynamic> = [];
			if(datos.bg != null)
				bgJson = datos.bg;
			for (ar in bgJson){
				var bg:FlxSprite = new FlxSprite();
				bg = new FlxSprite(ar[1], ar[2]).loadGraphic(openfl.display.BitmapData.fromFile("assets/shared/images/dialogueBG/" + ar[0] + ".png"));
				bg.scrollFactor.set();
				bg.antialiasing = true;
				bg.scale.set(ar[3], ar[3]);
				bg.visible = false;
				background.add(bg);
			}
			if(datos.firstPic != null){
				var bg:FlxSprite = new FlxSprite();
				bg = new FlxSprite(datos.firstPic[1], datos.firstPic[2]).loadGraphic(openfl.display.BitmapData.fromFile("assets/shared/images/dialogueBG/" + datos.firstPic[0] + ".png"));
				bg.scrollFactor.set();
				bg.antialiasing = true;
				bg.scale.set(datos.firstPic[3], datos.firstPic[3]);
				bg.visible = false;
				bgFade.visible = false;
				bgFlag = true;
				PlayState.instance.dialogueBG = bg;
			}
			if(datos.font != null){
				fontFile = datos.font;
			}
			if(datos.defaultTextColor != null){
				colors[0] = FlxColor.fromRGB(datos.defaultTextColor[0], datos.defaultTextColor[0], datos.defaultTextColor[0]);
			}
			if(datos.defaultDropColor != null){
				colors[1] = FlxColor.fromRGB(datos.defaultDropColor[0], datos.defaultDropColor[0], datos.defaultDropColor[0]);
			}
			var bgPortraits:Array<Dynamic> = [];
			if(datos.portraits != null)
				bgPortraits = datos.portraits;
			for (obj in bgPortraits){
				var bg:FlxSprite = new FlxSprite();
				bg = new FlxSprite(obj.x, obj.y);//.loadGraphic(openfl.display.BitmapData.fromFile("assets/shared/images/portraits/" + obj.route + ".png"));
				bg.frames = FlxAtlasFrames.fromSparrow(openfl.display.BitmapData.fromFile("assets/shared/images/portraits/" + obj.route + ".png"),sys.io.File.getContent("assets/shared/images/portraits/" + obj.route + ".xml"));
				bg.scrollFactor.set();
				bg.antialiasing = true;
				bg.scale.set(obj.scale, obj.scale);
				bg.visible = false;
				var isLeft:Bool = obj.onLeft;
				var box:String = "default";
				if(obj.box != null)
					box = obj.box;
				var boxAnim:String = "normal";
				if(obj.boxAnim != null)
					boxAnim = obj.boxAnim;
				var animName:String = obj.animName;
				if(obj.animation != null)
					bg.animation.addByPrefix(obj.animation[0], obj.animation[1], 24, obj.animation[2]);
				var color:FlxColor = FlxColor.fromRGB(0, 0, 0);
				var dropColor:FlxColor = FlxColor.fromRGB(96, 96, 96);
				if(obj.color != null && obj.dropColor != null){
					color = FlxColor.fromRGB(obj.color[0], obj.color[1], obj.color[2]);
					dropColor = FlxColor.fromRGB(obj.dropColor[0], obj.dropColor[1], obj.dropColor[2]);
				}
				portraits.set(obj.name,{image:bg,onLeft:isLeft,color:color,drop:dropColor,box:box,boxAnim:boxAnim,anim:animName});
				add(bg);
			}
			var bgBoxes:Array<Dynamic> = [];
			var firstBox = true;
			if(datos.boxes != null)
				bgBoxes = datos.boxes;
			for (obj in bgBoxes){
				var spr:FlxSprite = new FlxSprite();
				spr = new FlxSprite(0, obj.y);
				spr.frames = FlxAtlasFrames.fromSparrow(openfl.display.BitmapData.fromFile("assets/shared/images/dialogueBoxes/" + obj.route + ".png"),sys.io.File.getContent("assets/shared/images/dialogueBoxes/" + obj.route + ".xml"));
				spr.scrollFactor.set();
				spr.antialiasing = true;
				spr.scale.set(obj.scale, obj.scale);
				spr.screenCenter(X);
				spr.visible = false;
				var hasTwoSides:Bool = obj.twoSided;
				var anims:Array<Dynamic> = [];
				anims = obj.anims;
				for(anim in anims){
					if(anim[0] == "normalOpen")
						spr.animation.addByPrefix(anim[0], anim[1], 24, false);
					else
						spr.animation.addByPrefix(anim[0], anim[1], 24, anim[2]);
				}
				spr.animation.play("normal");
				boxes.set(obj.name,{image:spr,twoSided:hasTwoSides});
				add(spr);
				if(firstBox){
					box = spr;
					box.visible = true;
				}
			}
			if(boxes.get("default") != null){
				box.visible = false;
				box = boxes.get("default").image;
				box.visible = true;
				box.animation.play("normalOpen");
			}
			if(datos.music != null){
				FlxG.sound.playMusic(openfl.media.Sound.fromFile("assets/shared/music/" + datos.music + ".ogg"), 0, true);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			}
		}

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		handSelect.scale.set(6,6);
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = fontFile;
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = fontFile;
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);
		add(hint);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if(iniciar){
			if (box.animation.curAnim != null)
			{
				if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
				{
					box.animation.play('normal');
					dialogueOpened = true;
				}
			}else{
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			flixel.tweens.FlxTween.tween(hint, {alpha: 0}, 3, {ease: flixel.tweens.FlxEase.circIn});
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null || FlxG.keys.justPressed.SPACE)
			{
				if (!isEnding)
				{
					isEnding = true;

					//if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
					if (PlayState.SONG.song.toLowerCase() != 'roses')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						boxes.get(curBox).image.alpha -= 1/5;
						portraits.get(curPortrait).image.alpha -= 1/5;
						bgFade.alpha -= 1 / 5 * 0.7;
						background.alpha -= 1 / 5 * 0.7;
						swagDialogue.alpha -= 1 / 5;
						PlayState.instance.dialogueBG.visible = false;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						PlayState.instance.dialogueBG.visible = false;
						if(black.alpha != 0){
							var bg = new FlxSprite(-500, -300).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
							bg.scrollFactor.set();
							PlayState.instance.addObject(bg);
						}
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue(?flagSound:Bool = true):Void
	{
		cleanDialog();
		if(flagSound){
			swagDialogue.sounds[0].volume = 1;
		}else{
			swagDialogue.sounds[0].volume = 0;
		}

		switch (curCharacter)
		{
			case 'playSound':
				playSound(dialogueList[0]);
			case 'pauseMusic':
				FlxG.sound.music.pause();
				dialogueList.remove(dialogueList[0]);
				startDialogue(false);
			case 'resumeMusic':
				FlxG.sound.music.play();
				dialogueList.remove(dialogueList[0]);
				startDialogue(false);
			case 'music':
				playSound(dialogueList[0],true);
			case 'noSound':
				dialogueList.remove(dialogueList[0]);
				startDialogue(false);
		}
		swagDialogue.resetText(dialogueList[0]);

		switch(splitBack){
			case 'none':
			background.visible = false;
			bgFade.visible = true;
			case 'hide':
			PlayState.instance.dialogueBG.visible = false;
			black.visible = true;
			case 'noSound':
				swagDialogue.sounds[0].volume = 0;
				flagSound = false;
			case 'black':
				black.visible = true;
				black.alpha = 1;
		}
		if(!r.match(splitBack)){
			if(background.members.length > 0 && splitBack.length > 0){
				var id = Std.parseInt(splitBack) -1;
				if(BGid != -1){
					background.members[BGid].visible = false;
				}
				if(id >= 0 && id < background.members.length){
					bgFade.visible = false;
					background.members[id].visible = true;
					background.visible = true;
					BGid = id;
				}
			}
		}
		if(curCharacter == 'skip'){
			dialogueList.remove(dialogueList[0]);
			startDialogue(false);
		}
		if(!swagDialogue.visible){
			swagDialogue.visible = true;
			dropText.visible = true;
		}
		box.visible = true;
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				dialogueStuff("dad");
			case 'bf':
				dialogueStuff("bf");
			case 'skip' | 'playSound' | 'pauseMusic' | 'resumeMusic' | 'music' | 'noSound':
			{}
			case 'none':
				swagDialogue.sounds[0].volume = 0;
				swagDialogue.visible = false;
				dropText.visible = false;
				if(portraits.get(curPortrait)!=null)
					portraits.get(curPortrait).image.visible = false;
				swagDialogue.color = colors[0];
				dropText.color = colors[1];
				if(boxes.get(curBox)!=null && curBox != "default")
					boxes.get(curBox).image.visible = false;
				boxes.get("default").image.animation.play("normal");
				curBox = "default";
			default:
				dialogueStuff(curCharacter);
		}
	}

	function cleanDialog():Void
	{
		/*var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();*/
		var splitName:Array<String> = dialogueList[0].split(":");
		if(splitName[1].split("/").length > 1){
			splitBack = splitName[1].split("/")[1];
			curCharacter = splitName[1].split("/")[0];
		}
		else
			curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
		trace(curCharacter + "|" + splitBack + " legth: " + splitBack.length);
	}

	function playSound(path:String, ?asMusic:Bool = false):Void{
		if(asMusic){
			FlxG.sound.music.fadeOut(1, 0, function(flxTween:flixel.tweens.FlxTween){
				FlxG.sound.playMusic(openfl.media.Sound.fromFile("assets/shared/music/" + path + ".ogg"), 0, true);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			});
		}else{
			sound.loadEmbedded(openfl.media.Sound.fromFile("assets/shared/sounds/" + path + ".ogg"));
			sound.play(true);
		}
		dialogueList.remove(dialogueList[0]);
		startDialogue(false);
	}

	public function hideBlueBG():Void{
		bgFade.visible = false;
	}

	private function dialogueStuff(curCharacter:String){
		if(portraits.get(curCharacter)!=null){
			var obj = portraits.get(curCharacter);
			if(portraits.get(curPortrait)!=null && curPortrait != curCharacter)
				portraits.get(curPortrait).image.visible = false;
			obj.image.visible = true;
			obj.image.animation.play(obj.anim);
			//if(obj.color != null && obj.drop != null){
				swagDialogue.color =obj.color;
				dropText.color = obj.drop;
			/*}else{
				swagDialogue.color = colors[0];
				dropText.color = colors[1];
			}*/
			if(obj.box == "default"){
				if(boxes.get(curBox)!=null && curBox != obj.box)
					boxes.get(curBox).image.visible = false;
				var myBox = boxes.get(obj.box);
				myBox.image.visible = true;
				if(myBox.twoSided){
					if(!obj.onLeft)
						myBox.image.flipX = true;
					else
						myBox.image.flipX = false;
				}
				myBox.image.animation.play(obj.boxAnim);
				curBox = "" + obj.box;
			}else{
				if(boxes.get(obj.box)!=null){
					if(boxes.get(curBox)!=null && curBox != obj.box)
						boxes.get(curBox).image.visible = false;
					var myBox = boxes.get(obj.box);
					myBox.image.visible = true;
					if(myBox.twoSided){
						if(!obj.onLeft)
							myBox.image.flipX = true;
						else
							myBox.image.flipX = false;
					}
					myBox.image.animation.play(obj.boxAnim);
					curBox = "" + obj.box;
				}
			}
			curPortrait = curCharacter;
		}else{
			if(portraits.get(curPortrait)!=null)
				portraits.get(curPortrait).image.visible = false;
			swagDialogue.color = colors[0];
			dropText.color = colors[1];
			if(boxes.get(curBox)!=null && curBox != "default")
				boxes.get(curBox).image.visible = false;
			boxes.get("default").image.animation.play("normal");
			curBox = "default";
		}//fin del if portraits != null
	}

	public function initDialogue():Void{
		iniciar = true;
	}
}
