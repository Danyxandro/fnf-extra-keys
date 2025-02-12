package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.utils.Assets;
import haxe.Json;

using StringTools;

typedef AnimArray = {
	var anim:String;
	var name:String;
	var fps:Int;
	var loop:Bool;
	var indices:Array<Int>;
	var offsets:Array<Int>;
	var offsetsPlayer:Array<Int>;
}


class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var isPlayingAsBF:Bool;

	private var flag:Bool = true;
	private var fase:Int = 0;
	private var sync = false;

	public var flyingOffset:Float = 0;
	public var cameraPosition:Array<Float> = [0.0, 0.0];
	public var camPlayerPosition:Array<Float>;
	public var posOffsets:Array<Float> = [0.0, 0.0];
	public var playerPos:Array<Float>;
	public var isCustom:Bool = false;
	public var hasFocus:Bool = true;
	public var colorCode:Array<Int> = [];
	public var isDancingIdle:Bool = false;
	public var singDuration:Float = 4;
	private var charFlipped:Bool = false;
	public var animationsArray:Array<AnimArray> = [];
	public var originalFlipX:Bool = false;
	private var animIndex:Map<String,Int> = [];
	private var flagAnims:Bool = true;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false, ?synch:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		isPlayingAsBF = !PlayStateChangeables.flip;

		var tex:FlxAtlasFrames;
		antialiasing = FlxG.save.data.antialiasing;
		this.sync = synch;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets',"shared");
				frames = tex;
				addAnimByPrefix('cheer', 'GF Cheer', 24, false);
				addAnimByPrefix('singLEFT', 'GF left note', 24, false);
				addAnimByPrefix('singRIGHT', 'GF Right Note', 24, false);
				addAnimByPrefix('singUP', 'GF Up Note', 24, false);
				addAnimByPrefix('singDOWN', 'GF Down Note', 24, false);
				addAnimByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				addAnimByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				addAnimByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				addAnimByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				addAnimByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				addAnimByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('characters/gfChristmas',"shared");
				frames = tex;
				addAnimByPrefix('cheer', 'GF Cheer', 24, false);
				addAnimByPrefix('singLEFT', 'GF left note', 24, false);
				addAnimByPrefix('singRIGHT', 'GF Right Note', 24, false);
				addAnimByPrefix('singUP', 'GF Up Note', 24, false);
				addAnimByPrefix('singDOWN', 'GF Down Note', 24, false);
				addAnimByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				addAnimByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				addAnimByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				addAnimByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				addAnimByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				addAnimByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-car':
				tex = Paths.getSparrowAtlas('characters/gfCar',"shared");
				frames = tex;
				addAnimByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				addAnimByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				addAnimByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/gfPixel',"shared");
				frames = tex;
				addAnimByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				addAnimByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				addAnimByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Dad idle dance', 24);
				addAnimByPrefix('singUP', 'Dad Sing Note UP', 24);
				addAnimByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				addAnimByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				addAnimByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
				singDuration = 6.1;
			case 'spooky':
				tex = Paths.getSparrowAtlas('characters/spooky_kids_assets',"shared");
				frames = tex;
				addAnimByPrefix('singUP', 'spooky UP NOTE', 24, false);
				addAnimByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				addAnimByPrefix('singLEFT', 'note sing left', 24, false);
				addAnimByPrefix('singRIGHT', 'spooky sing right', 24, false);
				addAnimByPrefix('idle', 'spooky dance idle', 24, false);
				addAnimByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				addAnimByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');
				addOffset('idle');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				if(!isPlayer)
					playAnim('danceRight');
				else{
					addOffset("singUP", -40, 26);
					addOffset("singRIGHT", 40, -13);
					addOffset("singLEFT", 40, -13);
					addOffset("singDOWN", -30, -140);
					playAnim('idle');
				}
				isDancingIdle = true;
			case 'mom':
				tex = Paths.getSparrowAtlas('characters/Mom_Assets',"shared");
				frames = tex;

				addAnimByPrefix('idle', "Mom Idle", 24, false);
				addAnimByPrefix('singUP', "Mom Up Pose", 24, false);
				addAnimByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				addAnimByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				addAnimByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				if(isPlayer){
					addOffset("singUP", -16, 71);
					addOffset("singRIGHT", 170, -60);
					addOffset("singLEFT", -20, -23);
					addOffset("singDOWN", 20, -160);
				}

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('characters/momCar',"shared");
				frames = tex;

				addAnimByPrefix('idle', "Mom Idle", 24, false);
				addAnimByPrefix('singUP', "Mom Up Pose", 24, false);
				addAnimByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				addAnimByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				addAnimByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				if(isPlayer){
					addOffset("singUP", -16, 71);
					addOffset("singRIGHT", 170, -60);
					addOffset("singLEFT", -20, -23);
					addOffset("singDOWN", 20, -160);
				}

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('characters/Monster_Assets',"shared");
				frames = tex;
				addAnimByPrefix('idle', 'monster idle', 24, false);
				addAnimByPrefix('singUP', 'monster up note', 24, false);
				addAnimByPrefix('singDOWN', 'monster down', 24, false);
				addAnimByPrefix('singLEFT', 'Monster left note', 24, false);
				addAnimByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -30, -40);
				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('characters/monsterChristmas',"shared");
				frames = tex;
				addAnimByPrefix('idle', 'monster idle', 24, false);
				addAnimByPrefix('singUP', 'monster up note', 24, false);
				addAnimByPrefix('singDOWN', 'monster down', 24, false);
				addAnimByPrefix('singLEFT', 'Monster left note', 24, false);
				addAnimByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);
				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss',"shared");
				frames = tex;
				addAnimByPrefix('idle', "Pico Idle Dance", 24);
				addAnimByPrefix('singUP', 'pico Up note0', 24, false);
				addAnimByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					curCharacter = "bf-pico";
					addAnimByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					addAnimByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					addAnimByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					addAnimByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
					addOffset("singUP", 11, 21);
					addOffset("singRIGHT", -44, -3);
					addOffset("singLEFT", 65, -12);
					addOffset("singDOWN", 80, -83);
					addOffset("singUPmiss", 11, 61);
					addOffset("singRIGHTmiss", -44, 37);
					addOffset("singLEFTmiss", 65, 28);
					addOffset("singDOWNmiss", 80, -43);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					addAnimByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					addAnimByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					addAnimByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					addAnimByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -68, -7);
					addOffset("singLEFT", 65, 9);
					addOffset("singDOWN", 200, -70);
					addOffset("singUPmiss", -19, 67);
					addOffset("singRIGHTmiss", -60, 41);
					addOffset("singLEFTmiss", 62, 64);
					addOffset("singDOWNmiss", 210, -28);
				}

				addAnimByPrefix('singUPmiss', 'pico Up note miss', 24);
				addAnimByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				addOffset('idle');

				playAnim('idle');

				flipX = true;

			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');
				frames = tex;

				trace(tex.frames.length);

				addAnimByPrefix('idle', 'BF idle dance', 24, false);
				addAnimByPrefix('singUP', 'BF NOTE UP0', 24, false);
				addAnimByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				addAnimByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				addAnimByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				addAnimByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				addAnimByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				addAnimByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				addAnimByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				addAnimByPrefix('hey', 'BF HEY', 24, false);
				addAnimByPrefix('singHey', 'BF HEY', 24, false);
				addAnimByPrefix('singHit', 'BF hit', 24, false);

				addAnimByPrefix('firstDeath', "BF dies", 24, false);
				addAnimByPrefix('deathLoop', "BF Dead Loop", 24, true);
				addAnimByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				addAnimByPrefix('scared', 'BF idle shaking', 24);

				if(isPlayer){
				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset("singHey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);
				}else{
					addAnimByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS', 24, false);
					addAnimByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
					addAnimByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					addAnimByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
					addOffset('idle', 0);
					addOffset("singUP", 0, 27);
					addOffset("singRIGHT", -40, -5);
					addOffset("singLEFT", 44, -6);
					addOffset("singDOWN", -30, -50);
					addOffset("singUPmiss", 0, 27);
					addOffset("singRIGHTmiss", -30, 18);
					addOffset("singLEFTmiss", 40, 20);
					addOffset("singDOWNmiss", -20, -19);
					addOffset("hey", 3, 4);
					addOffset('scared');

					this.y += 350;
				}

				playAnim('idle');

				flipX = true;

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('characters/bfChristmas',"shared");
				frames = tex;
				addAnimByPrefix('idle', 'BF idle dance', 24, false);
				addAnimByPrefix('singUP', 'BF NOTE UP0', 24, false);
				addAnimByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				addAnimByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				addAnimByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				addAnimByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				addAnimByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				addAnimByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				addAnimByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				addAnimByPrefix('hey', 'BF HEY', 24, false);
				addAnimByPrefix('singHey', 'BF HEY', 24, false);

				if(isPlayer){
				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset("singHey", 7, 4);
				}else{
					addAnimByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS', 24, false);
					addAnimByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
					addAnimByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					addAnimByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
					addOffset('idle', 0);
					addOffset("singUP", 0, 27);
					addOffset("singRIGHT", -40, -5);
					addOffset("singLEFT", 44, -6);
					addOffset("singDOWN", -30, -50);
					addOffset("singUPmiss", 0, 27);
					addOffset("singRIGHTmiss", -30, 18);
					addOffset("singLEFTmiss", 40, 20);
					addOffset("singDOWNmiss", -20, -19);
					addOffset("hey", 3, 4);
					addOffset('scared');

					this.y += 350;
				}

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('characters/bfCar',"shared");
				frames = tex;
				addAnimByPrefix('idle', 'BF idle dance', 24, false);
				addAnimByPrefix('singUP', 'BF NOTE UP0', 24, false);
				addAnimByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				addAnimByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				addAnimByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				addAnimByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				addAnimByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				addAnimByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				addAnimByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				if(isPlayer){
				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				playAnim('idle');
				}else{
					addAnimByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS', 24, false);
					addAnimByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
					addAnimByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					addAnimByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
					addOffset('idle', -5);
					addOffset("singUP", 0, 27);
					addOffset("singRIGHT", -30, -7);
					addOffset("singLEFT", 50, -6);
					addOffset("singDOWN", -20, -50);
					addOffset("singUPmiss", 0, 27);
					addOffset("singRIGHTmiss", -30, 21);
					addOffset("singLEFTmiss", 40, 24);
					addOffset("singDOWNmiss", -30, -19);
					this.y += 350;
				}

				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/bfPixel',"shared");
				addAnimByPrefix('idle', 'BF IDLE', 24, false);
				addAnimByPrefix('singUP', 'BF UP NOTE', 24, false);
				addAnimByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				addAnimByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				addAnimByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				addAnimByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				addAnimByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				addAnimByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				addAnimByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				if(isPlayer){
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");
				}else{
					addAnimByPrefix('singRIGHT', 'BF LEFT NOTE', 24, false);
					addAnimByPrefix('singLEFT', 'BF RIGHT NOTE', 24, false);
					addAnimByPrefix('singRIGHTmiss', 'BF LEFT MISS', 24, false);
					addAnimByPrefix('singLEFTmiss', 'BF RIGHT MISS', 24, false);
					addOffset('idle');
					addOffset("singUP",6,0);
					addOffset("singRIGHT",10,0);
					addOffset("singLEFT");
					addOffset("singDOWN");
					addOffset("singUPmiss");
					addOffset("singRIGHTmiss");
					addOffset("singLEFTmiss");
					addOffset("singDOWNmiss");
					this.x += 220;
					this.y += 500;
				}

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD',"shared");
				//addAnimByPrefix('singUP', "BF Dies pixel", 24, false);
				addAnimByPrefix('firstDeath', "BF Dies pixel", 24, false);
				addAnimByPrefix('deathLoop', "Retry Loop", 24, true);
				addAnimByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'senpai':
				frames = Paths.getSparrowAtlas('characters/senpai',"shared");
				addAnimByPrefix('idle', 'Senpai Idle', 24, false);
				addAnimByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				addAnimByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				addAnimByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				addAnimByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/senpai',"shared");
				addAnimByPrefix('idle', 'Angry Senpai Idle', 24, false);
				addAnimByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				addAnimByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				addAnimByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				addAnimByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = Paths.getPackerAtlas('characters/spirit',"shared");
				addAnimByPrefix('idle', "idle spirit_", 24, false);
				addAnimByPrefix('singUP', "up_", 24, false);
				addAnimByPrefix('singRIGHT', "right_", 24, false);
				addAnimByPrefix('singLEFT', "left_", 24, false);
				addAnimByPrefix('singDOWN', "spirit down_", 24, false);

				addOffset('idle', -220, -280);
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets',"shared");
				addAnimByPrefix('idle', 'Parent Christmas Idle', 24, false);
				addAnimByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				addAnimByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				addAnimByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				addAnimByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				addAnimByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				addAnimByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				addAnimByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				addAnimByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				addOffset('idle');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);

				playAnim('idle');
			case 'tankman':
			{
				var tex = tex = Paths.getSparrowAtlas('characters/tankmanCaptain',"shared");
				frames = tex;
				addAnimByPrefix('idle', 'Tankman Idle Dance', 24, true);
				addAnimByPrefix('singUP', 'Tankman UP note', 24, false);
				addAnimByPrefix('singRIGHT','Tankman Note Left', 24, false);
				addAnimByPrefix('singLEFT', 'Tankman Right Note', 24, false);
				if (isPlayer) {
					/*addAnimByPrefix('singLEFT','Tankman Note Left', 24, false);
					addAnimByPrefix('singRIGHT', 'Tankman Right Note', 24, false);*/
					addOffset('singLEFT',-12, -227);
					addOffset('singRIGHT', 90, -214);
				} else {
					addOffset('singRIGHT',-12, -227);
					addOffset('singLEFT', 90, -214);
				}
    
				addAnimByPrefix('singDOWN', 'Tankman DOWN note', 24, false);
				addAnimByPrefix('singUP-alt', 'TANKMAN UGH', 24, false);
				addAnimByPrefix('singDOWN-alt', 'PRETTY GOOD', 24, true);
				addAnimByPrefix('prettygood', 'PRETTY GOOD', 24, false);

				addOffset('idle',0,-200);
				addOffset('singUP', 50, -144);
				addOffset('singDOWN', 80, -300);
				addOffset('singUP-alt', -15, -207);
				addOffset('singDOWN-alt', 0, -185);
				addOffset('prettygood', 0, -185);
				playAnim('idle');

				flipX = true;
			}
			case 'keen':
				var tex = Paths.getSparrowAtlas('characters/Keen',"shared");
				frames = tex;
				addAnimByPrefix('idle', 'Keen instancia 1', 24, true);
				addAnimByPrefix('singUP', 'Keen Up instancia 1', 24, false);
				addAnimByPrefix('singDOWN', 'Keen down instancia 1', 24, false);
				addAnimByPrefix('singLEFT', 'Keen left instancia 1', 24, false);
				addAnimByPrefix('singRIGHT', 'Keen right instancia 1', 24, false);
				addAnimByPrefix('hey', 'Keen Hey instancia 1', 24, false);
				addOffset('idle', -5,-230);
				addOffset("singUP", -19, -243);
				addOffset("singRIGHT", -28, -243);
				addOffset("singLEFT", 12, -206);
				addOffset("singDOWN", 10, -280);
				addOffset("hey",-15,-240);
				playAnim('idle');
				flipX=true;
			case 'bf-keen':
				var tex = Paths.getSparrowAtlas('characters/Keen_Assets','shared');
				frames = tex;
				addAnimByPrefix('idle', 'BF idle dance', 24, false);
				addAnimByPrefix('singUP', 'BF NOTE UP0', 24, false);
				addAnimByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				addAnimByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				addAnimByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				addAnimByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				addAnimByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				addAnimByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				addAnimByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				addAnimByPrefix('hey', 'BF HEY', 24, false);

				addAnimByPrefix('firstDeath', "BF dies", 24, false);
				addAnimByPrefix('deathLoop', "BF Dead Loop", 24, true);
				addAnimByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				addAnimByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;
			case 'keen-flying':
				flyingOffset = 75;
				var tex = Paths.getSparrowAtlas('characters/KeenFlying',"shared");
				frames = tex;
				addAnimByPrefix('idle', "Keen instancia", 24, true);
				addAnimByPrefix('singUP', "Keen Up instancia", 24, false);
				addAnimByPrefix('singDOWN', "Keen down instancia", 24, false);
				addAnimByPrefix('singLEFT', 'Keen left instancia', 24, false);
				addAnimByPrefix('singRIGHT', 'Keen right instancia', 24, false);
				antialiasing = true;

				if(isPlayer){
					addOffset("idle", 0, 0);
					addOffset("singUP", 33, 43);
					addOffset("singRIGHT", 24, 35);
					addOffset("singLEFT", 42, 47);
					addOffset("singDOWN", 45, 27);
					this.y -= 350;
				}else{
					addOffset("idle", 0, 0);
					addOffset("singUP", 40, 44);
					addOffset("singRIGHT", 46, 36);
					addOffset("singLEFT", 50, 40);
					addOffset("singDOWN", 52, 30);
					this.x -= 180;
				}

				flipX=true;
				playAnim('idle');
			case 'beat':
				var tex = Paths.getSparrowAtlas('characters/Beat_Assets','shared');
				frames = tex;
				addAnimByPrefix('idle', "Beat instancia", 24, true);
				addAnimByPrefix('singUP', "BeatUp", 24, false);
				addAnimByPrefix('singDOWN', "BeatDown", 24, false);
				addAnimByPrefix('singLEFT', 'BeatLeft', 24, false);
				addAnimByPrefix('singRIGHT', 'BeatRight', 24, false);
				antialiasing = true;

				if(isPlayer){
					addOffset("idle", 0, 0);
					addOffset("singUP", -35, 37);
					addOffset("singLEFT", -30, 26);
					addOffset("singRIGHT", 55, -4);
					addOffset("singDOWN", 56, 30);
					this.y -= 480;
				}else{
					addOffset("idle", 0, 0);
					addOffset("singUP", -150, 40);
					addOffset("singRIGHT", -220, -7);
					addOffset("singLEFT", -100, 30);
					addOffset("singDOWN", -180, 40);
					this.x -= 200;
					this.y -= 130;
				}

				playAnim('idle');
			case 'beat-neon':
				var tex = Paths.getSparrowAtlas('characters/Beat_Neon',"shared");
				frames = tex;
				addAnimByPrefix('idle', "Beat instancia", 24, true);
				addAnimByPrefix('singUP', "BeatUp", 24, false);
				addAnimByPrefix('singDOWN', "BeatDown", 24, false);
				addAnimByPrefix('singLEFT', 'BeatLeft', 24, false);
				addAnimByPrefix('singRIGHT', 'BeatRight', 24, false);
				antialiasing = true;

				if(isPlayer){
					addOffset("idle", 0, 0);
					addOffset("singUP", -35, 37);
					addOffset("singLEFT", -30, 26);
					addOffset("singRIGHT", 55, -4);
					addOffset("singDOWN", 56, 30);
					this.y -= 480;
				}else{
					addOffset("idle", 0, 0);
					addOffset("singUP", -150, 40);
					addOffset("singRIGHT", -220, -7);
					addOffset("singLEFT", -100, 30);
					addOffset("singDOWN", -180, 40);
					this.x -= 200;
					this.y -= 130;
				}

				playAnim('idle');
			case 'bf-neon':
				var tex = Paths.getSparrowAtlas('characters/bf-neon',"shared");
				frames = tex;

				addAnimByPrefix('idle', 'BF idle dance', 24, false);
				addAnimByPrefix('singUP', 'BF NOTE UP0', 24, false);
				addAnimByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				addAnimByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				addAnimByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				addAnimByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				addAnimByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				addAnimByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				addAnimByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				addAnimByPrefix('hey', 'BF HEY', 24, false);

				addAnimByPrefix('firstDeath', "BF dies", 24, false);
				addAnimByPrefix('deathLoop', "BF Dead Loop", 24, true);
				addAnimByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				addAnimByPrefix('scared', 'BF idle shaking', 24);

				if(isPlayer){
				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);
				}else{
					addAnimByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS', 24, false);
					addAnimByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
					addAnimByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					addAnimByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
					addOffset("idle", 0, 0);
					addOffset("singUP", 1, 28);
					addOffset("singRIGHT", -30, -8);
					addOffset("singLEFT", 34, -9);
					addOffset("singDOWN", -27, -55);
					addOffset("singUPmiss", -23, 6);
					addOffset("singRIGHTmiss", -58, -4);
					addOffset("singLEFTmiss", 17, -2);
					addOffset("singDOWNmiss", -50, -43);
					addOffset("hey", -17,-14);
					addOffset("scared", -20,-17);

					this.y += 350;
				}

				playAnim('idle');

				flipX = true;
			case 'gf-neon':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_neon',"shared");
				frames = tex;
				addAnimByPrefix('cheer', 'GF Cheer', 24, false);
				addAnimByPrefix('singLEFT', 'GF left note', 24, false);
				addAnimByPrefix('singRIGHT', 'GF Right Note', 24, false);
				addAnimByPrefix('singUP', 'GF Up Note', 24, false);
				addAnimByPrefix('singDOWN', 'GF Down Note', 24, false);
				addAnimByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				addAnimByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				addAnimByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				addAnimByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				addAnimByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				addAnimByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

				isDancingIdle = true;
			case 'gf-alt':
				tex = Paths.getSparrowAtlas('characters/gf_whitty',"shared");
				frames = tex;
				addAnimByPrefix('cheer', 'GF FEAR', 24, false);
				addAnimByPrefix('singLEFT', 'GF FEAR', 24, false);
				addAnimByPrefix('singRIGHT', 'GF FEAR', 24, false);
				addAnimByPrefix('singUP', 'GF FEAR', 24, false);
				addAnimByPrefix('singDOWN', 'GF FEAR', 24, false);
				//addAnimByPrefix('sad','gf sad',24,false);
				addAnimByIndices('sad', 'gf sad', CoolUtil.numberArray(79, 74), "", 24, false);
				addAnimByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				addAnimByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 27, 29], "", 24, false);
				addAnimByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				addAnimByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				addAnimByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -62, -202);
				addOffset('danceLeft', -60, -209);
				addOffset('danceRight', -60, -209);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
				isDancingIdle = true;
			case 'bf-cat':
				var tex = Paths.getSparrowAtlas('characters/bfCat',"shared");
				frames = tex;
				addAnimByPrefix('idle', 'BF idle dance', 24, false);
				addAnimByPrefix('singUP', 'BF NOTE UP0', 24, false);
				addAnimByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				addAnimByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				addAnimByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				addAnimByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				addAnimByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				addAnimByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				addAnimByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				addAnimByPrefix('hey', 'BF HEY', 24, false);

				addAnimByPrefix('firstDeath', "BF dies", 24, false);
				addAnimByPrefix('deathLoop', "BF Dead Loop", 24, true);
				addAnimByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				addAnimByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5, 0);
                addOffset("singUP", -49, 27);
                addOffset("singRIGHT", -4, -4);
                addOffset("singLEFT", 52, -11);
                addOffset("singDOWN", -20, -35);
                addOffset("singUPmiss", -59, 67);
                addOffset("singRIGHTmiss", -40, 35);
                addOffset("singLEFTmiss", 13, 27);
                addOffset("singDOWNmiss", -9, -3);
                addOffset("hey", -15, 5);
                addOffset('firstDeath', 27, 1);
                addOffset('deathLoop', 27, -6);
                addOffset('deathConfirm', 28, 59);
                addOffset('scared', -30, 12);

				playAnim('idle');

				flipX = true;
			case 'gf-guns':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/tankmanChars/gfTankman','shared');
				frames = tex;
				addAnimByPrefix('cheer', 'GF Cheer', 24, false);
				addAnimByPrefix('singLEFT', 'GF left note', 24, false);
				addAnimByPrefix('singRIGHT', 'GF Right Note', 24, false);
				addAnimByPrefix('singUP', 'GF Up Note', 24, false);
				addAnimByPrefix('singDOWN', 'GF Down Note', 24, false);
				addAnimByPrefix('sad', 'GF Crying at Gunpoint', 24, false);
				addAnimByIndices('danceLeft', 'GF Dancing at Gunpoint', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				addAnimByIndices('danceRight', 'GF Dancing at Gunpoint', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				addAnimByPrefix('idle', 'GF Dancing at Gunpoint', 24, false);
				addAnimByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				addAnimByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				addAnimByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -32);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
				isDancingIdle = true;
			case 'pico-speaker':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/tankmanChars/picoSpeaker','shared');
				frames = tex;
				//addAnimByIndices('idle', 'Pico shoot 2', CoolUtil.numberArray(59,41),"",24, false);
				addAnimByIndices('idle', 'Pico shoot 2', CoolUtil.numberArray(58,4),"",24, false);
				//addAnimByIndices('danceLeft', 'Pico shoot 3', CoolUtil.numberArray(62,45),"",24, false);
				addAnimByIndices('danceLeft', 'Pico shoot 2', CoolUtil.numberArray(58,22),"",24, false);
				addAnimByIndices('danceRight', 'Pico shoot 2', CoolUtil.numberArray(58,4),"",24, false);
				addAnimByPrefix('shoot1', 'Pico shoot 1',  24, false);
				addAnimByPrefix('shoot2', 'Pico shoot 2',  24, false);
				addAnimByPrefix('shoot3', 'Pico shoot 3', 24, false);
				addAnimByPrefix('shoot4', 'Pico shoot 4', 24, false);
				/*addAnimByIndices('shoot1', 'Pico shoot 1', CoolUtil.numberArray(4),"", 24, false);
				addAnimByIndices('shoot2', 'Pico shoot 2', CoolUtil.numberArray(4),"", 24, false);
				addAnimByIndices('shoot3', 'Pico shoot 3', CoolUtil.numberArray(4),"", 24, false);
				addAnimByIndices('shoot4', 'Pico shoot 4', CoolUtil.numberArray(4),"", 24, false);*/

				addOffset('shoot1', 0);
				addOffset('shoot2', -1, -128);
				addOffset('shoot3', 412, -64);
				addOffset('shoot4', 439, -19);

				//addOffset('danceLeft', 412, -64);
				addOffset('danceLeft', -1, -128);
				addOffset('danceRight', -1, -128);
				addOffset('idle', -1, -128);

				playAnim('idle');

				this.y -= 200;
				isDancingIdle = true;
			case 'bf-holding-gf':
				var tex = Paths.getSparrowAtlas('characters/tankmanChars/bfAndGF','shared');
				frames = tex;				
				
				addAnimByPrefix('idle', 'BF idle dance w gf', 24, false);
				addAnimByPrefix('singUP', 'BF NOTE UP0', 24, false);
				addAnimByPrefix('singLEFT','BF NOTE LEFT0', 24, false);
				addAnimByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				addAnimByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				addAnimByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				addAnimByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS',24, false);
				addAnimByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS',24,false);
				addAnimByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				
				if (isPlayer)
				{
				addOffset('idle', 0, 0);
				addOffset('singUP', -29,10);
				addOffset('singRIGHT', -41, 23);
				addOffset('singLEFT', 12, 7);
				addOffset('singDOWN', -10, -10);
				addOffset('singUPmiss', -29, 10);
				addOffset('singRIGHTmiss', -41, 23);
				addOffset('singLEFTmiss', 12, 7);
				addOffset('singDOWNmiss', -10, -10);
				}else{
					addAnimByPrefix('singRIGHT','BF NOTE LEFT0', 24, false);
					addAnimByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					addAnimByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS',24, false);
					addAnimByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS',24,false);
					addOffset('idle', 0, 0);
					addOffset('singUP', 13,10);
					addOffset('singRIGHT', -40, 0);
					addOffset('singLEFT', -2, 19);
					addOffset('singDOWN', -33, -16);
					addOffset('singUPmiss', 29, 0);
					addOffset('singRIGHTmiss', -30, 0);
					addOffset('singLEFTmiss', 0, 30);
					addOffset('singDOWNmiss', -39, -16);
					this.y += 350;
				}
				flipX = true;
			case 'OJ':
				var tex = Paths.getSparrowAtlas('characters/OJ_Assets','shared');
				frames = tex;
				antialiasing = true;
				addAnimByPrefix('idle', 'OJ Idle', 24, true);
				addAnimByPrefix('singUP', 'OJ Up', 24, false);
				addAnimByPrefix('singDOWN', 'OJ Down', 24, false);
				addAnimByPrefix('singUPmiss', 'up fail', 24, false);
				addAnimByPrefix('singDOWNmiss', 'down fail', 24, false);

				if(isPlayer){
					curCharacter = 'bf-OJ';
					addAnimByPrefix('singLEFT', 'OJ right', 24, false);
					addAnimByPrefix('singRIGHT', 'OJ left', 24, false);
					addAnimByPrefix('singLEFTmiss', 'Right fail', 24, false);
					addAnimByPrefix('singRIGHTmiss', 'left fail', 24, false);
					addAnimByPrefix('scared', 'down fail', 24, false);
					addOffset("idle", 0, 0);
					addOffset("singUP", 96, 220);
					addOffset("singRIGHT", -30, 108);
					addOffset("singLEFT", 0, 123);
					addOffset("singDOWN", -70, 65);
					addOffset("singUPmiss", 76, 215);
					addOffset("singRIGHTmiss", -45, 100);
					addOffset("singLEFTmiss", 0, 123);
					addOffset("singDOWNmiss", -64, 65);
					addOffset("scared", -64, 65);
					this.x -= 200;
					this.y -= 420;
				}else{
					addAnimByPrefix('singLEFT', 'OJ left', 24, false);
					addAnimByPrefix('singRIGHT', 'OJ right', 24, false);
					addAnimByPrefix('singLEFTmiss', 'left fail', 24, false);
					addAnimByPrefix('singRIGHTmiss', 'Right fail', 24, false);
					addOffset("idle", 0, 0);
					addOffset("singUP", 150, 218);
					addOffset("singRIGHT", -30, 120);
					addOffset("singLEFT", 20, 110);
					addOffset("singDOWN", 40, 66);
					addOffset("singUPmiss", 140, 218);
					addOffset("singRIGHTmiss", -30, 120);
					addOffset("singLEFTmiss", 30, 100);
					addOffset("singDOWNmiss", 37, 65);
					this.x -= 150;
					this.y -= 70;
				}
				playAnim('idle');
			case "OJ-menu":
				tex = Paths.getSparrowAtlas('characters/OJ_Assets','shared');
				frames = tex;
				addAnimByPrefix('idle', 'OJ Idle', 24, true);
				addAnimByPrefix('singUP', 'OJ Up', 24, false);
				addAnimByPrefix('singLEFT', 'OJ left', 24, false);
				addAnimByPrefix('singRIGHT', 'OJ right', 24, false);
				antialiasing = true;

				addOffset("idle", -48, 0);
				addOffset("singUP", 31, 180);
				addOffset("singLEFT", -90, 62);
				addOffset("singRIGHT", -115, 72);
				this.y -= 450;

				playAnim('idle');
			case 'whitty':
				/*var offsetsJson:Array<Dynamic> = cast Json.parse( Assets.getText( Paths.json('offsets') ).trim() ).offsets;
				trace(offsetsJson);*/
				tex = Paths.getSparrowAtlas('characters/Whitty', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Whitty Idle', 24, true);
				addAnimByPrefix('singUP', 'Credit Goes to0', 24, false);
				addAnimByPrefix('singDOWN', 'SockClip for Arts and Song0', 24, false);
				addAnimByPrefix('singLEFT', 'KadeDev for Coding0', 24, false);
				addAnimByPrefix('singRIGHT', 'Nate Anim8 for Arts and Chart0', 24, false);
				addOffset('idle',0,-12);
				addOffset("singUP", 19, 39);
				addOffset("singLEFT", -2, -28);
				addOffset("singRIGHT", 11, 26);
				addOffset("singDOWN", -70, -55);

				if(isPlayer){
					/*addAnimByPrefix('singRIGHT', 'KadeDev for Coding0', 24, false);
					addAnimByPrefix('singLEFT', 'Nate Anim8 for Arts and Chart0', 24, false);*/
					addAnimByPrefix('singUPmiss', 'Whitty Sing Up MISS', 24, false);
					addAnimByPrefix('singRIGHTmiss', 'Whitty Sing Left MISS', 24, false);
					addAnimByPrefix('singDOWNmiss', 'Whitty Sing Down MISS', 24, false);
					addAnimByPrefix('singLEFTmiss', 'Whitty Sing Right MISS', 24, false);

					addOffset('idle',0,-12);
					addOffset("singUP", 19, 39);
					/*addOffset("singRIGHT", -2, -28);
					addOffset("singLEFT", 11, 26);*/
					addOffset("singDOWN", 110, -55);
					addOffset("singUPmiss", 19, 39);
					addOffset("singRIGHTmiss", -2, -28);
					addOffset("singLEFTmiss", 11, 26);
					addOffset("singDOWNmiss", 110, -55);
				}

				/*for (ar in offsetsJson){
					addOffset(ar[0],ar[1],ar[2]);
				}*/

				playAnim('idle');
			case 'hex':
				tex = Paths.getSparrowAtlas('characters/Hex', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Dad idle dance', 24, true);
				addAnimByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				addAnimByPrefix('hey', 'Dad Sing Note UP', 24, false);
				addAnimByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				addAnimByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				addAnimByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("hey", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
			case 'ruv':
				tex = Paths.getSparrowAtlas('characters/Ruv', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'BF idle dance', 24, true);
				addAnimByPrefix('singUP', 'BF NOTE UP0', 24, false);
				addAnimByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
				addAnimByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
				addAnimByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				addAnimByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				addAnimByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
				addAnimByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS', 24, false);
				addAnimByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				addAnimByPrefix('hey', 'BF HEY!!', 24, false);

				if(isPlayer){
					addOffset('idle', 0, -5);
					addOffset("singUP", 1, 87);
					addOffset("singLEFT", -38, -7);
					addOffset("singRIGHT", 12, 40);
					addOffset("singDOWN", -10, -50);
					addOffset("singUPmiss", 1, 87);
					addOffset("singLEFTmiss", -38, -7);
					addOffset("singRIGHTmiss", 12, 40);
					addOffset("singDOWNmiss", -10, -50);
					addOffset("hey", -5, 5);
					this.x += 70;
				}else{
					addOffset('idle', 0, -5);
					addOffset("singUP", -29, 27);
					addOffset("singLEFT", -23, -27);
					addOffset("singRIGHT", 1, -6);
					addOffset("singDOWN", -10, -80);
					addOffset("hey", -29, 5);
					this.y += 350;
				}

				playAnim('idle');

				flipX = true;

				playAnim('idle');

			case 'sarv':
				tex = Paths.getSparrowAtlas('characters/Sarvente', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'BF idle dance', 24, true);
				addAnimByPrefix('singUP', 'BF NOTE UP0', 24, false);
				addAnimByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
				addAnimByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
				addAnimByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				addAnimByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				addAnimByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
				addAnimByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS', 24, false);
				addAnimByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				addAnimByPrefix('hey', 'BF HEY!!', 24, false);

				if(isPlayer){
					addOffset('idle', 0, -5);
					addOffset("singUP", 1, 57);
					addOffset("singLEFT", -38, -27);
					addOffset("singRIGHT", 12, 0);
					addOffset("singDOWN", -10, -80);
					addOffset("singUPmiss", 1, 57);
					addOffset("singLEFTmiss", -38, -27);
					addOffset("singRIGHTmiss", 12, 0);
					addOffset("singDOWNmiss", -10, -80);
					addOffset("hey", 5, -5);
					this.x += 70;
				}else{
					addOffset('idle', 0, -5);
					addOffset("singUP", -29, 27);
					addOffset("singLEFT", -23, -27);
					addOffset("singRIGHT", 1, -6);
					addOffset("singDOWN", -10, -80);
					addOffset("hey", -35, -5);
					this.y += 350;
				}

				playAnim('idle');

				flipX = true;

				//this.y -= 40;

				playAnim('idle');
			case 'bf-tankman-pixel':
				frames = Paths.getSparrowAtlas('characters/tankPixel','shared');
				addAnimByPrefix('idle', 'BF IDLE', 24, true);
				addAnimByPrefix('singUP', 'BF UP NOTE', 24, false);
				addAnimByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				addAnimByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				addAnimByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				addAnimByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				addAnimByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				addAnimByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				addAnimByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				if(isPlayer){
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");
				}else{
					addAnimByPrefix('singRIGHT', 'BF LEFT NOTE', 24, false);
					addAnimByPrefix('singLEFT', 'BF RIGHT NOTE', 24, false);
					addAnimByPrefix('singRIGHTmiss', 'BF LEFT MISS', 24, false);
					addAnimByPrefix('singLEFTmiss', 'BF RIGHT MISS', 24, false);
					addOffset('idle');
					addOffset("singUP",6,0);
					addOffset("singRIGHT",10,0);
					addOffset("singLEFT");
					addOffset("singDOWN");
					addOffset("singUPmiss");
					addOffset("singRIGHTmiss");
					addOffset("singLEFTmiss");
					addOffset("singDOWNmiss");
					this.x += 220;
					this.y += 500;
				}

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-tankman-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/tankPixelsDEAD','shared');
				//addAnimByPrefix('singUP', "BF Dies pixel", 24, false);
				addAnimByPrefix('firstDeath', "BF Dies pixel", 24, false);
				addAnimByPrefix('deathLoop', "Retry Loop", 24, true);
				addAnimByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;
			case 'impostor':
				tex = Paths.getSparrowAtlas('characters/impostor', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'impostor idle0', 18, true);
				addAnimByPrefix('singUP', 'impostor up0', 24, false);
				//addAnimByPrefix('hey', 'impostor up0', 24, false);
				addAnimByPrefix('singRIGHT', 'impostor right0', 24, false);
				addAnimByPrefix('singDOWN', 'impostor down0', 24, false);
				addAnimByPrefix('singLEFT', 'impostor left0', 24, false);
				addAnimByPrefix('shoot', 'impostor shoot 1', 24,false);

				if(isPlayer){
					addOffset('idle');
					addOffset("singUP", -136, -5);
					addOffset("singRIGHT", -70,-23);
					addOffset("singLEFT", -146, -12);
					addOffset("singDOWN", -160, -74);
					addOffset("shoot", -160, 67);
				}else{
					addOffset('idle');
					addOffset("singUP", -86, -5);
					//addOffset("hey", -86, -5);
					addOffset("singRIGHT", -100,-23);
					addOffset("singLEFT", 44, -12);
					//addOffset("singDOWN", -50, -77);
					addOffset("singDOWN", -50, -68);
					addOffset("shoot", -50, 67);
				}
				this.y += 400;
				playAnim('idle');
			case 'agoti':
				tex = Paths.getSparrowAtlas('characters/AGOTI', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Agoti_Idle', 24, true);
				addAnimByPrefix('singUP', 'Agoti_Up', 24, false);
				addAnimByPrefix('hey', 'Agoti_Up', 24, false);
				addAnimByPrefix('singRIGHT', 'Agoti_Right', 24, false);
				addAnimByPrefix('singDOWN', 'Agoti_Down', 24, false);
				addAnimByPrefix('singLEFT', 'Agoti_Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 50,77);
				addOffset("hey", 50,77);
				addOffset("singRIGHT", 60, -46);
				addOffset("singLEFT", 174, 8);
				addOffset("singDOWN",1, -196);

				this.y -= 100;
				playAnim('idle');
			case 'kapi':
				tex = Paths.getSparrowAtlas('characters/Kapi', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Dad idle dance', 24,true);
				addAnimByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				addAnimByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				addAnimByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				addAnimByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);
				addAnimByPrefix('hey', 'Dad meow', 24, false);
				addAnimByPrefix('stare', 'Dad stare', 24, false);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);
				addOffset('hey');
				addOffset('stare');

				playAnim('idle');
			case 'monika':
				frames = Paths.getSparrowAtlas('characters/monika','shared');
				addAnimByPrefix('idle', 'Monika Idle', 24, true);
				addAnimByPrefix('singUP', 'Monika UP NOTE', 24, false);
				addAnimByPrefix('singLEFT', 'Monika LEFT NOTE', 24, false);
				addAnimByPrefix('singRIGHT', 'Monika RIGHT NOTE', 24, false);
				addAnimByPrefix('singDOWN', 'Monika DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				this.y += 280;

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'bob':
				tex = Paths.getSparrowAtlas('characters/bob_asset', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'bob_idle', 24, true);
				addAnimByPrefix('singUP', 'bob_UP', 24, false);
				addAnimByPrefix('singRIGHT', 'bob_RIGHT', 24, false);
				addAnimByPrefix('singDOWN', 'bob_DOWN', 24, false);
				addAnimByPrefix('singLEFT', 'bob_LEFT', 24, false);

				addOffset('idle');
				addOffset("singUP", -6, -2);
				addOffset("singRIGHT", 0, -1);
				addOffset("singLEFT", -10, -1);
				addOffset("singDOWN", 0, -2);

				playAnim('idle');

				this.y += 270;

				flipX = true;

			case 'sky':
				tex = Paths.getSparrowAtlas('characters/sky_assets', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'sky idle', 24, true);
				addAnimByPrefix('singUP', 'sky up', 24, false);
				addAnimByPrefix('singRIGHT', 'sky right', 24, false);
				addAnimByPrefix('singDOWN', 'sky down', 24, false);
				addAnimByPrefix('singLEFT', 'sky left', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				this.y += 100;

				playAnim('idle');
			case 'sky-annoyed':
				tex = Paths.getSparrowAtlas('characters/sky_annoyed_assets', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'sky annoyed idle0', 24, true);
				addAnimByPrefix('singUP', 'sky annoyed up0', 24, true);
				addAnimByPrefix('singRIGHT', 'sky annoyed right0', 24, false);
				addAnimByPrefix('singDOWN', 'sky annoyed down0', 24, false);
				addAnimByPrefix('singLEFT', 'sky annoyed left0', 24, false);
				addAnimByPrefix('idle2', 'sky annoyed alt idle0', 24, true);
				addAnimByPrefix('singUP-alt', 'sky annoyed alt up0', 24, false);
				addAnimByPrefix('singCenter', 'sky annoyed alt up0', 24, false);
				addAnimByPrefix('singRIGHT-alt', 'sky annoyed alt right0', 24, false);
				addAnimByPrefix('singDOWN-alt', 'sky annoyed alt down0', 24, false);
				addAnimByPrefix('singLEFT-alt', 'sky annoyed alt left0', 24, false);
				addAnimByPrefix('sing-ugh', 'sky annoyed ugh0', 24, false);
				addAnimByPrefix('sing-oh', 'sky annoyed oh0', 24, false);
				addAnimByPrefix('sing-grr', 'sky annoyed grr0', 24, false);
				addAnimByPrefix('sing-huh', 'sky annoyed huh0', 24, false);

				if(isPlayer){
					addAnimByPrefix('singLEFT-alt', 'sky annoyed alt right0', 24, false);
					addAnimByPrefix('singRIGHT-alt', 'sky annoyed alt left0', 24, false);
					addAnimByPrefix('singUPmiss', 'sky annoyed alt up0', 24, false);
					addAnimByPrefix('singRIGHTmiss', 'sky annoyed alt right0', 24, false);
					addAnimByPrefix('singDOWNmiss', 'sky annoyed alt down0', 24, false);
					addAnimByPrefix('singLEFTmiss', 'sky annoyed alt left0', 24, false);
					addOffset('idle',-100,100);
					addOffset('idle2',-100,100);
					addOffset("singUP",-100,100);
					addOffset("singRIGHT",-50,100);
					addOffset("singLEFT",-150,100);
					addOffset("singDOWN",-100,100);
					addOffset("singUP-alt",-100,100);
					addOffset("singCenter",-100,100);
					addOffset("singRIGHT-alt",-150,100);
					addOffset("singLEFT-alt",-60,100);
					addOffset("singDOWN-alt",-100,100);
					addOffset("singUPmiss",-100,100);
					addOffset("singRIGHTmiss",-60,100);
					addOffset("singLEFTmiss",-150,100);
					addOffset("singDOWNmiss",-100,100);
					addOffset("sing-ugh",-100,100);
					addOffset("sing-oh",-100,100);
					addOffset("sing-grr",-100,100);
					addOffset("sing-huh",-130,100);
				}else{
					addOffset('idle',100,100);
					addOffset('idle2',100,100);
					addOffset("singUP",100,100);
					addOffset("singRIGHT",100,100);
					addOffset("singLEFT",100,100);
					addOffset("singDOWN",100,100);
					addOffset("singUP-alt",100,100);
					addOffset("singCenter",100,100);
					addOffset("singRIGHT-alt",100,100);
					addOffset("singLEFT-alt",100,100);
					addOffset("singDOWN-alt",100,100);
					addOffset("sing-ugh",100,100);
					addOffset("sing-oh",100,100);
					addOffset("sing-grr",100,100);
					addOffset("sing-huh",100,100);
				}
				this.y += 200;

				playAnim("idle");
			case 'sky-mad':
				tex = Paths.getSparrowAtlas('characters/sky_mad_assets', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'sky mad idle0', 24, true);
				addAnimByPrefix('singUP', 'sky mad up0', 24, false);
				addAnimByPrefix('singRIGHT', 'sky mad right0', 24, false);
				addAnimByPrefix('singDOWN', 'sky mad down0', 24, false);
				addAnimByPrefix('singLEFT', 'sky mad left0', 24, false);
				antialiasing = true;

				if(isPlayer){
					addOffset("idle", 0, 100);
					addOffset("singUP", -20, 100);
					addOffset("singRIGHT", -10, 100);
					addOffset("singLEFT", 0, 100);
					addOffset("singDOWN", 0, 100);
				}else{
					addOffset("idle", 0, 100);
					addOffset("singUP", 0, 100);
					addOffset("singRIGHT", 0, 100);
					addOffset("singLEFT", 0, 100);
					addOffset("singDOWN", 0, 100);
				}
				this.y += 270;

				playAnim('idle');
			case 'annie':
				tex = Paths.getSparrowAtlas('characters/Annie','shared');
				frames = tex;
				addAnimByPrefix('idle', "Pico Idle Dance", 24, true);
				addAnimByPrefix('singUP', 'pico Up note0', 24, false);
				addAnimByPrefix('singDOWN', 'Pico Down Note0', 24, false);
					// Need to be flipped! REDO THIS LATER!
				addAnimByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				addAnimByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);

				addOffset('idle');
				if(isPlayer){
					addOffset("singUP", 21, 27);
					addOffset("singRIGHT", 64, -4);
					addOffset("singLEFT", -75, 9); //Invertidos left y right porque el codigo lo invierte
					addOffset("singDOWN", -200, -72);
					this.y -= 50;
				}else{
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -68, -7);
					addOffset("singLEFT", 65, 9);
					addOffset("singDOWN", 200, -70);
					this.y += 300;
					this.x -= 80;
				}

				playAnim('idle');

				flipX = true;
			case 'tabi':
				tex = Paths.getSparrowAtlas('characters/TABI', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Dad idle dance', 24, true);
				addAnimByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				addAnimByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				addAnimByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				addAnimByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				if(isPlayer){
					addOffset("idle");
					addOffset("singUP", 44, 50);
					addOffset("singRIGHT", 30, 17);
					addOffset("singLEFT", 140, -30);
					addOffset("singDOWN", 20, -110);
				}else{
					addOffset("idle");
					addOffset("singUP", -6, 65);
					addOffset("singRIGHT", 60, 20);
					addOffset("singLEFT", 120, -18);
					addOffset("singDOWN", 100, -101);
				}
				playAnim('idle');
			case 'garcello':
                // garcello withcancer lol ANIMATION LOADING CODE
                tex = Paths.getSparrowAtlas('characters/garcello_assets', 'shared');
                frames = tex;
                addAnimByPrefix('idle', 'garcello idle dance', 24,true);
                addAnimByPrefix('singUP', 'garcello Sing Note UP', 24, false);
                addAnimByPrefix('singRIGHT', 'garcello Sing Note RIGHT', 24, false);
                addAnimByPrefix('singDOWN', 'garcello Sing Note DOWN', 24, false);
                addAnimByPrefix('singLEFT', 'garcello Sing Note LEFT', 24, false);

				addOffset("idle", -40, -2);
				addOffset("singUP", -48, -5);
				addOffset("singRIGHT", -40, -4);
				addOffset("singLEFT", -32, -3);
				addOffset("singDOWN", -44, -5);

				playAnim('idle');
			case 'bluskys':
				tex = Paths.getSparrowAtlas('characters/Bluskys', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Bluskys idle dance', 24,true);
				addAnimByPrefix('singUP', 'Bluskys Sing Note UP', 24, false);
				addAnimByPrefix('singRIGHT', 'Bluskys Sing Note RIGHT', 24, false);
				addAnimByPrefix('singDOWN', 'Bluskys Sing Note DOWN', 24, false);
				addAnimByPrefix('singLEFT', 'Bluskys Sing Note LEFT', 24, false);
				addAnimByPrefix('hey', 'Bluskys Letsgo', 24, false);

				if(!isPlayer){
					addOffset("idle", 0, -70);
					addOffset("singUP", -30, -36);
					addOffset("singRIGHT", -63, -83);
					addOffset("singLEFT", -30, -82);
					addOffset("singDOWN", -35, -91);
					addOffset("hey", 57, 19);
					this.y += 40;
				}else{
					addOffset("idle");
					addOffset("singUP", 0, 36);
					addOffset("singRIGHT", 27, -13);
					addOffset("singLEFT", -70, -12);
					addOffset("singDOWN", -68, -21);
					addOffset("hey", 77, 89);
					this.y += 110;
				}
				

				playAnim('idle');
			case 'tricky':
				/*var offsetsJson:Array<Dynamic> = cast Json.parse( Assets.getText( Paths.json('offsets') ).trim() ).offsets;
				var offsetsBF:Array<Dynamic> = cast Json.parse( Assets.getText( Paths.json('offsets') ).trim() ).offsets2;
				trace(offsetsJson);*/
				tex = Paths.getSparrowAtlas('characters/tricky', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Idle0', 24,true);
				addAnimByPrefix('singUP', 'Sing Up0', 24, false);
				addAnimByPrefix('singRIGHT', 'Sing Right0', 24, false);
				addAnimByPrefix('singDOWN', 'Sing Down0', 24, false);
				addAnimByPrefix('singLEFT', 'Sing Left0', 24, false);

				if(isPlayer){
					addOffset("idle");
					addOffset("singUP",-88,-5);
					addOffset("singRIGHT",230,-108);
					addOffset("singLEFT",-22,-3);
					addOffset("singDOWN",46,-20);
					this.x += 100;
				}else{
					/*for (ar in offsetsJson){
						addOffset(ar[0],ar[1],ar[2]);
					}*/
					addOffset("idle");
					addOffset("singUP",72,-5);
					addOffset("singRIGHT",20,-108);
					addOffset("singLEFT",78,-3);
					addOffset("singDOWN",16,-20);
					this.x -= 100;
				}
				this.y += 100;

				playAnim('idle');
			case 'impostor-black':
				tex = Paths.getSparrowAtlas('characters/black', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'BLACK IDLE0', 24,true);
				addAnimByPrefix('singUP', 'BLACK UP0', 24, false);
				addAnimByPrefix('singRIGHT', 'BLACK RIGHT0', 24, false);
				addAnimByPrefix('singDOWN', 'BLACK DOWN0', 24, false);
				addAnimByPrefix('singLEFT', 'BLACK LEFT0', 24, false);
				addAnimByPrefix('hey', 'BLACK DEATH0', 24, false);

				if(isPlayer){
					addOffset("idle");
					addOffset("singUP", 204, 102);
					addOffset("singRIGHT", 55, -11);
					addOffset("singLEFT", -68, 10);
					addOffset("singDOWN", 25, -20);
					addOffset("hey", 818, 238);
					this.x -= 10;
					this.y -= 290;
				}else{
					addOffset("idle");
					addOffset("singUP", 37, 102);
					addOffset("singRIGHT", -235, -10);
					addOffset("singLEFT", 111, 11);
					addOffset("singDOWN", -27, -20);
					addOffset("hey", 250, 238);
					this.x -= 300;
					this.y += 60;
				}

				playAnim('idle');
			case 'majin-sonic':
				tex = Paths.getSparrowAtlas('characters/SonicFunAssets', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'SONICFUNIDLE0', 24,true);
				addAnimByPrefix('singUP', 'SONICFUNUP0', 24, false);
				addAnimByPrefix('singRIGHT', 'SONICFUNRIGHT0', 24, false);
				addAnimByPrefix('singDOWN', 'SONICFUNDOWN0', 24, false);
				addAnimByPrefix('singLEFT', 'SONICFUNLEFT0', 24, false);

				if(isPlayer){
					addOffset("idle", 0, 130);
					addOffset("singUP", -120, 85);
					addOffset("singRIGHT", 0, 0);
					addOffset("singLEFT", -140, -105);
					addOffset("singDOWN", -20, -114);
				}else{
					addOffset("idle", 0, 130);
					addOffset("singUP", 50, 85);
					addOffset("singRIGHT", 0, 0);
					addOffset("singLEFT", 410, -105);
					addOffset("singDOWN", 40, -114);
				}
				this.y += 50;

				playAnim('idle');
			case "selever":
				tex = Paths.getSparrowAtlas('characters/Selever', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'SelIdle0', 24, false);
				addAnimByPrefix('singUP', 'SelUp0', 24, false);
				addAnimByPrefix('singLEFT', 'SelLeft0', 24, false);
				addAnimByPrefix('singRIGHT', 'SelRight0', 24, false);
				addAnimByPrefix('singDOWN', 'SelDown0', 24, false);
				addAnimByPrefix('hey', 'SelHey0', 24, false);

				if(isPlayer){
					addOffset("idle", 0, 0);
					addOffset("singUP", -98, 2);
					addOffset("singRIGHT", -38, 1);
					addOffset("singLEFT", -41, 0);
					addOffset("singDOWN", -38, -1);
					addOffset("hey", -64, 4);
				}else{
					addOffset("idle", 0, 0);
					addOffset("singUP", 92, 2);
					addOffset("singRIGHT", -38, 1);
					addOffset("singLEFT", -41, 0);
					addOffset("singDOWN", -38, -1);
					addOffset("hey", -64, 4);
				}

				playAnim('idle');
			case "henry":
				tex = Paths.getSparrowAtlas('characters/henry', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Dad idle dance', 24,true);
				addAnimByPrefix('singUP', 'Dad Sing Note UP', 24,false);
				addAnimByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24,false);
				addAnimByPrefix('singDOWN', 'Dad Sing Note DOWN', 24,false);
				addAnimByPrefix('singLEFT', 'Dad Sing Note LEFT', 24,false);
				antialiasing = true;

				if(isPlayer){
					addOffset("idle", 0, 0);
					addOffset("singUP", -46, 50);
					addOffset("singRIGHT", 30, 27);
					addOffset("singLEFT", -57, 10);
					addOffset("singDOWN", 40, -34);
				}else{
					addOffset("idle", 0, 0);
					addOffset("singUP", 13, 50);
					addOffset("singRIGHT", -8, 27);
					addOffset("singLEFT", -12, 10);
					addOffset("singDOWN", -10, -34);
				}
				this.y -= 20;

				playAnim('idle');

			case 'sarvente-lucifer':
				flyingOffset = 75;
				tex = Paths.getSparrowAtlas('characters/sarventeLucifer', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'LuciferSarvIdle0', 24, true);
				addAnimByPrefix('singUP', 'LuciferSarvUp0', 24, false);
				addAnimByPrefix('singDOWN', 'LuciferSarvDown0', 24, false);
				addAnimByPrefix('singLEFT', 'LuciferSarvLeft0', 24, false);
				addAnimByPrefix('singRIGHT', 'LuciferSarvRight0', 24, false);

				if(isPlayer){
					addOffset("idle", 0, 0);
					addOffset("singUP", 0, 50);
					addOffset("singRIGHT", 70, 70);
					addOffset("singLEFT", 80, 80);
					addOffset("singDOWN", 0, 140);
				}else{
					addOffset("idle", 0, 0);
					addOffset("singUP", 0, 50);
					addOffset("singRIGHT", -70, 70);
					addOffset("singLEFT", 80, 80);
					addOffset("singDOWN", 0, 140);
				}
				this.x -= 500;
				this.y -= 400;
				this.scale.set(0.8, 0.8);
				playAnim("idle");
			case 'ron':
				/*var datos = cast Json.parse( Assets.getText( Paths.json('offsets') ).trim() );
				trace(datos);*/
				tex = Paths.getSparrowAtlas('characters/Ron', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Idle0', 24,true);
				addAnimByPrefix('singUP', 'Sing Up0', 24, false);
				addAnimByPrefix('singDOWN', 'Sing Down0', 24, false);
				addAnimByPrefix('singLEFT', 'Sing Left0', 24, false);
				addAnimByPrefix('singRIGHT', 'Sing Right0', 24, false);
				addAnimByPrefix('ugh', 'Ugh0', 24, false);

				if(isPlayer){
					addOffset("idle", 0, 0);
					addOffset("singUP", 30, 30);
					addOffset("singRIGHT", 110, -29);
					addOffset("singLEFT", 0, 0);
					addOffset("singDOWN", 70, -100);
					addOffset("ugh", 40, -10);
				}else{
					addOffset("idle", 0, 0);
					addOffset("singUP", 30, 30);
					addOffset("singRIGHT", -60, -29);
					addOffset("singLEFT", 0, 0);
					addOffset("singDOWN", 0, -120);
					addOffset("ugh", 60, -30);
				}
				this.y += 250;

				playAnim('idle');
			case 'daidem':
				tex = Paths.getSparrowAtlas('characters/DaidemAssetsREwork', 'shared');
				frames = tex;
				this.isCustom = true;
				addAnimByPrefix('idle', 'Idke0', 24,true);
				addAnimByPrefix('singUP', 'Up0', 24, false);
				addAnimByPrefix('singDOWN', 'Down0', 24, false);
				addAnimByPrefix('singLEFT', 'Left0', 24, false);
				addAnimByPrefix('singRIGHT', 'Right0', 24, false);

				if(isPlayer){
					addOffset("idle", -200, 100);
					addOffset("singUP", -186, 110);
					addOffset("singLEFT", 70, 60);
					addOffset("singRIGHT", -50, 67);
					addOffset("singDOWN", -30, -160);
				}else{
					addOffset("idle", 0, 100);
					addOffset("singUP", 14, 110);
					addOffset("singRIGHT", 150, 67);
					addOffset("singLEFT", 270, 60);
					addOffset("singDOWN", 170, -160);
				}
				this.y -= 40;

				playAnim('idle');
			case 'retrospecter':
				tex = Paths.getSparrowAtlas('characters/RetroSpecter', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Retro IDLE0', 30,true);
				addAnimByPrefix('singUP', 'Retro UP0', 30, false);
				addAnimByPrefix('singDOWN', 'Retro DOWN0', 30, false);
				addAnimByPrefix('singLEFT', 'Retro LEFT0', 30, false);
				addAnimByPrefix('singRIGHT', 'Retro RIGHT0', 30, false);
				addAnimByPrefix('ugh', 'Ugh0', 24, false);

				if(isPlayer){
					addOffset("singUP", 80, -33);
					addOffset("singLEFT", 90, -20);
					addOffset("singRIGHT", 82, -30);
					addOffset("singDOWN", 83, -43);
				}else{
					addOffset("singUP", 20, -33);
					addOffset("singLEFT", 20, -20);
					addOffset("singRIGHT", 12, -30);
					addOffset("singDOWN", 13, -43);
				}
				addOffset('idle');
				this.y -= 60;

				playAnim('idle');
			case 'pico-minus':
				tex = Paths.getSparrowAtlas('characters/Pico_minus','shared');
				frames = tex;
				addAnimByPrefix('idle', "Pico Idle Dance", 24);
				addAnimByPrefix('singUP', 'pico Up note0', 24, false);
				addAnimByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					addAnimByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					addAnimByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					addOffset("singUP", 11, 21);
					addOffset("singLEFT", -44, -3);
					addOffset("singRIGHT", 65, -12);
					addOffset("singDOWN", 80, -83);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					addAnimByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					addAnimByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					addOffset("singUP", -69, 35);
					addOffset("singRIGHT", -28, -7);
					addOffset("singLEFT", 10, 1);
					addOffset("singDOWN", 150, -70);
				}

				addOffset('idle');

				playAnim('idle');

				flipX = true;
			case 'speakers':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/nogf_assets','shared');
				frames = tex;
				addAnimByPrefix('cheer', 'GF Cheer', 24, false);
				addAnimByPrefix('singLEFT', 'GF left note', 24, false);
				addAnimByPrefix('singRIGHT', 'GF Right Note', 24, false);
				addAnimByPrefix('singUP', 'GF Up Note', 24, false);
				addAnimByPrefix('singDOWN', 'GF Down Note', 24, false);
				addAnimByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				addAnimByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				addAnimByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				addAnimByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
				isDancingIdle = true;
			case 'crazy-GF':
				tex = Paths.getSparrowAtlas('characters/crazyGF', 'shared');
				frames = tex;
				addAnimByPrefix('idle', "gf Idle Dance", 24, true);
				addAnimByPrefix('singUP', 'gf Up note0', 24, false);
                addAnimByPrefix('singDOWN', 'gf Down Note0', 24, false);
                addAnimByPrefix('singRIGHT', 'gf Note Right0', 24, false);
                addAnimByPrefix('singLEFT', 'gf NOTE LEFT0', 24, false);

                addOffset('idle');

                if (isPlayer)
                {
                    addOffset("singUP", -20, 0);
                    addOffset("singRIGHT", 45, 0);
                    addOffset("singLEFT", 25, 0);
                    addOffset("singDOWN", 20, 0);
                }
                else
                {
                    addOffset("singUP", 30, 0);
                    addOffset("singLEFT", 85, 0);
                    addOffset("singRIGHT", 45, 10);
                    addOffset("singDOWN", -30, 0);
                }

                playAnim('idle');
				this.y += 260;
				this.x += 100;

                flipX = true;
			case 'sans':
				tex = Paths.getSparrowAtlas('characters/sans', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'idle0', 24,true);
				addAnimByPrefix('singUP', 'up0', 24, false);
                addAnimByPrefix('singDOWN', 'down0', 24, false);
                addAnimByPrefix('singRIGHT', 'right0', 24, false);
                addAnimByPrefix('singLEFT', 'left0', 24, false);
				addAnimByPrefix('singSwingUP', 'up0', 24, false);
                addAnimByPrefix('singSwingDOWN', 'down0', 24, false);
				this.updateHitbox();
				antialiasing = true;

				if(isPlayer){
					addOffset("idle", 0, 100);
					addOffset("singUP", 0, 100);
                    addOffset("singRIGHT", 0, 100);
                    addOffset("singLEFT", 0, 100);
                    addOffset("singDOWN", 0, 100);
					addOffset("singSwingDOWN", 0, 100);
					addOffset("singSwingUP", 0, 100);

					this.y += 100;
				}else{
					addOffset("idle", 0, 0);
					addOffset("singUP", 0, 0);
                    addOffset("singRIGHT", 0, 0);
                    addOffset("singLEFT", 0, 0);
                    addOffset("singDOWN", 0, 0);
					addOffset("singSwingDOWN", 0, 0);
					addOffset("singSwingUP", 0, 0);
				}
				this.x -= 150;

				playAnim('idle');
			case "myra":
				tex = Paths.getSparrowAtlas('characters/myra_assets', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'MyraIdle0', 8,true);
				addAnimByPrefix('singUP', 'MyraUp0', 24, false);
                addAnimByPrefix('singDOWN', 'MyraDown0', 24, false);
                addAnimByPrefix('singRIGHT', 'MyraRight00', 24, false);
                addAnimByPrefix('singLEFT', 'MyraLeft0', 24, false);
				addAnimByPrefix('singUP-alt', 'MyraAAA0', 24, false);
				addAnimByPrefix('singLaugh', 'MyraLaugh0', 6, true);
				this.updateHitbox();
				antialiasing = true;

					addOffset("idle", 0, 0);
					addOffset("singUP", 0, 0);
                    addOffset("singRIGHT", 0, 0);
                    addOffset("singLEFT", 0, 0);
                    addOffset("singDOWN", 0, 0);
					addOffset("singUP-alt", 0, 0);
					addOffset("singLaugh", 0, 0);

				playAnim('idle');

			case "salad-fingers":
				tex = Paths.getSparrowAtlas('characters/salad_fingers', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Dad idle dance0', 24,true);
				addAnimByPrefix('singUP', 'Dad Sing Note UP0', 24, false);
                addAnimByPrefix('singDOWN', 'Dad Sing Note DOWN0', 24, false);
                addAnimByPrefix('singRIGHT', 'Dad Sing Note RIGHT0', 24, false);
                addAnimByPrefix('singLEFT', 'Dad Sing Note LEFT0', 24, false);
				this.updateHitbox();
				antialiasing = true;

				if(isPlayer){
					addOffset("idle", 0, 0);
					addOffset("singUP", -39, 30);
                    addOffset("singRIGHT", 70, 0);
                    addOffset("singLEFT", -100, 0);
                    addOffset("singDOWN", 10, -30);
				}else{
					addOffset("idle", 0, 0);
					addOffset("singUP", -19, 20);
                    addOffset("singRIGHT", -80, 0);
                    addOffset("singLEFT", 60, 0);
                    addOffset("singDOWN", 10, -40);
				}

				playAnim('idle');

			case "void":
				tex = Paths.getSparrowAtlas('characters/void_assets', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Void Idle0', 24,true);
				addAnimByPrefix('singUP', 'Void Up Note Chill', 24, false);
                addAnimByPrefix('singDOWN', 'Void Down Note Chill0', 24, false);
                addAnimByPrefix('singRIGHT', 'Void Right Note Chill0', 24, false);
                addAnimByPrefix('singLEFT', 'Void Left Note Chill0', 24, false);
				addAnimByPrefix('singUP-alt', 'Void Up Note Hype', 24, false);
				addAnimByPrefix('singCenter', 'Void Up Note Hype', 24, false);
                addAnimByPrefix('singDOWN-alt', 'Void Down Note Hype0', 24, false);
                addAnimByPrefix('singRIGHT-alt', 'Void Right Note Hype0', 24, false);
                addAnimByPrefix('singLEFT-alt', 'Void Left Note Hype0', 24, false);
				addAnimByPrefix('hey', 'Void Wink0', 24, false);
                addAnimByPrefix('seethe', 'Void Seethe0', 24, false);
                addAnimByPrefix('sickintro', 'Void Intro0', 24, false);
				this.updateHitbox();
				antialiasing = true;

				if(isPlayer){
					addOffset("idle", 0, 0);
					addOffset("singUP", -47, 24);
                    addOffset("singRIGHT", 26, -30);
                    addOffset("singLEFT", -80, -10);
                    addOffset("singDOWN", -31, -29);
					addOffset("singUP-alt", -7, 56);
                    addOffset("singRIGHT-alt", 52, -16);
					addOffset("singCenter", 52, -16);
                    addOffset("singLEFT-alt", -10, 15);
                    addOffset("singDOWN-alt", -30, -27);
                    addOffset("hey", 40, -55);
                    addOffset("seethe", 40, -53);
                    addOffset("sickintro", 40, -55);
					this.x += 100;
				}else{
					addOffset("idle", 0, 0);
					addOffset("singUP", 3, 16);
                    addOffset("singRIGHT", 30, -34);
                    addOffset("singLEFT", -55, -16);
                    addOffset("singDOWN", -31, -29);
					addOffset("singUP-alt", 3, 16);
					addOffset("singCenter", 3, 16);
                    addOffset("singRIGHT-alt", -8, -56);
                    addOffset("singLEFT-alt", -131, 14);
                    addOffset("singDOWN-alt", -30, -27);
                    addOffset("hey", -175, -55);
                    addOffset("seethe", -174, -53);
                    addOffset("sickintro", -170, -55);
					this.x -= 250;
				}

				playAnim('idle');
				
			case "cassette-girl":
				tex = Paths.getSparrowAtlas('characters/cassettegirl', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'cassettegirl idle0', 24,true);
				addAnimByPrefix('singUP', 'cassettegirl up0', 24, false);
                addAnimByPrefix('singDOWN', 'cassettegirl down0', 24, false);
                addAnimByPrefix('singRIGHT', 'cassettegirl right0', 24, false);
                addAnimByPrefix('singLEFT', 'cassettegirl left0', 24, false);
				this.updateHitbox();
				antialiasing = true;

				if(isPlayer){
					addOffset("idle", 0, 0);
					addOffset("singUP", 0, 0);
                    addOffset("singRIGHT", -2, 0);
                    addOffset("singLEFT", 0, -2);
                    addOffset("singDOWN", 2, -1);
				}else{
					addOffset("idle", 0, 0);
					addOffset("singUP", 0, 0);
                    addOffset("singRIGHT", 0, 0);
                    addOffset("singLEFT", 0, -2);
                    addOffset("singDOWN", 0, -1);
				}
				this.y += 40;
				playAnim('idle');

			case "sunday":
				tex = Paths.getSparrowAtlas('characters/sunday_assets', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'sunday idle0', 24,true);
				addAnimByPrefix('singUP', 'sunday up0', 24, false);
                addAnimByPrefix('singDOWN', 'sunday down0', 24, false);
                addAnimByPrefix('singRIGHT', 'sunday right0', 24, false);
                addAnimByPrefix('singLEFT', 'sunday left0', 24, false);
				addAnimByPrefix('hey', 'sunday left0', 24, false);
				antialiasing = true;

				if(isPlayer){
					addAnimByPrefix('singUP', 'sunday alt up0', 24, false);
					addOffset("idle", -360, -50);
					addOffset("singUP", 112, 99);
                    addOffset("singRIGHT", -143, -58);
					addOffset("hey", -363, -50);
                    addOffset("singLEFT", -363, -50);
                    addOffset("singDOWN", -240, -75);
					this.x -= 150;
					this.y -= 150;
				}else{
					addOffset("idle", -150, -50);
					addOffset("singUP", -20, 99);
                    addOffset("singRIGHT", -220, -58);
					addOffset("hey", -114, -50);
                    addOffset("singLEFT", -114, -50);
                    addOffset("singDOWN", 0, -75);
					this.y += 200;
				}

				playAnim('idle');
			case 'hank':
				tex = Paths.getSparrowAtlas('characters/hank', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Hank Idle0', 24,true);
				addAnimByPrefix('getReady', 'HankGetReady0', 24,true);
				addAnimByPrefix('hey', 'hanktaunt0', 24,false);
				addAnimByPrefix('singScream', 'Hank screamright0', 24, false);
				addAnimByPrefix('singUP', 'Hank Up note0', 24, false);
                addAnimByPrefix('singDOWN', 'Hank Down Note0', 24, false);
                addAnimByPrefix('singRIGHT', 'Hank right note0', 24, false);
                addAnimByPrefix('singLEFT', 'Hank Left Note0', 24, false);
				addAnimByPrefix('singUP-alt', 'Hank Up shoot0', 24, false);
                addAnimByPrefix('singDOWN-alt', 'Hank Down Shoot0', 24, false);
                addAnimByPrefix('singRIGHT-alt', 'Hank right shoot0', 24, false);
                addAnimByPrefix('singLEFT-alt', 'Hank Left Shoot0', 24, false);
				antialiasing = true;

				if(isPlayer){
					addAnimByPrefix('singLEFT-alt', 'Hank right shoot0', 24, false);
					addAnimByPrefix('singRIGHT-alt', 'Hank Left Shoot0', 24, false);
					addOffset("idle", -100, 0);
					addOffset("getReady", 8, -84);
					addOffset("singScream", 198, 11);
					addOffset("singUP", -122, 1);
					addOffset("singUP-alt", 399, 0);
					addOffset("singRIGHT", 1, 11);
					addOffset("singLEFT-alt", 465, 11);
					addOffset("singLEFT", -108, 16);
					addOffset("singRIGHT-alt", 256, 15);
					addOffset("singDOWN", -18, 12);
					addOffset("singDOWN-alt", 393, 12);
					addOffset("hey",80,-30);
				}else{
					addOffset("idle", 0, 0);
					addOffset("getReady", 8, -84);
					addOffset("singScream", 88, 11);
					addOffset("singUP", 8, 1);
					addOffset("singUP-alt", 9, 0);
					addOffset("singRIGHT", 101, 11);
					addOffset("singRIGHT-alt", -15, 11);
					addOffset("singLEFT", 322, 16);
					addOffset("singLEFT-alt", 46, 15);
					addOffset("singDOWN", 42, 12);
					addOffset("singDOWN-alt", 43, 12);
					addOffset("hey",170,-30);
				}
				this.y += 180;

				playAnim('getReady');

			case "ex-tricky":
				tex = Paths.getSparrowAtlas('characters/EXCLOWN', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Idle0', 24,true);
				addAnimByPrefix('singUP', 'Sing Up0', 24, false);
                addAnimByPrefix('singDOWN', 'Sing Down0', 24, false);
                addAnimByPrefix('singRIGHT', 'Sing Right0', 24, false);
                addAnimByPrefix('singLEFT', 'Sing Left0', 24, false);
				this.scale.set(0.8, 0.8);
				this.updateHitbox();
				antialiasing = true;

				if(isPlayer){
					addOffset("idle", 0, 200);
					addOffset("singUP", -60, 310);
					addOffset("singRIGHT", 350, 170);
					addOffset("singLEFT", -220, 280);
					addOffset("singDOWN", -110, -58);
					this.x -= 20;
				}else{
					addOffset("idle", 200, 200);
					addOffset("singUP", 190, 310);
					addOffset("singRIGHT", -90, 170);
					addOffset("singLEFT", 380, 280);
					addOffset("singDOWN", 80, -58);
					this.x -= 150;
				}
				this.y += 160;

				playAnim('idle');

			case "cassandra":
				tex = Paths.getSparrowAtlas('characters/cassandra_assets',"shared");
				frames = tex;
				addAnimByPrefix('idle', "CASS IDLE0", 24);
				addAnimByPrefix('singUP', 'CASS UP NOTE0', 24, false);
				addAnimByPrefix('singDOWN', 'CASS DOWN NOTE0', 24, false);
				addAnimByPrefix('singRIGHT', 'CASS LEFT NOTE0', 24, false);
				addAnimByPrefix('singLEFT', 'CASS RIGHT NOTE0', 24, false);
				if (isPlayer)
				{
					addOffset("idle", -80, 60);
					addOffset("singUP", -79, 96);
					addOffset("singLEFT", -86, 53);
					addOffset("singRIGHT", -33, 50);
					addOffset("singDOWN", 7, -41);
					this.y -= 70;
				}
				else
				{
					addOffset("idle", -20, 60);
					addOffset("singUP", -19, 96);
					addOffset("singLEFT", 34, 53);
					addOffset("singRIGHT", -73, 50);
					addOffset("singDOWN", -33, -41);
					this.y += 280;
				}

				playAnim('idle');

				flipX = true;

			case 'sad-cass':
				var tex = Paths.getSparrowAtlas('characters/sadcass_assets','shared');
				curCharacter = 'bf-sad-cass';
				frames = tex;
				addAnimByPrefix('firstDeath', 'BF dies0', 24, false);
				addAnimByPrefix('deathLoop','BF Dead Loop0', 24, true);
				addAnimByPrefix('deathConfirm', 'BF Dead confirm0', 24, false);

				addOffset("firstDeath", 60, -29);
				addOffset("deathLoop", 8, -33);
				addOffset("deathConfirm", 6, 23);

				this.y -= 100;

				this.flipX = true;

				playAnim("deathLoop");

			case 'mami':
                tex = Paths.getSparrowAtlas('characters/Mami','shared');
                frames = tex;
                addAnimByPrefix('idle', 'IDLE', 24,true);
                addAnimByPrefix('singUP', 'UP', 24,false);
                addAnimByPrefix('singRIGHT', 'RIGHT', 24,false);
                addAnimByPrefix('singDOWN', 'DOWN', 24,false);
                addAnimByPrefix('singLEFT', 'LEFT', 24,false);

                if (isPlayer)
                {
                    addOffset('idle', 31, 126); //24
                    addOffset("singUP", 340, 135); //-5
                    addOffset("singLEFT", 170, 115); //-35
                    addOffset("singRIGHT", 315, 115); //-35
                    addOffset("singDOWN", 40, 85); //-65
					this.y -= 410;
                }
                else
                {
                    addOffset('idle', -69, 126); //24
                    addOffset("singUP", 150, 145); //-5
                    addOffset("singRIGHT", 40, 115); //-35
                    addOffset("singLEFT", -10, 115); //-35
                    addOffset("singDOWN", 50, 85); //-65
					this.x -= 260;
					this.y -= 60;
                }

                playAnim('idle');
			case 'tord':
                tex = Paths.getSparrowAtlas('characters/tord_assets_2', 'shared');
                frames = tex;
                addAnimByPrefix('idle', 'garcellotired idle dance', 24,true);
                addAnimByPrefix('singUP', 'garcellotired Sing Note UP', 24,false);
                addAnimByPrefix('singRIGHT', 'garcellotired Sing Note RIGHT', 24,false);
                addAnimByPrefix('singDOWN', 'garcellotired Sing Note DOWN', 24,false);
                addAnimByPrefix('singLEFT', 'garcellotired Sing Note LEFT', 24,false);
                addAnimByPrefix('cough', 'garcellotired cough', 24,false);
				this.setGraphicSize(Std.int(this.width * 1.1));

                if(isPlayer)
                {
                    addOffset('idle', 220, 87);
                    addOffset("singUP", 221, 91);
                    addOffset("singLEFT", 207, 87);
                    addOffset("singRIGHT", 215, 90);
                    addOffset("singDOWN", 222, 86);
                    addOffset('cough', 217, 90);
                }
                else
                {
                    addOffset('idle', 110, 40);
                    addOffset("singUP", 110, 42);
                    addOffset("singRIGHT", 117, 43);
                    addOffset("singLEFT", 123, 40);
                    addOffset("singDOWN", 109, 38);
                    addOffset('cough', 115, 43);
                }
                playAnim('idle'); 

			case 'nene':
                tex = Paths.getSparrowAtlas('characters/nene', 'shared');
                frames = tex;
                addAnimByPrefix('idle', 'Pico Idle Dance', 24,true);
                addAnimByPrefix('singUP', 'pico Up note', 24,false);
                addAnimByPrefix('singRIGHT', 'Pico NOTE LEFT', 24,false);
                addAnimByPrefix('singDOWN', 'Pico Down Note', 24,false);
                addAnimByPrefix('singLEFT', 'Pico Note Right', 24,false);
				this.scale.set(1.1,1.1);
				this.updateHitbox();
				antialiasing = true;

				if(isPlayer){
					addOffset("idle", -170, 70);
					addOffset("singUP", -210, 100);
					addOffset("singRIGHT", -110, 63);
					addOffset("singLEFT", -204, 80);
					addOffset("singDOWN", -93, -116);
					this.x += 40;
					this.y -= 30;
				}else{
					addOffset("idle", 190, 70);
					addOffset("singUP", 160, 100);
					addOffset("singRIGHT", 130, 63);
					addOffset("singLEFT", 254, 80);
					addOffset("singDOWN", 90, -116);
					this.x += 200;
					this.y += 300;
				}

				this.flipX = true;

				playAnim('idle');

			case 'kopek':
				tex = Paths.getSparrowAtlas('characters/Kopek', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Pico Idle Dance0', 24,true);
				addAnimByPrefix('singUP', 'pico Up note0', 24, false);
                addAnimByPrefix('singDOWN', 'Pico Down Note0', 24, false);
                addAnimByPrefix('singLEFT', 'Pico Note Right0', 24, false);
                addAnimByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				this.scale.set(1.2, 1.2);
				this.updateHitbox();
				antialiasing = true;

				if(isPlayer){
					addOffset("idle", 0, 0);
					addOffset("singUP", 28, 33);
					addOffset("singLEFT", -43, 10);
					addOffset("singRIGHT", 83, -7);
					addOffset("singDOWN", 90, -80);
				}else{
					addOffset("idle", 0, 0);
					addOffset("singUP", -50, 33);
					addOffset("singLEFT", 50, 10);
					addOffset("singRIGHT", -87, -7);
					addOffset("singDOWN", 250, -80);
				}
				this.x += 100;
				this.y += 250;

				this.flipX = true;

				playAnim('idle');
			case 'eder-jr':
				tex = Paths.getSparrowAtlas('characters/Eder_Jr', 'shared');
				frames = tex;
				addAnimByPrefix('idle', 'Eder Jr Eder Jr', 24,true);
				this.scale.set(6, 6);
				this.updateHitbox();
				antialiasing = false;

				if(isPlayer){
					addOffset('idle',0,0);
				}else{
					addOffset('idle',0,0);
				}
				this.sync = false;
				this.x += 200;
				this.y += 470;

				playAnim('idle');
			default:
				var routePNG:String = "assets/shared/images/characters/" + curCharacter + "/" + curCharacter + ".png";
				var routeXML:String = "assets/shared/images/characters/" + curCharacter + "/" + curCharacter + ".xml";
				var routeOffsets:String = "assets/shared/images/characters/" + curCharacter + "/" + curCharacter + ".json";
				var vuelo:Float = 0;

				if(sys.FileSystem.exists(routePNG) && sys.FileSystem.exists(routeXML) && sys.FileSystem.exists(routeOffsets)){
					var datos = Json.parse(sys.io.File.getContent(routeOffsets).trim());
					trace(datos);
					tex = FlxAtlasFrames.fromSparrow(openfl.display.BitmapData.fromFile(routePNG), sys.io.File.getContent(routeXML));
					frames = tex;
					var animations:Array<Dynamic> = [];
					animations = datos.animations;
					for (anim in animations){
						if(anim.indices != null && anim.indices.length > 0){
							addAnimByIndices(anim.anim, anim.name, anim.indices, "", anim.fps, anim.loop);
						}else{
							addAnimByPrefix(anim.anim, anim.name, anim.fps, anim.loop);
						}
						animationsArray[animIndex.get(anim.anim)].offsets = anim.offsets;
						if(anim.offsetsPlayer != null)
							animationsArray[animIndex.get(anim.anim)].offsetsPlayer = anim.offsetsPlayer;
						if(isPlayer && anim.offsetsPlayer != null){
							//addOffset(anim.anim, anim.offsetsPlayer[0], anim.offsetsPlayer[1]);
							animOffsets[anim.anim] = [anim.offsetsPlayer[0], anim.offsetsPlayer[1]];
						}else
							//addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
							animOffsets[anim.anim] = [anim.offsets[0], anim.offsets[1]];
					}
					antialiasing = !datos.no_antialiasing;
					if(animation.getByName("danceLeft") != null && animation.getByName("danceRight") != null){
						isDancingIdle = true;
						if(animation.getByName("idle") == null){
							var danceFrames:Array<Int> = [];
							for(frame in animation.getByName("danceLeft").frames)
								danceFrames.push(frame);
							for(frame in animation.getByName("danceRight").frames)
								danceFrames.push(frame);
							animation.add("idle",danceFrames,animation.getByName("danceLeft").frameRate,false);
							/*animation.add("idle",animation.getByName("danceLeft").frames,animation.getByName("danceLeft").frameRate,false);
							animation.append("idle",animation.getByName("danceRight").frames);*/
							if(!animIndex.exists("idle")){
								animationsArray.push(animationsArray[animIndex.get("danceLeft")]);
								animationsArray[animationsArray.length-1].anim = "idle";
								animationsArray[animationsArray.length-1].indices = [];
							}
							addOffset('idle', animOffsets['danceLeft'][0], animOffsets['danceLeft'][1]);
						}
					}
					if(datos.sing_duration != 0)
						singDuration = datos.sing_duration;
					if(datos.camera_position != null)
						cameraPosition = datos.camera_position;
					if(datos.playerCameraPosition != null){
						camPlayerPosition = datos.playerCameraPosition;
					}
					if(datos.scale != 0){
						this.scale.set(datos.scale,datos.scale);
						this.updateHitbox();
					}
					if(datos.healthbar_colors != null){
						this.colorCode = [datos.healthbar_colors[0],datos.healthbar_colors[1],datos.healthbar_colors[2]];
					}
					if(datos.playerPosition != null){
						if(isPlayer){
							this.x += datos.playerPosition[0];
							this.y += datos.playerPosition[1];
						}
						playerPos = datos.playerPosition;
					}
					if(datos.position != null){
						if(!isPlayer){
							this.x += datos.position[0];
							this.y += datos.position[1];
						}
						posOffsets = datos.position;
					}
					if(datos.flying_offset != 0)
						vuelo = datos.flying_offset;
					this.flyingOffset = vuelo;
					this.flipX = !!datos.flip_x;
					isCustom = true;

					playAnim("idle");
				}else{
					this.curCharacter = "eder-jr";
					tex = Paths.getSparrowAtlas('characters/Eder_Jr', 'shared');
					frames = tex;
					addAnimByPrefix('idle', 'Eder Jr Eder Jr', 24,true);
					this.scale.set(6, 6);
					this.updateHitbox();
					antialiasing = false;

					if(isPlayer){
						addOffset('idle',0,0);
					}else{
						addOffset('idle',0,0);
					}
					this.sync = false;
					this.x += 200;
					this.y += 470;

					playAnim('idle');
				}
		}//Fin del switch

		originalFlipX = this.flipX;

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf') && curCharacter != "eder-jr")
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;
				var offsetR = animOffsets.get('singRIGHT');
				var offsetL = animOffsets.get('singLEFT');
				var aux:AnimArray = Reflect.copy(animationsArray[animIndex.get("singLEFT")]);
				animationsArray[animIndex.get("singLEFT")] = Reflect.copy(animationsArray[animIndex.get("singRIGHT")]);
				animationsArray[animIndex.get("singRIGHT")] = aux;
				/*addOffset("singRIGHT", offsetL[0], offsetL[1]);
				addOffset("singLEFT", offsetR[0], offsetR[1]);*/
				animOffsets.set("singRIGHT",offsetL);
				animOffsets.set("singLEFT",offsetR);

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
					offsetR = animOffsets.get('singRIGHTmiss');
					offsetL = animOffsets.get('singLEFTmiss');
					aux = Reflect.copy(animationsArray[animIndex.get("singLEFTmiss")]);
					animationsArray[animIndex.get("singLEFTmiss")] = Reflect.copy(animationsArray[animIndex.get("singRIGHTmiss")]);
					animationsArray[animIndex.get("singRIGHTmiss")] = aux;
					/*addOffset("singRIGHT", offsetL[0], offsetL[1]);
					/*addOffset("singRIGHTmiss", offsetL[0], offsetL[1]);
					addOffset("singLEFTmiss", offsetR[0], offsetR[1]);*/
					animOffsets.set("singRIGHTmiss",offsetL);
					animOffsets.set("singLEFTmiss",offsetR);
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
	if(!debugMode){
		if (!isPlayingAsBF)
		{
			if (/*curCharacter.startsWith('bf') && !*/isPlayer)
				{
					if (animation.curAnim.name.startsWith('sing'))
					{
						holdTimer += elapsed;
					}
		
					/*var dadVar:Float = 4;
		
					if (curCharacter == 'dad')
						dadVar = 6.1;
					if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
					{
						trace('dance');
						dance();
						holdTimer = 0;
					}*/
					if (holdTimer >= Conductor.stepCrochet * singDuration * 0.001)
					{
						trace('dance');
						dance();
						holdTimer = 0;
					}
				}
		
		}
		else
		{
			if (!isPlayer)
				{
					if (animation.curAnim.name.startsWith('sing'))
					{
						holdTimer += elapsed;
					}
		
					if (holdTimer >= Conductor.stepCrochet * singDuration * 0.001)
					{
						trace('dance');
						dance();
						holdTimer = 0;
					}
				}
		}
		
		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		if(flyingOffset != 0 && !debugMode){
			if(flag){
				flag = false;
				switch(fase){
					case 0:
						FlxTween.tween(this, {y: this.y-flyingOffset}, 1.5, {
							ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween)
							{
								fase = 1;
								flag = true;
							}
						});
					case 1:
						FlxTween.tween(this, {y: this.y+flyingOffset}, 1.5, {
							ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween)
							{
								fase = 0;
								flag = true;
							}
						});
				}
			} //fin del if
		}

		if(this.isDancingIdle){
			if((!isPlayingAsBF && isPlayer) || (isPlayingAsBF && !isPlayer)){
				if(!animation.curAnim.name.startsWith('sing') && !animation.curAnim.name.startsWith('death') && !animation.curAnim.name.startsWith('dance') && animation.curAnim.finished){
					dance();
				}
			}
		}else{
			if((!isPlayingAsBF && isPlayer) || (isPlayingAsBF && !isPlayer)){
				if(!animation.curAnim.name.startsWith('sing') && !animation.curAnim.name.startsWith('death') && animation.curAnim.name != "idle" && animation.curAnim.finished){
					dance();
				}
			}
		}

		if(flagAnims){
		if(isPlayer){
			if(playerPos != null)
				posOffsets = playerPos;
			if(camPlayerPosition != null)
				cameraPosition = camPlayerPosition;
		}
		if(curCharacter.toLowerCase().startsWith('gf') || curCharacter == "speakers"){
			if(animation.getByName('hey') == null && animation.getByName('cheer') != null){
				animation.add("hey",animation.getByName('cheer').frames,24,false);
				if(animOffsets['hey'] != null){
					addOffset('hey', animOffsets['cheer'][0], animOffsets['cheer'][1]);
				}
			}
			if(animation.getByName('singHey') == null && animation.getByName('cheer') != null){
				animation.add("singHey",animation.getByName('cheer').frames,24,false);
				if(animOffsets['singHey'] != null){
					addOffset('singHey', animOffsets['cheer'][0], animOffsets['cheer'][1]);
				}
			}
		}else{
			if(animation.getByName('singCenter') == null){
				if(animation.getByName('hey') != null){
					animation.add("singCenter",animation.getByName('hey').frames,24,false);
					if(animOffsets['hey'] != null){
						addOffset('singCenter', animOffsets['hey'][0], animOffsets['hey'][1]);
					}
				}else{
					if(animation.getByName('singDOWN') != null){
					animation.add("singCenter",animation.getByName('singDOWN').frames,24,false);
						if(animOffsets['singDOWN'] != null){
							addOffset('singCenter', animOffsets['singDOWN'][0], animOffsets['singDOWN'][1]);
						}
					}
				}//else end
			}
			if(animation.getByName('singCenter-alt') == null && animation.getByName('singCenter') != null){
				animation.add("singCenter-alt",animation.getByName('singCenter').frames,24,false);
				if(animOffsets['singCenter'] != null){
					addOffset('singCenter-alt', animOffsets['singCenter'][0], animOffsets['singCenter'][1]);
				}
			}
			if(animation.getByName('hey') == null && animation.getByName('singUP') != null){
				animation.add("hey",animation.getByName('singUP').frames,24,false);
				if(animOffsets['singUP'] != null){
					addOffset('hey', animOffsets['singUP'][0], animOffsets['singUP'][1]);
				}
			}
			if(animation.getByName('hey') != null && animation.getByName('singHey') == null){
				animation.add("singHey",animation.getByName('hey').frames,24,false);
				addOffset('singHey', animOffsets['hey'][0], animOffsets['hey'][1]);
			}
			if(animation.getByName('singUPmiss') == null && animation.getByName('idle') != null){
				animation.add("singUPmiss",animation.getByName('idle').frames,24,false);
				if(animOffsets['idle'] != null){
					addOffset('singUPmiss', animOffsets['idle'][0], animOffsets['idle'][1]);
				}
			}
			if(animation.getByName('singDOWNmiss') == null && animation.getByName('idle') != null){
				animation.add("singDOWNmiss",animation.getByName('idle').frames,24,false);
				if(animOffsets['idle'] != null){
					addOffset('singDOWNmiss', animOffsets['idle'][0], animOffsets['idle'][1]);
				}
			}
			if(animation.getByName('singLEFTmiss') == null && animation.getByName('idle') != null){
				animation.add("singLEFTmiss",animation.getByName('idle').frames,24,false);
				if(animOffsets['idle'] != null){
					addOffset('singLEFTmiss', animOffsets['idle'][0], animOffsets['idle'][1]);
				}
			}
			if(animation.getByName('singRIGHTmiss') == null && animation.getByName('idle') != null){
				animation.add("singRIGHTmiss",animation.getByName('idle').frames,24,false);
				if(animOffsets['idle'] != null){
					addOffset('singRIGHTmiss', animOffsets['idle'][0], animOffsets['idle'][1]);
				}
			}
			if(animation.getByName('singUP-alt') == null && animation.getByName('singUP') != null){
				animation.add("singUP-alt",animation.getByName('singUP').frames,24,false);
				if(animOffsets['singUP'] != null){
					addOffset('singUP-alt', animOffsets['singUP'][0], animOffsets['singUP'][1]);
				}
			}
			if(animation.getByName('singDOWN-alt') == null && animation.getByName('singDOWN') != null){
				animation.add("singDOWN-alt",animation.getByName('singDOWN').frames,24,false);
				if(animOffsets['singDOWN'] != null){
					addOffset('singDOWN-alt', animOffsets['singDOWN'][0], animOffsets['singDOWN'][1]);
				}
			}
			if(animation.getByName('singLEFT-alt') == null && animation.getByName('singLEFT') != null){
				animation.add("singLEFT-alt",animation.getByName('singLEFT').frames,24,false);
				if(animOffsets['singLEFT'] != null){
					addOffset('singLEFT-alt', animOffsets['singLEFT'][0], animOffsets['singLEFT'][1]);
				}
			}
			if(animation.getByName('singRIGHT-alt') == null && animation.getByName('singRIGHT') != null){
				animation.add("singRIGHT-alt",animation.getByName('singRIGHT').frames,24,false);
				if(animOffsets['singRIGHT'] != null){
					addOffset('singRIGHT-alt', animOffsets['singRIGHT'][0], animOffsets['singRIGHT'][1]);
				}
			}
		}
		flagAnims = false;
		}//fin del if flagAnims

		if(sync){
			if((isPlayer && isPlayingAsBF) || (!isPlayer && !isPlayingAsBF)){
				if(this.animation.curAnim.name != "idle" && PlayState.boyfriend.animation.curAnim.name == "idle"){
					playAnim("idle");
				}else{
					if(this.animation.curAnim.name != PlayState.boyfriend.animation.curAnim.name && animation.getByName(PlayState.boyfriend.animation.curAnim.name) != null){
						playAnim(PlayState.boyfriend.animation.curAnim.name);
					}
				}
				/*if(PlayState.boyfriend.animation.curAnim.name.startsWith('sing') && this.animation.curAnim.finished)
					playAnim(PlayState.boyfriend.animation.curAnim.name);*/
				if(PlayState.boyfriend.animation.curAnim.name.startsWith('sing') && PlayState.boyfriend.holdTimer < this.holdTimer && !PlayState.boyfriend.animation.curAnim.name.contains('miss')){
					playAnim(PlayState.boyfriend.animation.curAnim.name,true);
					holdTimer = PlayState.boyfriend.holdTimer;
				}
				if(this.animation.curAnim.name == "idle" && this.animation.curAnim.finished)
					playAnim("idle");
			}else{
				if(this.animation.curAnim.name != "idle" && PlayState.dad.animation.curAnim.name == "idle"){
					playAnim("idle");
				}else{
					if(this.animation.curAnim.name != PlayState.dad.animation.curAnim.name && animation.getByName(PlayState.dad.animation.curAnim.name) != null){
						playAnim(PlayState.dad.animation.curAnim.name);
					}
				}
				/*if(PlayState.dad.animation.curAnim.name.startsWith('sing') && this.animation.curAnim.finished)
					playAnim(PlayState.dad.animation.curAnim.name);*/
				if(PlayState.dad.animation.curAnim.name.startsWith('sing') && PlayState.dad.holdTimer < this.holdTimer && !PlayState.dad.animation.curAnim.name.contains('miss')){
					playAnim(PlayState.dad.animation.curAnim.name,true);
					holdTimer = PlayState.dad.holdTimer;
				}
				if(this.animation.curAnim.name == "idle" && this.animation.curAnim.finished)
					dance();
			}
		}else{
			if(!hasFocus && !curCharacter.startsWith('gf')){
				if(this.animation.curAnim.name == "idle" && this.animation.curAnim.finished)
					playAnim("idle");
			}//fin del has focus
		}//fin del if sync
	}//Fin del if debug
		super.update(elapsed);
	}//Fin del update

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			/*switch (curCharacter)
			{
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					if(isDancingIdle){
						danced = !danced;
						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}else
						playAnim('idle');
			}*/
			if(curCharacter.toLowerCase().startsWith('gf') || curCharacter == "speakers"){
				if (!animation.curAnim.name.startsWith('hair') || (animation.curAnim.name.startsWith('cheer') && animation.curAnim.finished))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
			}else{
				if(isDancingIdle){
						danced = !danced;
						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}else
						playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
		if(animIndex.exists(name)){
			if(this.isPlayer)
				animationsArray[animIndex.get(name)].offsetsPlayer = [Math.round(x), Math.round(y)];
			animationsArray[animIndex.get(name)].offsets = [Math.round(x), Math.round(y)];
			//trace("Added offset: "+animationsArray[animIndex.get(name)]);
		}
	}

	public function setSynchronous(synchronize:Bool){
		this.sync = synchronize;
	}

	public function isSynchronous():Bool{
		return this.sync;
	}

	public function markAsFlipped(){
		isPlayer = !isPlayer;
		charFlipped = true;
	}

	public function isFlipped():Bool{
		return charFlipped;
	}

	private function addAnimByPrefix(name:String, prefix:String, frameRate = 30, looped = true){
		animation.addByPrefix(name, prefix, frameRate, looped);
		var data = {
			anim: name,
			name: prefix,
			loop: looped,
			fps: frameRate,
			indices: [],
			offsets: [0,0],
			offsetsPlayer: [0,0]
		};
		animationsArray.push(data);
		animIndex.set(name,animationsArray.length-1);
	}

	private function addAnimByIndices(Name:String, Prefix:String, Indices:Array<Int>, Postfix:String, FrameRate:Int = 30, Looped:Bool = true){
		animation.addByIndices(Name, Prefix, Indices, Postfix, FrameRate, Looped);
		var data = {
			anim: Name,
			name: Prefix,
			loop: Looped,
			fps: FrameRate,
			indices: Indices,
			offsets: [0,0],
			offsetsPlayer: [0,0]
		};
		animationsArray.push(data);
		animIndex.set(Name,animationsArray.length-1);
	}

	public function shiftLRAnims(){
		var offsets = [Reflect.copy(animationsArray[animIndex.get("singLEFT")]).offsetsPlayer,
						Reflect.copy(animationsArray[animIndex.get("singRIGHT")]).offsetsPlayer];
		animationsArray[animIndex.get("singRIGHT")].offsetsPlayer = offsets[0];
		animationsArray[animIndex.get("singLEFT")].offsetsPlayer = offsets[1];
		if (animation.getByName('singRIGHTmiss') != null)
		{
			offsets = [Reflect.copy(animationsArray[animIndex.get("singLEFTmiss")]).offsetsPlayer,
						Reflect.copy(animationsArray[animIndex.get("singRIGHTmiss")]).offsetsPlayer];
			animationsArray[animIndex.get("singRIGHTmiss")].offsetsPlayer = offsets[0];
			animationsArray[animIndex.get("singLEFTmiss")].offsetsPlayer = offsets[1];
		}
	}
}