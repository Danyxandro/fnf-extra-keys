package;

import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.utils.Assets;
import haxe.Json;
import openfl.Lib;

using StringTools;

class CreditState extends MusicBeatState
{
	private var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
	private var bgs:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	private var fore:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	private var bgA:Array<FlxSprite> = [];
	private var bgF:Array<FlxSprite> = [];
	private var scrollText:FlxGroup = new FlxGroup();
	private var texto:String = "";
	private var swagText:FlxText;
	private var markUps:Array<FlxTextFormatMarkerPair> = [
		new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED,true,false,FlxColor.BLACK),"<R>"),
		new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromRGB(3, 252, 223),true,false,FlxColor.BLACK),"<B>"),
		new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromRGB(237, 218, 45),true,false,FlxColor.BLACK),"<Y>")
	];
	private var evtCounter:Int = 0;
	private var pauses:Array<Dynamic> = [];
	private var test:FlxText;
	private var songStarted:Bool = false;
	private var songLength:Float = 120.0;

	override function create(){
		var datos = cast Json.parse( Assets.getText( Paths.json('credits') ).trim() );
		trace(datos.credits);
		var images:Array<Dynamic> = datos.credits;
		pauses = datos.timeStops;
		this.songLength = (FlxG.save.data.fpsCap/110)* datos.timeSecs;
		trace(datos.timeStops);

		bgA[0] = new FlxSprite(0,0);
		bgA[0].frames = Paths.getSparrowAtlas('credits/credits1', 'shared');
		bgA[0].animation.addByPrefix('frame1', "bg1", 1, false);
		bgA[0].animation.addByPrefix('frame2', "bg2", 1, false);
		bgA[0].animation.addByPrefix('frame3', "bg3", 1, false);
		bgA[0].animation.addByPrefix('frame4', "bg4", 1, false);
		bgA[0].animation.play("frame1");
		bgA[0].antialiasing = true;
		bgs.add(bgA[0]);

		bgA[1] = new FlxSprite(0,0);
		bgA[1].frames = Paths.getSparrowAtlas('credits/credits2', 'shared');
		bgA[1].animation.addByPrefix('frame1', "bg1", 1, false);
		bgA[1].animation.addByPrefix('frame2', "bg2", 1, false);
		bgA[1].animation.addByPrefix('frame3', "bg3", 1, false);
		bgA[1].animation.play("frame1");
		bgA[1].antialiasing = true;
		bgA[1].alpha = 0;
		bgs.add(bgA[1]);

		add(bgs);

		var counter:Int = 0;
		for(ar in images){
			bgF[counter] = new FlxSprite(0,720);
			bgF[counter].loadGraphic(openfl.display.BitmapData.fromFile("assets/shared/images/credits/" + ar + ".png"));
			bgF[counter].antialiasing = true;
			fore.add(bgF[counter]);
			counter++;
		}
		bgF[0].y = 0;
		bgF[4].x = 1285;
		bgF[4].y = 0;
		add(fore);

		texto = sys.io.File.getContent("assets/data/credits.txt");
		swagText = new FlxText(0,720,1280,texto,24);
		swagText.setFormat(Paths.font("karma future.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE_FAST,FlxColor.BLACK);
		swagText.applyMarkup(swagText.text, markUps);
		swagText.screenCenter(X);
		scrollText.add(swagText);
		add(scrollText);

		changeMusic(true);

		#if debug
		test = new FlxText(0,0,"Time: 0",48);
		test.setFormat(Paths.font("karma future.ttf"), 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE_FAST,FlxColor.BLACK);
		add(test);
		#end
	}

	override function update(elapsed:Float){
		if (controls.BACK || controls.ACCEPT){
			changeMusic(false);
			FlxG.switchState(new MainMenuState());
		}

		if((floatToStringPrecision(FlxG.sound.music.time/1000,1) == pauses[evtCounter]) && evtCounter < 6 && songStarted){
			trace("Time: " + (FlxG.sound.music.time / 1000) + " JSON:" + pauses[evtCounter]);
			moveThings();
		}

		#if debug
		if (FlxG.keys.justPressed.RIGHT && songStarted){
			if(FlxG.keys.pressed.SHIFT){
				if(FlxG.sound.music.time < FlxG.sound.music.length - 10000){
					FlxG.sound.music.play(true,FlxG.sound.music.time + 10000);
				}
			}else{
				if(FlxG.sound.music.time < FlxG.sound.music.length - 1000){
					FlxG.sound.music.play(true,FlxG.sound.music.time + 1000);
				}
			}
		}

		if (FlxG.keys.justPressed.LEFT && songStarted){
			if(FlxG.keys.pressed.SHIFT){
				if(FlxG.sound.music.time > 10000){
					FlxG.sound.music.play(true,FlxG.sound.music.time - 10000);
				}
			}else{
				if(FlxG.sound.music.time > 1000){
					FlxG.sound.music.play(true,FlxG.sound.music.time - 1000);
				}
			}
		}

		test.text = "Time: " + floatToStringPrecision(FlxG.sound.music.time/1000,1);
		#end
	}

	private function changeMusic(opening:Bool){
		if(opening){
			FlxG.sound.music.fadeOut(1, 0, function(flxTween:flixel.tweens.FlxTween){
				FlxG.sound.playMusic(openfl.media.Sound.fromFile("assets/shared/music/credits.ogg"), 0, false);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
				FlxTween.tween(swagText, {y: 380 - swagText.height}, songLength, {ease: FlxEase.linear});
				FlxG.sound.music.onComplete = function(){
					new FlxTimer().start(3,function(tmr:FlxTimer){
						changeMusic(false);
						FlxG.switchState(new MainMenuState());
						songStarted = false;
					});
				};
				songStarted = true;
			});
		}else{
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}
	}

	private function moveThings(){
		switch(evtCounter){
			case 0:
				FlxTween.tween(bgF[0], {y: 720}, 1, {ease: FlxEase.linear});
				FlxTween.tween(bgF[1], {y: 0}, 1, {ease: FlxEase.linear});
				FlxTween.tween(bgA[1], {alpha: 1}, 0.5, {ease: FlxEase.circIn});
				evtCounter++;
			case 1:
				FlxTween.tween(bgF[1], {y: 720}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(bgF[2], {y: 0}, 0.5, {ease: FlxEase.linear});
				bgA[0].animation.play("frame2");
				FlxTween.tween(bgA[1], {alpha: 0}, 0.5, {ease: FlxEase.circIn});
				evtCounter++;
			case 2:
				FlxTween.tween(bgF[2], {x: 1290}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(bgF[3], {y: 0}, 0.5, {ease: FlxEase.linear});
				bgA[1].animation.play("frame2");
				FlxTween.tween(bgA[1], {alpha: 1}, 0.5, {ease: FlxEase.circIn});
				evtCounter++;
			case 3:
				FlxTween.tween(bgF[3], {x: 1285}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(bgF[4], {x: 0}, 0.5, {ease: FlxEase.linear});
				bgA[0].animation.play("frame3");
				FlxTween.tween(bgA[1], {alpha: 0}, 0.5, {ease: FlxEase.circIn});
				evtCounter++;
			case 4:
				FlxTween.tween(bgF[4], {y: 720}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(bgF[5], {y: 0}, 0.5, {ease: FlxEase.linear});
				bgA[1].animation.play("frame3");
				FlxTween.tween(bgA[1], {alpha: 1}, 0.5, {ease: FlxEase.circIn});
				evtCounter++;
			case 5:
				FlxTween.tween(bgF[5], {y: 720}, 0.5, {ease: FlxEase.linear});
				bgA[0].animation.play("frame4");
				FlxTween.tween(bgA[1], {alpha: 0}, 0.5, {ease: FlxEase.circIn});
				evtCounter++;
		}
	}

	private function floatToStringPrecision(n:Float,prec:Int) //Code from Sea Jackal
	{
		if(n==0)
			return "0." + ([for(i in 0...prec) "0"].join("")); //quick return

		var minusSign:Bool = (n<0.0);
		n = Math.abs(n);
		var intPart:Int = Math.floor(n);
		var p = Math.pow(10, prec);
		var fracPart = Math.round( p*(n - intPart) );
		var buf:StringBuf = new StringBuf();

		if(minusSign)
			buf.addChar("-".code);
		buf.add(Std.string(intPart));

		if(fracPart==0)
		{
			buf.addChar(".".code);
			for(i in 0...prec)
				buf.addChar("0".code);
		}
		else 
		{
			buf.addChar(".".code);
			p = p/10;
			var nZeros:Int = 0;
			while(fracPart<p)
			{
				p = p/10;
				buf.addChar("0".code);
			}
			buf.add(fracPart);
		}
		return buf.toString();
	}
}//Fin de la clase