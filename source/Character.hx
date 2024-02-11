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
				tex = Paths.getSparrowAtlas('characters/gfChristmas',"shared");
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
				tex = Paths.getSparrowAtlas('characters/gfCar',"shared");
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/gfPixel',"shared");
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
				tex = Paths.getSparrowAtlas('characters/spooky_kids_assets',"shared");
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
				tex = Paths.getSparrowAtlas('characters/Mom_Assets',"shared");
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
				tex = Paths.getSparrowAtlas('characters/momCar',"shared");
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
				tex = Paths.getSparrowAtlas('characters/Monster_Assets',"shared");
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
				tex = Paths.getSparrowAtlas('characters/monsterChristmas',"shared");
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
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss',"shared");
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
				animation.addByPrefix('singHit', 'BF hit', 24, false);

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
				var tex = Paths.getSparrowAtlas('characters/bfChristmas',"shared");
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
				var tex = Paths.getSparrowAtlas('characters/bfCar',"shared");
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
				frames = Paths.getSparrowAtlas('characters/bfPixel',"shared");
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
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD',"shared");
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
				frames = Paths.getSparrowAtlas('characters/senpai',"shared");
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
				frames = Paths.getSparrowAtlas('characters/senpai',"shared");
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
				frames = Paths.getPackerAtlas('characters/spirit',"shared");
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
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets',"shared");
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
				animation.addByPrefix('hey', 'Keen Hey instancia 1', 24, false);
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
			case 'beat':
				var tex = Paths.getSparrowAtlas('characters/Beat_Assets','shared');
				frames = tex;
				animation.addByPrefix('idle', "Beat instancia", 24, true);
				animation.addByPrefix('singUP', "BeatUp", 24, false);
				animation.addByPrefix('singDOWN', "BeatDown", 24, false);
				animation.addByPrefix('singLEFT', 'BeatLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'BeatRight', 24, false);
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

				/*if(isPlayer){
					addOffset('idle', -10, 127);
					addOffset("singUP", -120, 160);
					addOffset("singRIGHT", -30, 119);
					addOffset("singLEFT", -65, 159);
					addOffset("singDOWN", 0, 170);
				}else{
					addOffset('idle', 200, 150);
					addOffset("singUP", 60, 180);
					addOffset("singRIGHT", 0, 130);
					addOffset("singLEFT", 45, 170);
					addOffset("singDOWN", 0, 170);
				}

				this.y += 30;*/

				playAnim('idle');
			case 'beat-neon':
				var tex = Paths.getSparrowAtlas('characters/Beat_Neon',"shared");
				frames = tex;
				animation.addByPrefix('idle', "Beat instancia", 24, true);
				animation.addByPrefix('singUP', "BeatUp", 24, false);
				animation.addByPrefix('singDOWN', "BeatDown", 24, false);
				animation.addByPrefix('singLEFT', 'BeatLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'BeatRight', 24, false);
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
					animation.addByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
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

				isDancingIdle = true;
			case 'gf-alt':
				tex = Paths.getSparrowAtlas('characters/gf_whitty',"shared");
				frames = tex;
				animation.addByPrefix('cheer', 'GF FEAR', 24, false);
				animation.addByPrefix('singLEFT', 'GF FEAR', 24, false);
				animation.addByPrefix('singRIGHT', 'GF FEAR', 24, false);
				animation.addByPrefix('singUP', 'GF FEAR', 24, false);
				animation.addByPrefix('singDOWN', 'GF FEAR', 24, false);
				//animation.addByPrefix('sad','gf sad',24,false);
				animation.addByIndices('sad', 'gf sad', CoolUtil.numberArray(79, 74), "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 27, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

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
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByPrefix('sad', 'GF Crying at Gunpoint', 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing at Gunpoint', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing at Gunpoint', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('idle', 'GF Dancing at Gunpoint', 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

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
				animation.addByIndices('idle', 'Pico shoot 2', CoolUtil.numberArray(59,41),"",24, false);
				animation.addByIndices('danceLeft', 'Pico shoot 3', CoolUtil.numberArray(62,45),"",24, false);
				animation.addByIndices('danceRight', 'Pico shoot 2', CoolUtil.numberArray(62,45),"",24, false);
				animation.addByPrefix('shoot1', 'Pico shoot 1',  24, false);
				animation.addByPrefix('shoot2', 'Pico shoot 2',  24, false);
				animation.addByPrefix('shoot3', 'Pico shoot 3', 24, false);
				animation.addByPrefix('shoot4', 'Pico shoot 4', 24, false);
				/*animation.addByIndices('shoot1', 'Pico shoot 1', CoolUtil.numberArray(4),"", 24, false);
				animation.addByIndices('shoot2', 'Pico shoot 2', CoolUtil.numberArray(4),"", 24, false);
				animation.addByIndices('shoot3', 'Pico shoot 3', CoolUtil.numberArray(4),"", 24, false);
				animation.addByIndices('shoot4', 'Pico shoot 4', CoolUtil.numberArray(4),"", 24, false);*/

				addOffset('shoot1', 0);
				addOffset('shoot2', -1, -128);
				addOffset('shoot3', 412, -64);
				addOffset('shoot4', 439, -19);

				addOffset('danceLeft', 412, -64);
				addOffset('danceRight', -1, -128);
				addOffset('idle', -1, -128);

				playAnim('danceRight');

				this.y -= 200;
				isDancingIdle = true;
			case 'bf-holding-gf':
				var tex = Paths.getSparrowAtlas('characters/tankmanChars/bfAndGF','shared');
				frames = tex;				
				
				animation.addByPrefix('idle', 'BF idle dance w gf', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT','BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS',24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS',24,false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				
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
					animation.addByPrefix('singRIGHT','BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS',24, false);
					animation.addByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS',24,false);
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
				animation.addByPrefix('idle', 'OJ Idle', 24, true);
				animation.addByPrefix('singUP', 'OJ Up', 24, false);
				animation.addByPrefix('singDOWN', 'OJ Down', 24, false);
				animation.addByPrefix('singUPmiss', 'up fail', 24, false);
				animation.addByPrefix('singDOWNmiss', 'down fail', 24, false);

				if(isPlayer){
					curCharacter = 'bf-OJ';
					animation.addByPrefix('singLEFT', 'OJ right', 24, false);
					animation.addByPrefix('singRIGHT', 'OJ left', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Right fail', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'left fail', 24, false);
					animation.addByPrefix('scared', 'down fail', 24, false);
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
					animation.addByPrefix('singLEFT', 'OJ left', 24, false);
					animation.addByPrefix('singRIGHT', 'OJ right', 24, false);
					animation.addByPrefix('singLEFTmiss', 'left fail', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Right fail', 24, false);
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
				animation.addByPrefix('idle', 'OJ Idle', 24, true);
				animation.addByPrefix('singUP', 'OJ Up', 24, false);
				animation.addByPrefix('singLEFT', 'OJ left', 24, false);
				animation.addByPrefix('singRIGHT', 'OJ right', 24, false);
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
				animation.addByPrefix('idle', 'Whitty Idle', 24, true);
				animation.addByPrefix('singUP', 'Credit Goes to0', 24, false);
				animation.addByPrefix('singDOWN', 'SockClip for Arts and Song0', 24, false);
				animation.addByPrefix('singLEFT', 'KadeDev for Coding0', 24, false);
				animation.addByPrefix('singRIGHT', 'Nate Anim8 for Arts and Chart0', 24, false);
				addOffset('idle',0,-12);
				addOffset("singUP", 19, 39);
				addOffset("singLEFT", -2, -28);
				addOffset("singRIGHT", 11, 26);
				addOffset("singDOWN", -70, -55);

				if(isPlayer){
					/*animation.addByPrefix('singRIGHT', 'KadeDev for Coding0', 24, false);
					animation.addByPrefix('singLEFT', 'Nate Anim8 for Arts and Chart0', 24, false);*/
					animation.addByPrefix('singUPmiss', 'Whitty Sing Up MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Whitty Sing Left MISS', 24, false);
					animation.addByPrefix('singDOWNmiss', 'Whitty Sing Down MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Whitty Sing Right MISS', 24, false);

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
				animation.addByPrefix('idle', 'Dad idle dance', 24, true);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('hey', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

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
				animation.addByPrefix('idle', 'BF idle dance', 24, true);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY!!', 24, false);

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
				animation.addByPrefix('idle', 'BF idle dance', 24, true);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY!!', 24, false);

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
				animation.addByPrefix('idle', 'BF IDLE', 24, true);
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
			case 'bf-tankman-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/tankPixelsDEAD','shared');
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
			case 'impostor':
				tex = Paths.getSparrowAtlas('characters/impostor', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'impostor idle0', 18, true);
				animation.addByPrefix('singUP', 'impostor up0', 24, false);
				//animation.addByPrefix('hey', 'impostor up0', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right0', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down0', 24, false);
				animation.addByPrefix('singLEFT', 'impostor left0', 24, false);
				animation.addByPrefix('shoot', 'impostor shoot 1', 24,false);

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
				animation.addByPrefix('idle', 'Agoti_Idle', 24, true);
				animation.addByPrefix('singUP', 'Agoti_Up', 24, false);
				animation.addByPrefix('hey', 'Agoti_Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Agoti_Right', 24, false);
				animation.addByPrefix('singDOWN', 'Agoti_Down', 24, false);
				animation.addByPrefix('singLEFT', 'Agoti_Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 50,77);
				addOffset("hey", 50,77);
				addOffset("singRIGHT", 60, -46);
				addOffset("singLEFT", 174, 8);
				addOffset("singDOWN",1, -196);

				this.y -= 100;
				playAnim('idle');
			case 'kapi':
				/*var offsetsJson:Array<Dynamic> = cast Json.parse( Assets.getText( Paths.json('offsets') ).trim() ).offsets;
				trace(offsetsJson);*/
				tex = Paths.getSparrowAtlas('characters/Kapi', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24,true);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);
				animation.addByPrefix('hey', 'Dad meow', 24, false);
				animation.addByPrefix('stare', 'Dad stare', 24, false);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);
				addOffset('hey');
				addOffset('stare');

				/*for (ar in offsetsJson){
					addOffset(ar[0],ar[1],ar[2]);
				}*/

				playAnim('idle');
			case 'monika':
				frames = Paths.getSparrowAtlas('characters/monika','shared');
				animation.addByPrefix('idle', 'Monika Idle', 24, true);
				animation.addByPrefix('singUP', 'Monika UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Monika LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Monika RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Monika DOWN NOTE', 24, false);

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
				animation.addByPrefix('idle', 'bob_idle', 24, true);
				animation.addByPrefix('singUP', 'bob_UP', 24, false);
				animation.addByPrefix('singRIGHT', 'bob_RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'bob_DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'bob_LEFT', 24, false);

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
				animation.addByPrefix('idle', 'sky idle', 24, true);
				animation.addByPrefix('singUP', 'sky up', 24, false);
				animation.addByPrefix('singRIGHT', 'sky right', 24, false);
				animation.addByPrefix('singDOWN', 'sky down', 24, false);
				animation.addByPrefix('singLEFT', 'sky left', 24, false);

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
				animation.addByPrefix('idle', 'sky annoyed idle0', 24, true);
				animation.addByPrefix('singUP', 'sky annoyed up0', 24, true);
				animation.addByPrefix('singRIGHT', 'sky annoyed right0', 24, false);
				animation.addByPrefix('singDOWN', 'sky annoyed down0', 24, false);
				animation.addByPrefix('singLEFT', 'sky annoyed left0', 24, false);
				animation.addByPrefix('idle2', 'sky annoyed alt idle0', 24, true);
				animation.addByPrefix('singUP-alt', 'sky annoyed alt up0', 24, false);
				animation.addByPrefix('singCenter', 'sky annoyed alt up0', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'sky annoyed alt right0', 24, false);
				animation.addByPrefix('singDOWN-alt', 'sky annoyed alt down0', 24, false);
				animation.addByPrefix('singLEFT-alt', 'sky annoyed alt left0', 24, false);
				animation.addByPrefix('sing-ugh', 'sky annoyed ugh0', 24, false);
				animation.addByPrefix('sing-oh', 'sky annoyed oh0', 24, false);
				animation.addByPrefix('sing-grr', 'sky annoyed grr0', 24, false);
				animation.addByPrefix('sing-huh', 'sky annoyed huh0', 24, false);

				if(isPlayer){
					animation.addByPrefix('singLEFT-alt', 'sky annoyed alt right0', 24, false);
					animation.addByPrefix('singRIGHT-alt', 'sky annoyed alt left0', 24, false);
					animation.addByPrefix('singUPmiss', 'sky annoyed alt up0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'sky annoyed alt right0', 24, false);
					animation.addByPrefix('singDOWNmiss', 'sky annoyed alt down0', 24, false);
					animation.addByPrefix('singLEFTmiss', 'sky annoyed alt left0', 24, false);
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
				animation.addByPrefix('idle', 'sky mad idle0', 24, true);
				animation.addByPrefix('singUP', 'sky mad up0', 24, false);
				animation.addByPrefix('singRIGHT', 'sky mad right0', 24, false);
				animation.addByPrefix('singDOWN', 'sky mad down0', 24, false);
				animation.addByPrefix('singLEFT', 'sky mad left0', 24, false);
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
				animation.addByPrefix('idle', "Pico Idle Dance", 24, true);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
					// Need to be flipped! REDO THIS LATER!
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				/*animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);*/

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
				/*addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);*/

				playAnim('idle');

				flipX = true;
			case 'tabi':
				tex = Paths.getSparrowAtlas('characters/TABI', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, true);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

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
                animation.addByPrefix('idle', 'garcello idle dance', 24,true);
                animation.addByPrefix('singUP', 'garcello Sing Note UP', 24, false);
                animation.addByPrefix('singRIGHT', 'garcello Sing Note RIGHT', 24, false);
                animation.addByPrefix('singDOWN', 'garcello Sing Note DOWN', 24, false);
                animation.addByPrefix('singLEFT', 'garcello Sing Note LEFT', 24, false);

				addOffset("idle", -40, -2);
				addOffset("singUP", -48, -5);
				addOffset("singRIGHT", -40, -4);
				addOffset("singLEFT", -32, -3);
				addOffset("singDOWN", -44, -5);

				playAnim('idle');
			case 'bluskys':
				tex = Paths.getSparrowAtlas('characters/Bluskys', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Bluskys idle dance', 24,true);
				animation.addByPrefix('singUP', 'Bluskys Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Bluskys Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Bluskys Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Bluskys Sing Note LEFT', 24, false);
				animation.addByPrefix('hey', 'Bluskys Letsgo', 24, false);

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
				animation.addByPrefix('idle', 'Idle0', 24,true);
				animation.addByPrefix('singUP', 'Sing Up0', 24, false);
				animation.addByPrefix('singRIGHT', 'Sing Right0', 24, false);
				animation.addByPrefix('singDOWN', 'Sing Down0', 24, false);
				animation.addByPrefix('singLEFT', 'Sing Left0', 24, false);

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
				animation.addByPrefix('idle', 'BLACK IDLE0', 24,true);
				animation.addByPrefix('singUP', 'BLACK UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'BLACK RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BLACK DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'BLACK LEFT0', 24, false);
				animation.addByPrefix('hey', 'BLACK DEATH0', 24, false);

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
				animation.addByPrefix('idle', 'SONICFUNIDLE0', 24,true);
				animation.addByPrefix('singUP', 'SONICFUNUP0', 24, false);
				animation.addByPrefix('singRIGHT', 'SONICFUNRIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'SONICFUNDOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'SONICFUNLEFT0', 24, false);

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
				animation.addByPrefix('idle', 'SelIdle0', 24, false);
				animation.addByPrefix('singUP', 'SelUp0', 24, false);
				animation.addByPrefix('singLEFT', 'SelLeft0', 24, false);
				animation.addByPrefix('singRIGHT', 'SelRight0', 24, false);
				animation.addByPrefix('singDOWN', 'SelDown0', 24, false);
				animation.addByPrefix('hey', 'SelHey0', 24, false);

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
				animation.addByPrefix('idle', 'Dad idle dance', 24,true);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24,false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24,false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24,false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24,false);
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
				animation.addByPrefix('idle', 'LuciferSarvIdle0', 24, true);
				animation.addByPrefix('singUP', 'LuciferSarvUp0', 24, false);
				animation.addByPrefix('singDOWN', 'LuciferSarvDown0', 24, false);
				animation.addByPrefix('singLEFT', 'LuciferSarvLeft0', 24, false);
				animation.addByPrefix('singRIGHT', 'LuciferSarvRight0', 24, false);

				if(isPlayer){
					addOffset("idle", 0, 0);
					addOffset("singUP", 0, 50);
					addOffset("singRIGHT", 70, 70);
					addOffset("singLEFT", 80, 80);
					addOffset("singDOWN", 0, -140);
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
				animation.addByPrefix('idle', 'Idle0', 24,true);
				animation.addByPrefix('singUP', 'Sing Up0', 24, false);
				animation.addByPrefix('singDOWN', 'Sing Down0', 24, false);
				animation.addByPrefix('singLEFT', 'Sing Left0', 24, false);
				animation.addByPrefix('singRIGHT', 'Sing Right0', 24, false);
				animation.addByPrefix('ugh', 'Ugh0', 24, false);

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
				animation.addByPrefix('idle', 'Idke0', 24,true);
				animation.addByPrefix('singUP', 'Up0', 24, false);
				animation.addByPrefix('singDOWN', 'Down0', 24, false);
				animation.addByPrefix('singLEFT', 'Left0', 24, false);
				animation.addByPrefix('singRIGHT', 'Right0', 24, false);

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
				animation.addByPrefix('idle', 'Retro IDLE0', 30,true);
				animation.addByPrefix('singUP', 'Retro UP0', 30, false);
				animation.addByPrefix('singDOWN', 'Retro DOWN0', 30, false);
				animation.addByPrefix('singLEFT', 'Retro LEFT0', 30, false);
				animation.addByPrefix('singRIGHT', 'Retro RIGHT0', 30, false);
				animation.addByPrefix('ugh', 'Ugh0', 24, false);

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
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					addOffset("singUP", 11, 21);
					addOffset("singLEFT", -44, -3);
					addOffset("singRIGHT", 65, -12);
					addOffset("singDOWN", 80, -83);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
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
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

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
				animation.addByPrefix('idle', "gf Idle Dance", 24, true);
				animation.addByPrefix('singUP', 'gf Up note0', 24, false);
                animation.addByPrefix('singDOWN', 'gf Down Note0', 24, false);
                animation.addByPrefix('singRIGHT', 'gf Note Right0', 24, false);
                animation.addByPrefix('singLEFT', 'gf NOTE LEFT0', 24, false);

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
				animation.addByPrefix('idle', 'idle0', 24,true);
				animation.addByPrefix('singUP', 'up0', 24, false);
                animation.addByPrefix('singDOWN', 'down0', 24, false);
                animation.addByPrefix('singRIGHT', 'right0', 24, false);
                animation.addByPrefix('singLEFT', 'left0', 24, false);
				animation.addByPrefix('singSwingUP', 'up0', 24, false);
                animation.addByPrefix('singSwingDOWN', 'down0', 24, false);
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
				animation.addByPrefix('idle', 'MyraIdle0', 8,true);
				animation.addByPrefix('singUP', 'MyraUp0', 24, false);
                animation.addByPrefix('singDOWN', 'MyraDown0', 24, false);
                animation.addByPrefix('singRIGHT', 'MyraRight00', 24, false);
                animation.addByPrefix('singLEFT', 'MyraLeft0', 24, false);
				animation.addByPrefix('singUP-alt', 'MyraAAA0', 24, false);
				animation.addByPrefix('singLaugh', 'MyraLaugh0', 6, true);
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
				animation.addByPrefix('idle', 'Dad idle dance0', 24,true);
				animation.addByPrefix('singUP', 'Dad Sing Note UP0', 24, false);
                animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN0', 24, false);
                animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT0', 24, false);
                animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT0', 24, false);
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
				animation.addByPrefix('idle', 'Void Idle0', 24,true);
				animation.addByPrefix('singUP', 'Void Up Note Chill', 24, false);
                animation.addByPrefix('singDOWN', 'Void Down Note Chill0', 24, false);
                animation.addByPrefix('singRIGHT', 'Void Right Note Chill0', 24, false);
                animation.addByPrefix('singLEFT', 'Void Left Note Chill0', 24, false);
				animation.addByPrefix('singUP-alt', 'Void Up Note Hype', 24, false);
				animation.addByPrefix('singCenter', 'Void Up Note Hype', 24, false);
                animation.addByPrefix('singDOWN-alt', 'Void Down Note Hype0', 24, false);
                animation.addByPrefix('singRIGHT-alt', 'Void Right Note Hype0', 24, false);
                animation.addByPrefix('singLEFT-alt', 'Void Left Note Hype0', 24, false);
				animation.addByPrefix('hey', 'Void Wink0', 24, false);
                animation.addByPrefix('seethe', 'Void Seethe0', 24, false);
                animation.addByPrefix('sickintro', 'Void Intro0', 24, false);
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
				animation.addByPrefix('idle', 'cassettegirl idle0', 24,true);
				animation.addByPrefix('singUP', 'cassettegirl up0', 24, false);
                animation.addByPrefix('singDOWN', 'cassettegirl down0', 24, false);
                animation.addByPrefix('singRIGHT', 'cassettegirl right0', 24, false);
                animation.addByPrefix('singLEFT', 'cassettegirl left0', 24, false);
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
				animation.addByPrefix('idle', 'sunday idle0', 24,true);
				animation.addByPrefix('singUP', 'sunday up0', 24, false);
                animation.addByPrefix('singDOWN', 'sunday down0', 24, false);
                animation.addByPrefix('singRIGHT', 'sunday right0', 24, false);
                animation.addByPrefix('singLEFT', 'sunday left0', 24, false);
				animation.addByPrefix('hey', 'sunday left0', 24, false);
				antialiasing = true;

				if(isPlayer){
					animation.addByPrefix('singUP', 'sunday alt up0', 24, false);
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
				animation.addByPrefix('idle', 'Hank Idle0', 24,true);
				animation.addByPrefix('getReady', 'HankGetReady0', 24,true);
				animation.addByPrefix('hey', 'hanktaunt0', 24,false);
				animation.addByPrefix('singScream', 'Hank screamright0', 24, false);
				animation.addByPrefix('singUP', 'Hank Up note0', 24, false);
                animation.addByPrefix('singDOWN', 'Hank Down Note0', 24, false);
                animation.addByPrefix('singRIGHT', 'Hank right note0', 24, false);
                animation.addByPrefix('singLEFT', 'Hank Left Note0', 24, false);
				animation.addByPrefix('singUP-alt', 'Hank Up shoot0', 24, false);
                animation.addByPrefix('singDOWN-alt', 'Hank Down Shoot0', 24, false);
                animation.addByPrefix('singRIGHT-alt', 'Hank right shoot0', 24, false);
                animation.addByPrefix('singLEFT-alt', 'Hank Left Shoot0', 24, false);
				antialiasing = true;

				if(isPlayer){
					animation.addByPrefix('singLEFT-alt', 'Hank right shoot0', 24, false);
					animation.addByPrefix('singRIGHT-alt', 'Hank Left Shoot0', 24, false);
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
				animation.addByPrefix('idle', 'Idle0', 24,true);
				animation.addByPrefix('singUP', 'Sing Up0', 24, false);
                animation.addByPrefix('singDOWN', 'Sing Down0', 24, false);
                animation.addByPrefix('singRIGHT', 'Sing Right0', 24, false);
                animation.addByPrefix('singLEFT', 'Sing Left0', 24, false);
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
				animation.addByPrefix('idle', "CASS IDLE0", 24);
				animation.addByPrefix('singUP', 'CASS UP NOTE0', 24, false);
				animation.addByPrefix('singDOWN', 'CASS DOWN NOTE0', 24, false);
				animation.addByPrefix('singRIGHT', 'CASS LEFT NOTE0', 24, false);
				animation.addByPrefix('singLEFT', 'CASS RIGHT NOTE0', 24, false);
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
				animation.addByPrefix('firstDeath', 'BF dies0', 24, false);
				animation.addByPrefix('deathLoop','BF Dead Loop0', 24, true);
				animation.addByPrefix('deathConfirm', 'BF Dead confirm0', 24, false);

				addOffset("firstDeath", 60, -29);
				addOffset("deathLoop", 8, -33);
				addOffset("deathConfirm", 6, 23);

				this.y -= 100;

				this.flipX = true;

				playAnim("deathLoop");

			case 'mami':
                tex = Paths.getSparrowAtlas('characters/Mami','shared');
                frames = tex;
                animation.addByPrefix('idle', 'IDLE', 24,true);
                animation.addByPrefix('singUP', 'UP', 24,false);
                animation.addByPrefix('singRIGHT', 'RIGHT', 24,false);
                animation.addByPrefix('singDOWN', 'DOWN', 24,false);
                animation.addByPrefix('singLEFT', 'LEFT', 24,false);

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
                animation.addByPrefix('idle', 'garcellotired idle dance', 24,true);
                animation.addByPrefix('singUP', 'garcellotired Sing Note UP', 24,false);
                animation.addByPrefix('singRIGHT', 'garcellotired Sing Note RIGHT', 24,false);
                animation.addByPrefix('singDOWN', 'garcellotired Sing Note DOWN', 24,false);
                animation.addByPrefix('singLEFT', 'garcellotired Sing Note LEFT', 24,false);
                animation.addByPrefix('cough', 'garcellotired cough', 24,false);
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
                animation.addByPrefix('idle', 'Pico Idle Dance', 24,true);
                animation.addByPrefix('singUP', 'pico Up note', 24,false);
                animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT', 24,false);
                animation.addByPrefix('singDOWN', 'Pico Down Note', 24,false);
                animation.addByPrefix('singLEFT', 'Pico Note Right', 24,false);
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
				animation.addByPrefix('idle', 'Pico Idle Dance0', 24,true);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
                animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
                animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
                animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
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
						if(anim.indices != null && anim.indices.length > 0){
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
							addOffset('idle', animOffsets['danceLeft'][0], animOffsets['danceLeft'][1]);
						}
					}
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
		
		if(!debugMode){
		if(curCharacter.toLowerCase().startsWith('gf') || curCharacter == "speakers"){
			if(animation.getByName('hey') == null && animation.getByName('cheer') != null){
				animation.add("hey",animation.getByName('cheer').frames,24,false);
				if(animOffsets['hey'] != null){
					addOffset('hey', animOffsets['cheer'][0], animOffsets['cheer'][1]);
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
		}//fin del if debugMode
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
	}

	public function setSynchronous(synchronize:Bool){
		this.sync = synchronize;
	}

	public function isSynchronous():Bool{
		return this.sync;
	}
}
