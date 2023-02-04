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
	public var isCustom:Bool = false;
	public var hasFocus:Bool = true;
	public var colorCode:Array<Int> = [];
	public var isDancingIdle:Bool = false;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false, ?synch:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		isPlayingAsBF = !FlxG.save.data.flip;

		var tex:FlxAtlasFrames;
		antialiasing = FlxG.save.data.antialiasing;
		this.sync = synch;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

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
				tex = Paths.getSparrowAtlas('characters/gfChristmas');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

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
				tex = Paths.getSparrowAtlas('characters/gfCar');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

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
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
			case 'spooky':
				tex = Paths.getSparrowAtlas('characters/spooky_kids_assets');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByPrefix('idle', 'spooky dance idle', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

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
				tex = Paths.getSparrowAtlas('characters/Mom_Assets');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

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
				tex = Paths.getSparrowAtlas('characters/momCar');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

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
				tex = Paths.getSparrowAtlas('characters/Monster_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -30, -40);
				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('characters/monsterChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);
				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					curCharacter = "bf-pico";
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
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
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -68, -7);
					addOffset("singLEFT", 65, 9);
					addOffset("singDOWN", 200, -70);
					addOffset("singUPmiss", -19, 67);
					addOffset("singRIGHTmiss", -60, 41);
					addOffset("singLEFTmiss", 62, 64);
					addOffset("singDOWNmiss", 210, -28);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				addOffset('idle');

				playAnim('idle');

				flipX = true;

			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('singHey', 'BF HEY', 24, false);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

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
					animation.addByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
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
				var tex = Paths.getSparrowAtlas('characters/bfChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('singHey', 'BF HEY', 24, false);

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
					animation.addByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
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
				var tex = Paths.getSparrowAtlas('characters/bfCar');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

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
					animation.addByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
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
				frames = Paths.getSparrowAtlas('characters/bfPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

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
					animation.addByPrefix('singRIGHT', 'BF LEFT NOTE', 24, false);
					animation.addByPrefix('singLEFT', 'BF RIGHT NOTE', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF LEFT MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF RIGHT MISS', 24, false);
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
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
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
				frames = Paths.getSparrowAtlas('characters/senpai');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

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
				frames = Paths.getSparrowAtlas('characters/senpai');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

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
				frames = Paths.getPackerAtlas('characters/spirit');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

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
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

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
				animation.addByPrefix('idle', 'Tankman Idle Dance', 24, true);
				animation.addByPrefix('singUP', 'Tankman UP note', 24, false);
				animation.addByPrefix('singRIGHT','Tankman Note Left', 24, false);
				animation.addByPrefix('singLEFT', 'Tankman Right Note', 24, false);
				if (isPlayer) {
					/*animation.addByPrefix('singLEFT','Tankman Note Left', 24, false);
					animation.addByPrefix('singRIGHT', 'Tankman Right Note', 24, false);*/
					addOffset('singLEFT',-12, -227);
					addOffset('singRIGHT', 90, -214);
				} else {
					addOffset('singRIGHT',-12, -227);
					addOffset('singLEFT', 90, -214);
				}
    
				animation.addByPrefix('singDOWN', 'Tankman DOWN note', 24, false);
				animation.addByPrefix('singUP-alt', 'TANKMAN UGH', 24, false);
				animation.addByPrefix('singDOWN-alt', 'PRETTY GOOD', 24, true);
				animation.addByPrefix('prettygood', 'PRETTY GOOD', 24, false);

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
				animation.addByPrefix('idle', 'Keen instancia 1', 24, true);
				animation.addByPrefix('singUP', 'Keen Up instancia 1', 24, false);
				animation.addByPrefix('singDOWN', 'Keen down instancia 1', 24, false);
				animation.addByPrefix('singLEFT', 'Keen left instancia 1', 24, false);
				animation.addByPrefix('singRIGHT', 'Keen right instancia 1', 24, false);
				addOffset('idle', -5,-230);
				addOffset("singUP", -19, -243);
				addOffset("singRIGHT", -28, -243);
				addOffset("singLEFT", 12, -206);
				addOffset("singDOWN", 10, -280);
				playAnim('idle');
				flipX=true;
			case 'bf-keen':
				var tex = Paths.getSparrowAtlas('characters/Keen_Assets','shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

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
				animation.addByPrefix('idle', "Keen instancia", 24, true);
				animation.addByPrefix('singUP', "Keen Up instancia", 24, false);
				animation.addByPrefix('singDOWN', "Keen down instancia", 24, false);
				animation.addByPrefix('singLEFT', 'Keen left instancia', 24, false);
				animation.addByPrefix('singRIGHT', 'Keen right instancia', 24, false);
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

				/*addOffset('idle', 200, -100);
				addOffset("singUP", 250, -60);
				addOffset("singRIGHT", 229, -63);
				addOffset("singLEFT", 245, -70);
				addOffset("singDOWN", 248, -72);

				if(isPlayer){
					this.x+=220;
					this.y-= 450;
				}*/

				flipX=true;
				playAnim('idle');
			case 'eder-jr':
				tex = Paths.getSparrowAtlas('characters/Eder_Jr', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Eder Jr Eder Jr', 24,true);
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
						if(anim.indices != null && anim.indices.lenght > 0){
							animation.addByIndices(anim.anim, anim.name, anim.indices, "", anim.fps, anim.loop);
						}else{
							animation.addByPrefix(anim.anim, anim.name, anim.fps, anim.loop);
						}
						if(isPlayer && anim.offsetsPlayer != null){
							addOffset(anim.anim, anim.offsetsPlayer[0], anim.offsetsPlayer[1]);
						}else
							addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
					}
					antialiasing = !datos.no_antialiasing;
					if(datos.camera_position != null)
						cameraPosition = datos.camera_position;
					if(isPlayer && datos.playerCameraPosition != null){
						cameraPosition = datos.playerCameraPosition;
					}
					if(datos.scale != 1){
						this.scale.set(datos.scale,datos.scale);
						this.updateHitbox();
					}
					if(datos.healthbar_colors != null){
						this.colorCode = [datos.healthbar_colors[0],datos.healthbar_colors[1],datos.healthbar_colors[2]];
					}
					if(datos.playerPosition != null && isPlayer){
						this.x += datos.playerPosition[0];
						this.y += datos.playerPosition[1];
					}else{
						if(datos.position != null){
							this.x += datos.position[0];
							this.y += datos.position[1];
						}
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
					animation.addByPrefix('idle', 'Eder Jr Eder Jr', 24,true);
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

		if(curCharacter.toLowerCase().startsWith('gf') || curCharacter == "speakers"){
			if(animation.getByName('hey') == null && animation.getByName('cheer') != null){
				animation.add("hey",animation.getByName('cheer').frames,24,false);
				if(animOffsets['hey'] != null){
					addOffset('hey', animOffsets['cheer'][0], animOffsets['cheer'][1]);
				}
			}
		}else{
			if(animation.getByName('hey') == null && animation.getByName('singUP') != null){
				animation.add("hey",animation.getByName('singUP').frames,24,false);
				if(animOffsets['singUP'] != null){
					addOffset('hey', animOffsets['singUP'][0], animOffsets['singUP'][1]);
				}
			}
			if(animation.getByName('hey') != null){
				animation.add("singHey",animation.getByName('hey').frames,24,false);
				addOffset('singHey', animOffsets['hey'][0], animOffsets['hey'][1]);
			}
		}

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
				addOffset("singRIGHT", offsetL[0], offsetL[1]);
				addOffset("singLEFT", offsetR[0], offsetR[1]);

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
					var offsetR = animOffsets.get('singRIGHTmiss');
					var offsetL = animOffsets.get('singLEFTmiss');
					addOffset("singRIGHTmiss", offsetL[0], offsetL[1]);
					addOffset("singLEFTmiss", offsetR[0], offsetR[1]);
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!isPlayingAsBF)
		{
			if (/*curCharacter.startsWith('bf') && !*/isPlayer)
				{
					if (animation.curAnim.name.startsWith('sing'))
					{
						holdTimer += elapsed;
					}
		
					var dadVar:Float = 4;
		
					if (curCharacter == 'dad')
						dadVar = 6.1;
					if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
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
		
					var dadVar:Float = 4;
		
					if (curCharacter == 'dad')
						dadVar = 6.1;
					if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
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

		if(flyingOffset > 0){
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
				if(!animation.curAnim.name.startsWith('sing') && !animation.curAnim.name.startsWith('dance') && animation.curAnim.finished){
					dance();
				}
			}
		}else{
			if((!isPlayingAsBF && isPlayer) || (isPlayingAsBF && !isPlayer)){
				if(!animation.curAnim.name.startsWith('sing') && animation.curAnim.name != "idle" && animation.curAnim.finished){
					dance();
				}
			}
		}

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
				if(PlayState.boyfriend.animation.curAnim.name.startsWith('sing') && PlayState.boyfriend.holdTimer < this.holdTimer){
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
				if(PlayState.dad.animation.curAnim.name.startsWith('sing') && PlayState.dad.holdTimer < this.holdTimer){
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
		}

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
			switch (curCharacter)
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

				/*case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');*/
				default:
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
	}

	public function setSynchronous(synchronize:Bool){
		this.sync = synchronize;
	}

	public function isSynchronous():Bool{
		return this.sync;
	}
}
