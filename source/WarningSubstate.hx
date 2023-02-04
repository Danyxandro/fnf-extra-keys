package;

/// Code created by Rozebud for FPS Plus (thanks rozebud)
// modified by KadeDev for use in Kade Engine/Tricky

import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxAxes;
import flixel.FlxSubState;
import Options.Option;
import flixel.input.FlxInput;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import lime.utils.Assets;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import haxe.Json;

using StringTools;

class WarningSubstate extends FlxSubState
{
	private var blackBox:FlxSprite;
	private var swagText:FlxText;
	private var title:FlxText;
	private var lock:Bool;
	private var markUps:Array<FlxTextFormatMarkerPair> = [
		new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED,true,false,FlxColor.BLACK),"<R>"),
		new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromRGB(3, 252, 223),true,false,FlxColor.BLACK),"<B>"),
		new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromRGB(237, 218, 45),true,false,FlxColor.BLACK),"<Y>")
	];
	override function create(){
		lock = false;
		blackBox = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
        blackBox.alpha = 0;
		blackBox.scrollFactor.set();
		add(blackBox);

		var texto:String = "This song uses a high amount of characters and \nyou may experience a bad performance\n"+
							"Do you want to play the song?\n\nENTER - Run anyways\nSPACE - Don't load chars and play\nBACK/SCAPE - Cancel";
		title = new FlxText(0,0,1280,"<Y>WARNING<Y>",24);
		title.setFormat(Paths.font("karma future.ttf"), 70, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE_FAST,FlxColor.BLACK);
		title.applyMarkup(title.text, markUps);
		title.screenCenter(X);
		add(title);
		swagText = new FlxText(0,0,1280,texto,24);
		swagText.setFormat(Paths.font("karma future.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE_FAST,FlxColor.BLACK);
		swagText.applyMarkup(swagText.text, markUps);
		swagText.screenCenter(X);
		add(swagText);

		title.y = 50;
		swagText.y = 50 + title.height + 30;

		FlxTween.tween(blackBox, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(title, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(swagText, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
		super.create();
	}

	override function update(elapsed:Float){
		if(!lock){
			if(FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE){
				lock = true;
				FlxTween.tween(swagText, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
				FlxTween.tween(title, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
				FlxTween.tween(blackBox, {alpha: 0}, 1.1, {ease: FlxEase.expoInOut, onComplete: function(flx:FlxTween){FlxG.mouse.visible = true;close();}});
			}
			if(FlxG.keys.justPressed.ENTER){
				lock = true;
				PlayStateChangeables.allowChanging = true;
				LoadingState.loadAndSwitchState(new PlayState());
			}
			if(FlxG.keys.justPressed.SPACE){
				lock = true;
				PlayStateChangeables.allowChanging = false;
				LoadingState.loadAndSwitchState(new PlayState());
			}
		}
        super.update(elapsed);
	}
}
