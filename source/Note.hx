package;

import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end
import PlayState;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;
	public var baseStrum:Float = 0;
	
	public var charterSelected:Bool = false;

	public var rStrumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var modifiedByLua:Bool = false;
	public var noteType:Int = 0;
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var noteColor:Int;

	public var burning:Bool = false; //fire
	public var death:Bool = false;    //halo/death
	public var warning:Bool = false; //warning
	public var angel:Bool = false; //angel
	public var alt:Bool = false; //alt animation note
	public var bob:Bool = false; //bob arrow
	public var glitch:Bool = false; //glitch

	public var noteScore:Float = 1;
	public static var mania:Int = 0;
	public var noteYOff:Int = 0;

	public static var noteyOff1:Array<Float> = [4, 0, 0, 0, 0, 0];
	public static var noteyOff2:Array<Float> = [0, 0, 0, 0, 0, 0];
	public static var noteyOff3:Array<Float> = [0, 0, 0, 0, 0, 0];

	public static var swagWidth:Float;
	public static var noteScale:Float;
	public static var newNoteScale:Float = 0;
	public static var prevNoteScale:Float = 0.5;
	public static var pixelnoteScale:Float;
	public static var scaleSwitch:Bool = true;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	public static var tooMuch:Float = 30;
	public var rating:String = "shit";
	public var modAngle:Float = 0; // The angle set by modcharts
	public var localAngle:Float = 0; // The angle to be edited inside Note.hx
	var frameN:Array<String> = ['purple', 'blue', 'green', 'red']; //moved so they can be used in update
	var stepHeight = (0.45 * Conductor.stepCrochet * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? PlayState.SONG.speed : PlayStateChangeables.scrollSpeed, 2));

	public var isParent:Bool = false;
	public var parent:Note = null;
	public var spotInLine:Int = 0;
	public var sustainActive:Bool = true;
	public var noteColors:Array<String> = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'darkred', 'dark'];
//	public var noteColors:Array<String> = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'darkred', 'orange'];
	//var pixelnoteColors:Array<String> = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'];

	public var children:Array<Note> = [];

	private var estilo:String;
	private var useStyle1:Bool;
	private var isTrailNote:Bool = false;
	public var wrongHit:Bool = false;
	public var downscroll:Bool = false;
	private var defaulOffsets:Array<Float> = [];
	private var pixelShit:String = "";
	private var inCharter:Bool = false;
	private var nextStep:Int = 0;
	private var curStep:Int = 0;
	private var stepFlag:Bool = false;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?noteType:Int = 0, ?_mustPress:Bool = false, ?inCharter:Bool = false, ?useStyle1:Bool=true)
	{
		swagWidth = 160 * 0.7; //factor not the same as noteScale
		noteScale = 0.7;
		pixelnoteScale = 1.12;
		mania = 0;
		if (PlayState.SONG.mania == 1)
		{
			swagWidth = 120 * 0.7;
			noteScale = 0.6;
			pixelnoteScale = 0.83;
			mania = 1;
		}
		else if (PlayState.SONG.mania == 2)
		{
			swagWidth = 95 * 0.7;
			noteScale = 0.5;
			pixelnoteScale = 0.7;
			mania = 2;
		}
		else if (PlayState.SONG.mania == 3)
			{
				swagWidth = 130 * 0.7;
				noteScale = 0.65;
				pixelnoteScale = 0.9;
				mania = 3;
			}
		else if (PlayState.SONG.mania == 4)
			{
				swagWidth = 110 * 0.7;
				noteScale = 0.58;
				pixelnoteScale = 0.78;
				mania = 4;
			}
		else if (PlayState.SONG.mania == 5)
			{
				swagWidth = 100 * 0.7;
				noteScale = 0.55;
				pixelnoteScale = 0.74;
				mania = 5;
			}

		else if (PlayState.SONG.mania == 6)
			{
				swagWidth = 200 * 0.7;
				noteScale = 0.7;
				pixelnoteScale = 1;
				mania = 6;
			}
		else if (PlayState.SONG.mania == 7)
			{
				swagWidth = 180 * 0.7;
				noteScale = 0.7;
				pixelnoteScale = 1;
				mania = 7;
			}
		else if (PlayState.SONG.mania == 8)
			{
				swagWidth = 170 * 0.7;
				noteScale = 0.7;
				pixelnoteScale = 1;
				mania = 8;
			}

		if (FlxG.save.data.mania == 1 && PlayStateChangeables.randomNotes)
			{
				swagWidth = 120 * 0.7;
				noteScale = 0.6;
				pixelnoteScale = 0.83;
				mania = 1;
			}
		else if (FlxG.save.data.mania == 2 && PlayStateChangeables.randomNotes)
		{
			swagWidth = 95 * 0.7;
			noteScale = 0.5;
			pixelnoteScale = 0.7;
			mania = 2;
		}
		else if (FlxG.save.data.mania == 3 && PlayStateChangeables.randomNotes)
			{
				swagWidth = 130 * 0.7;
				noteScale = 0.65;
				pixelnoteScale = 0.9;
				mania = 3;
			}
		else if (FlxG.save.data.mania == 4 && PlayStateChangeables.randomNotes)
			{
				swagWidth = 110 * 0.7;
				noteScale = 0.58;
				pixelnoteScale = 0.78;
				mania = 4;
			}
		else if (FlxG.save.data.mania == 5 && PlayStateChangeables.randomNotes)
			{
				swagWidth = 100 * 0.7;
				noteScale = 0.55;
				pixelnoteScale = 0.74;
				mania = 5;
			}

		else if (FlxG.save.data.mania == 6 && PlayStateChangeables.randomNotes)
			{
				swagWidth = 200 * 0.7;
				noteScale = 0.7;
				pixelnoteScale = 1;
				mania = 6;
			}
		else if (FlxG.save.data.mania == 7 && PlayStateChangeables.randomNotes)
			{
				swagWidth = 180 * 0.7;
				noteScale = 0.7;
				pixelnoteScale = 1;
				mania = 7;
			}
		else if (FlxG.save.data.mania == 8 && PlayStateChangeables.randomNotes)
			{
				swagWidth = 170 * 0.7;
				noteScale = 0.7;
				pixelnoteScale = 1;
				mania = 8;
			}
		if (PlayStateChangeables.bothSide)
			{
				swagWidth = 100 * 0.7;
				noteScale = 0.55;
				pixelnoteScale = 0.74;
				mania = 5;
			}
		super();

		if (prevNote == null)
			prevNote = this;
		this.noteType = noteType;
		this.prevNote = prevNote; 
		isSustainNote = sustainNote;

		x += 50;
		if (PlayState.SONG.mania == 2)
			{
				x -= tooMuch;
			}
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		if (Main.editor)
			this.strumTime = strumTime;
		else 
			this.strumTime = Math.round(strumTime);

		if (this.strumTime < 0 )
			this.strumTime = 0;

		this.noteData = noteData % 9;
		burning = noteType == 3;
		death = noteType == 1;
		warning = noteType == 5;
		angel = noteType == 6;
		alt = noteType == 7;
		bob = noteType == 2;
		glitch = noteType == 8;

		if(noteType==9){
			nextStep = Math.ceil(strumTime / Conductor.stepCrochet) - 21;
		}

		this.useStyle1 = useStyle1;

		//if (FlxG.save.data.noteColor != 'darkred' && FlxG.save.data.noteColor != 'black' && FlxG.save.data.noteColor != 'orange')
			//FlxG.save.data.noteColor = 'darkred';

		var daStage:String = PlayState.curStage;

		//defaults if no noteStyle was found in chart
		var noteTypeCheck:String = 'normal';
		this.inCharter = inCharter;
		if(useStyle1){
			if (PlayState.SONG.noteStyle == null) {
				switch(PlayState.storyWeek) {
					case 6: if(!inCharter)
							noteTypeCheck = "pixel";
						else
							pixelShit = 'pixel';
				}
			} else {
				if(PlayState.SONG.noteStyle.startsWith("pixel") && !inCharter)
					pixelShit = PlayState.SONG.noteStyle;
				else
					noteTypeCheck = PlayState.SONG.noteStyle;
			}
			if(PlayState.SONG.noteStyle != pixelShit && pixelShit != "")
				noteTypeCheck = pixelShit;
		}else{
			if (PlayState.SONG.noteStyle2 == null) {
				switch(PlayState.storyWeek) {
					case 6: if(!inCharter)
							noteTypeCheck = "pixel";
						else
							pixelShit = 'pixel';
				}
			} else {
				if(PlayState.SONG.noteStyle2.startsWith("pixel") && !inCharter)
					pixelShit = PlayState.SONG.noteStyle2;
				else
					noteTypeCheck = PlayState.SONG.noteStyle2;
			}
			if(PlayState.SONG.noteStyle2 != pixelShit && pixelShit != "")
				noteTypeCheck = pixelShit;
		}
		this.estilo = noteTypeCheck;

		defaulOffsets[0] = offset.x;
		defaulOffsets[1] = offset.y;

		setGraphic(noteTypeCheck, true);

		if (useStyle1){
			this.downscroll = PlayStateChangeables.useDownscroll;
		}else{
			this.downscroll = PlayStateChangeables.cpuDownscroll;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		angle = modAngle + localAngle;

		if (!modifiedByLua)
		{
			if (!sustainActive && parent != null)
			{
				alpha = parent.alpha * 0.3;
			}
		}

		if (!scaleSwitch)
			{
				if (!isSustainNote && noteType == 0)
					setGraphicSize(Std.int((width / prevNoteScale) * newNoteScale)); //this fixes the note scale
				else if (!isSustainNote && noteType != 0)
				{
					//setGraphicSize(Std.int((width / prevNoteScale) * newNoteScale)); //they smal for some reason
					//updateHitbox();
				}
				
				if (animation.curAnim.name != frameN[noteData] + "Scroll" && animation.curAnim.name.endsWith('Scroll')) //this fixes the note colors when they switch
					animation.play(frameN[noteData] + 'Scroll');
					
				if (animation.curAnim.name != frameN[noteData] + "hold" && animation.curAnim.name.endsWith('hold'))
					animation.play(frameN[noteData] + 'hold');

				if (animation.curAnim.name != frameN[noteData] + "holdend" && animation.curAnim.name.endsWith('holdend'))
					animation.play(frameN[noteData] + 'holdend');

				if (PlayStateChangeables.randomNotes && PlayStateChangeables.randomMania != 0) //this fixes the note datas, i know its a big mess but it works so who cares
				{
					switch(PlayState.maniaToChange)
					{
						case 10: 
							switch (noteColor)
							{
								case 0: 
									noteData = 0;
								case 1: 
									noteData = 1;
								case 2: 
									noteData = 2;
								case 3: 
									noteData = 3;
								case 4: 
									noteData = 2;
								case 5: 
									noteData = 0;
								case 6: 
									noteData = 1;
								case 7:
									noteData = 2;
								case 8:
									noteData = 3;
							}

						case 11: 
							switch (noteColor)
							{
								case 0: 
									noteData = 0;
								case 1: 
									noteData = 1;
								case 2: 
									noteData = 2;
								case 3: 
									noteData = 3;
								case 4: 
									noteData = 2;
								case 5: 
									noteData = 5;
								case 6: 
									noteData = 1;
								case 7:
									noteData = 2;
								case 8:
									noteData = 8;
							}
	
						case 12: 
							switch (noteColor)
							{
								case 0: 
									noteData = 0;
								case 1: 
									noteData = 1;
								case 2: 
									noteData = 2;
								case 3: 
									noteData = 3;
								case 4: 
									noteData = 4;
								case 5: 
									noteData = 5;
								case 6: 
									noteData = 6;
								case 7:
									noteData = 7;
								case 8:
									noteData = 8;
							}
						case 13: 
							switch (noteColor)
							{
								case 0: 
									noteData = 0;
								case 1: 
									noteData = 1;
								case 2: 
									noteData = 2;
								case 3: 
									noteData = 3;
								case 4: 
									noteData = 4;
								case 5: 
									noteData = 0;
								case 6: 
									noteData = 1;
								case 7:
									noteData = 2;
								case 8:
									noteData = 3;
							}
	

						case 14: 
							switch (noteColor)
							{
								case 0: 
									noteData = 0;
								case 1: 
									noteData = 1;
								case 2: 
									noteData = 2;
								case 3: 
									noteData = 3;
								case 4: 
									noteData = 4;
								case 5: 
									noteData = 5;
								case 6: 
									noteData = 1;
								case 7:
									noteData = 2;
								case 8:
									noteData = 8;
							}
	
	
						case 15: 
							switch (noteColor)
							{
								case 0: 
									noteData = 0;
								case 1: 
									noteData = 1;
								case 2: 
									noteData = 2;
								case 3: 
									noteData = 3;
								case 4: 
									noteData = 2;
								case 5: 
									noteData = 5;
								case 6: 
									noteData = 6;
								case 7:
									noteData = 7;
								case 8:
									noteData = 8;
							}
	

						case 16: 
							noteData = 4;
						case 17: 
							switch (noteColor)
							{
								case 0: 
									noteData = 0;
								case 1: 
									noteData = 0;
								case 2: 
									noteData = 3;
								case 3: 
									noteData = 3;
								case 4: 
									noteData = 0;
								case 5: 
									noteData = 0;
								case 6: 
									noteData = 0;
								case 7:
									noteData = 3;
								case 8:
									noteData = 3;
							}
	

						case 18: 
							switch (noteColor)
							{
								case 0: 
									noteData = 0;
								case 1: 
									noteData = 0;
								case 2: 
									noteData = 4;
								case 3: 
									noteData = 3;
								case 4: 
									noteData = 4;
								case 5: 
									noteData = 0;
								case 6: 
									noteData = 0;
								case 7:
									noteData = 4;
								case 8:
									noteData = 3;
							}
	

					}
				}
				//scaleSwitch = true;
			}

		if (mustPress)
		{
			if (isSustainNote){
				if (strumTime - Conductor.songPosition <= ((166 * Conductor.timeScale) * 0.5)
					&& strumTime - Conductor.songPosition >= (-166 * Conductor.timeScale))
					canBeHit = true;
				else
					canBeHit = false;
			}
			else if (burning || death)
			{
				if (strumTime - Conductor.songPosition <= (100 * Conductor.timeScale)
					&& strumTime - Conductor.songPosition >= (-50 * Conductor.timeScale))
					canBeHit = true;
				else
					canBeHit = false;	
			}
			else
			{
				if (strumTime - Conductor.songPosition <= (166 * Conductor.timeScale)
					&& strumTime - Conductor.songPosition >= (-166 * Conductor.timeScale))
					canBeHit = true;
				else
					canBeHit = false;
			}
			if (strumTime - Conductor.songPosition < -166 && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;
	
			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}
	
		if (tooLate && !wasGoodHit)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}

		if(this.useStyle1){
			if(/*noteType == 0 &&*/ PlayState.instance.style[0] != this.estilo){
				setGraphic(PlayState.instance.style[0]);
			}
			if (isSustainNote){
				if(PlayStateChangeables.flip)
					flipY = PlayStateChangeables.cpuDownscroll;
				else
					flipY = PlayStateChangeables.useDownscroll;
			}
			if(!isSustainNote && noteType == 1 && this.downscroll != PlayStateChangeables.useDownscroll){
				this.downscroll = PlayStateChangeables.useDownscroll;
				setGraphic(PlayState.instance.style[0]);
			}
		}else{
			if(/*noteType == 0 &&*/ PlayState.instance.style[1] != this.estilo){
				setGraphic(PlayState.instance.style[1]);
			}
			if (isSustainNote){
				if(!PlayStateChangeables.flip)
					flipY = PlayStateChangeables.cpuDownscroll;
				else
					flipY = PlayStateChangeables.useDownscroll;
			}
			if(!isSustainNote && noteType == 1 && this.downscroll != PlayStateChangeables.cpuDownscroll){
				this.downscroll = PlayStateChangeables.cpuDownscroll;
				setGraphic(PlayState.instance.style[0]);
			}
		}

		if(noteType == 9 && !inCharter){
			var multiplier:Float = 0;
			if(!tooLate && stepFlag){
				if(this.downscroll){
					if(estilo.startsWith("pixel"))
						multiplier = - stepHeight * 1.5;
					else
						multiplier = - stepHeight * 0.5;
				}else{
					if(estilo.startsWith("pixel"))
						multiplier = stepHeight*0.2;
					else
						multiplier = stepHeight*1.1;
				}
				if(this.nextStep > this.curStep)
					modifiedByLua = true;
					offset.y = defaulOffsets[1] + multiplier;
				if(this.nextStep <= this.curStep && modifiedByLua){
					var yPos:Float = 0;
					var xPos:Float = 0;
					var fromP1:Bool = this.useStyle1;
					if(PlayStateChangeables.flip)
						fromP1 = !fromP1;
					if(fromP1 || PlayStateChangeables.bothSide){
						xPos = PlayState.playerStrums.members[Math.floor(Math.abs(this.noteData))].x;
						if(this.downscroll)
							yPos = (PlayState.playerStrums.members[Math.floor(Math.abs(this.noteData))].y + 0.45 * (Conductor.songPosition - this.strumTime)
										* FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? PlayState.SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) - this.noteYOff;
						else
							yPos = (PlayState.playerStrums.members[Math.floor(Math.abs(this.noteData))].y - 0.45 * (Conductor.songPosition - this.strumTime)
										* FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? PlayState.SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) + this.noteYOff;
					}else{
						xPos = PlayState.strumLineNotes.members[Math.floor(Math.abs(this.noteData))].x;
						if(this.downscroll)
							yPos = (PlayState.strumLineNotes.members[Math.floor(Math.abs(this.noteData))].y + 0.45 * (Conductor.songPosition - this.strumTime)
										* FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? PlayState.SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) - this.noteYOff;
						else
							yPos = (PlayState.strumLineNotes.members[Math.floor(Math.abs(this.noteData))].y - 0.45 * (Conductor.songPosition - this.strumTime)
										* FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? PlayState.SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) + this.noteYOff;
					}
					//modifiedByLua = false;
					this.nextStep += 2;
					FlxTween.tween(this,{x:xPos,y:yPos},(Conductor.stepCrochet-10)/1000, 
					{ 
						type:       ONESHOT,
						ease:       FlxEase.quadInOut,
						onComplete: function(flxTween:FlxTween){modifiedByLua = false;}
					});
				}
			}
		}
	}//fin del Update

	function setGraphic(estilo:String,?tailNote:Bool=false):Void{
		 offset.x = defaulOffsets[0];
		 offset.y = defaulOffsets[1];
		switch (estilo)
		{
			case 'pixel':
				loadGraphic(Paths.image('noteassets/pixel/arrows-pixels'), true, 17, 17);
				if (isSustainNote /*&& noteType == 0*/)
					loadGraphic(Paths.image('noteassets/pixel/arrowEnds'), true, 7, 6);

				for (i in 0...9)
				{
					animation.add(noteColors[i] + 'Scroll', [i + 9]); // Normal notes
					animation.add(noteColors[i] + 'hold', [i]); // Holds
					animation.add(noteColors[i] + 'holdend', [i + 9]); // Tails
				}
				switch(noteType){
					case 1:
						if(isSustainNote){
							loadGraphic(Paths.image('noteassets/pixel/firenotes/arrowEnds'), true, 7, 6);
							for (i in 0...9){
								animation.add(noteColors[i] + 'Scroll', [i + 9]); // Normal notes
								animation.add(noteColors[i] + 'hold', [i]); // Holds
								animation.add(noteColors[i] + 'holdend', [i + 9]); // Tails
							}
						}else{
							loadGraphic(Paths.image('noteassets/pixel/NOTE_fire-pixel'),true,21,31);
							if(this.downscroll){
								animation.add('purpleScroll', [0,1,2],12,true);
								animation.add('greenScroll', [3,4,5],12,true);
								animation.add('blueScroll', [6,7,8],12,true);
								animation.add('redScroll', [9,10,11],12,true);
								animation.add('whiteScroll', [3,4,5],12,true);
								animation.add('yellowScroll', [0,1,2],12,true);
								animation.add('darkredScroll', [3,4,5],12,true);
								animation.add('violetScroll', [6,7,8],12,true);
								animation.add('darkScroll', [9,10,11],12,true);
								this.flipY = true;
							}else{
								animation.add('purpleScroll', [0,1,2],12,true);
								animation.add('blueScroll', [3,4,5],12,true);
								animation.add('greenScroll', [6,7,8],12,true);
								animation.add('redScroll', [9,10,11],12,true);
								animation.add('whiteScroll', [3,4,5],12,true);
								animation.add('yellowScroll', [0,1,2],12,true);
								animation.add('violetScroll', [3,4,5],12,true);
								animation.add('darkredScroll', [6,7,8],12,true);
								animation.add('darkScroll', [9,10,11],12,true);
							}
						}
					case 2:
						loadGraphic(Paths.image('noteassets/pixel/bob/arrows-pixels'), true, 17, 17);
						if (isSustainNote)
							loadGraphic(Paths.image('noteassets/pixel/bob/arrowEnds'), true, 7, 6);
						for (i in 0...9)
						{
							animation.add(noteColors[i] + 'Scroll', [i + 9]); // Normal notes
							animation.add(noteColors[i] + 'hold', [i]); // Holds
							animation.add(noteColors[i] + 'holdend', [i + 9]); // Tails
						}
					case 3:
						loadGraphic(Paths.image('noteassets/pixel/halo/arrows-pixels'), true, 17, 17);
						if (isSustainNote)
							loadGraphic(Paths.image('noteassets/pixel/halo/arrowEnds'), true, 7, 6);
						for (i in 0...9)
						{
							animation.add(noteColors[i] + 'Scroll', [i + 9]); // Normal notes
							animation.add(noteColors[i] + 'hold', [i]); // Holds
							animation.add(noteColors[i] + 'holdend', [i + 9]); // Tails
						}
					case 4:
						loadGraphic(Paths.image('noteassets/pixel/gold/NOTE_assets'), true, 17, 17);
						if (isSustainNote)
							loadGraphic(Paths.image('noteassets/pixel/gold/NOTE_assetsENDS'), true, 7, 6);
						for (i in 0...4)
						{
							animation.add(noteColors[i] + 'Scroll', [i + 4]); // Normal notes
							animation.add(noteColors[i] + 'hold', [i]); // Holds
							animation.add(noteColors[i] + 'holdend', [i + 4]); // Tails
							animation.add(noteColors[i+5] + 'Scroll', [i + 4]); // Normal notes
							animation.add(noteColors[i+5] + 'hold', [i]); // Holds
							animation.add(noteColors[i+5] + 'holdend', [i + 4]); // Tails
						}
						animation.add(noteColors[4] + 'Scroll', [5]); // Normal notes
						animation.add(noteColors[4] + 'hold', [1]); // Holds
						animation.add(noteColors[4] + 'holdend', [5]); // Tails
					case 5:
						loadGraphic(Paths.image('noteassets/pixel/warning/arrows-pixels'), true, 17, 17);
						if (isSustainNote)
							loadGraphic(Paths.image('noteassets/pixel/warning/arrowEnds'), true, 7, 6);
						for (i in 0...9)
						{
							animation.add(noteColors[i] + 'Scroll', [i + 9]); // Normal notes
							animation.add(noteColors[i] + 'hold', [i]); // Holds
							animation.add(noteColors[i] + 'holdend', [i + 9]); // Tails
						}
					case 6:
						loadGraphic(Paths.image('noteassets/pixel/angel/arrows-pixels'), true, 17, 17);
						if (isSustainNote)
							loadGraphic(Paths.image('noteassets/pixel/angel/arrowEnds'), true, 7, 6);
						for (i in 0...9)
						{
							animation.add(noteColors[i] + 'Scroll', [i + 9]); // Normal notes
							animation.add(noteColors[i] + 'hold', [i]); // Holds
							animation.add(noteColors[i] + 'holdend', [i + 9]); // Tails
						}
					case 8:
						loadGraphic(Paths.image('noteassets/pixel/glitch/arrows-pixels'), true, 17, 17);
						if (isSustainNote)
							loadGraphic(Paths.image('noteassets/pixel/glitch/arrowEnds'), true, 7, 6);
						for (i in 0...9)
						{
							animation.add(noteColors[i] + 'Scroll', [i + 9]); // Normal notes
							animation.add(noteColors[i] + 'hold', [i]); // Holds
							animation.add(noteColors[i] + 'holdend', [i + 9]); // Tails
						}
					case 9:
						loadGraphic(Paths.image('noteassets/pixel/square'), true, 17, 17);
						if (isSustainNote)
							loadGraphic(Paths.image('noteassets/pixel/arrowEnds'), true, 7, 6);
						for (i in 0...9)
						{
							animation.add(noteColors[i] + 'Scroll', [i+9]); // Normal notes
							animation.add(noteColors[i] + 'hold', [i]); // Holds
							animation.add(noteColors[i] + 'holdend', [i + 9]); // Tails
						}
				}
				/*if (burning)
					{
						loadGraphic(Paths.image('noteassets/pixel/firenotes/arrows-pixels'), true, 17, 17);
						if (isSustainNote && burning)
							loadGraphic(Paths.image('noteassets/pixel/firenotes/arrowEnds'), true, 7, 6);
						for (i in 0...9)
							{
								animation.add(noteColors[i] + 'Scroll', [i + 9]); // Normal notes
								animation.add(noteColors[i] + 'hold', [i]); // Holds
								animation.add(noteColors[i] + 'holdend', [i + 9]); // Tails
							}
					}
				else if (death)
					{
						loadGraphic(Paths.image('noteassets/pixel/halo/arrows-pixels'), true, 17, 17);
						if (isSustainNote && death)
							loadGraphic(Paths.image('noteassets/pixel/halo/arrowEnds'), true, 7, 6);
						for (i in 0...9)
							{
								animation.add(noteColors[i] + 'Scroll', [i + 9]); // Normal notes
								animation.add(noteColors[i] + 'hold', [i]); // Holds
								animation.add(noteColors[i] + 'holdend', [i + 9]); // Tails
							}
					}
				else if (warning)
					{
						loadGraphic(Paths.image('noteassets/pixel/warning/arrows-pixels'), true, 17, 17);
						if (isSustainNote && warning)
							loadGraphic(Paths.image('noteassets/pixel/warning/arrowEnds'), true, 7, 6);
						for (i in 0...9)
							{
								animation.add(noteColors[i] + 'Scroll', [i + 9]); // Normal notes
								animation.add(noteColors[i] + 'hold', [i]); // Holds
								animation.add(noteColors[i] + 'holdend', [i + 9]); // Tails
							}
					}
				else if (angel)
					{
						loadGraphic(Paths.image('noteassets/pixel/angel/arrows-pixels'), true, 17, 17);
						if (isSustainNote && angel)
							loadGraphic(Paths.image('noteassets/pixel/angel/arrowEnds'), true, 7, 6);
						for (i in 0...9)
							{
								animation.add(noteColors[i] + 'Scroll', [i + 9]); // Normal notes
								animation.add(noteColors[i] + 'hold', [i]); // Holds
								animation.add(noteColors[i] + 'holdend', [i + 9]); // Tails
							}
					}
				else if (bob)
					{
						loadGraphic(Paths.image('noteassets/pixel/bob/arrows-pixels'), true, 17, 17);
						if (isSustainNote && bob)
							loadGraphic(Paths.image('noteassets/pixel/bob/arrowEnds'), true, 7, 6);
						for (i in 0...9)
							{
								animation.add(noteColors[i] + 'Scroll', [i + 9]); // Normal notes
								animation.add(noteColors[i] + 'hold', [i]); // Holds
								animation.add(noteColors[i] + 'holdend', [i + 9]); // Tails
							}
					}
				else if (glitch)
					{
						loadGraphic(Paths.image('noteassets/pixel/glitch/arrows-pixels'), true, 17, 17);
						if (isSustainNote && glitch)
							loadGraphic(Paths.image('noteassets/pixel/glitch/arrowEnds'), true, 7, 6);
						for (i in 0...9)
							{
								animation.add(noteColors[i] + 'Scroll', [i + 9]); // Normal notes
								animation.add(noteColors[i] + 'hold', [i]); // Holds
								animation.add(noteColors[i] + 'holdend', [i + 9]); // Tails
							}
					}*/
				antialiasing = false;
				setGraphicSize(Std.int(width * PlayState.daPixelZoom * pixelnoteScale));
				//setGraphicSize(Std.int(width * PlayState.daPixelZoom * noteScale));
				updateHitbox();
				if(noteType == 1 && !isSustainNote){
					if(noteScale == 0.7){
						if(this.downscroll)
							offset.y += 66;
						else
							offset.y += 26;
						offset.x += 10;
					}else{
						if(this.downscroll)
							offset.y += 52;
						else
							offset.y += 20;
						offset.x += 10;
					}
				}
			case 'dance':
				frames = Paths.getSparrowAtlas('keen/Dance_assets');
				var colores = ['purple', 'blue', 'green', 'red', 'E', 'purple', 'blue', 'green', 'red'];
				for (i in 0...9)
					{
						animation.addByPrefix(noteColors[i] + 'Scroll', colores[i] + '0'); // Normal notes
						if(i == 4){
						animation.addByPrefix(noteColors[i] + 'hold', 'green hold piece'); // Hold
						animation.addByPrefix(noteColors[i] + 'holdend', 'green hold end'); // Tails
						}else{
						animation.addByPrefix(noteColors[i] + 'hold', colores[i] + ' hold piece'); // Hold
						animation.addByPrefix(noteColors[i] + 'holdend', colores[i] + ' hold end'); // Tails
						}
					}	
				altNotes();
				setGraphicSize(Std.int(width * noteScale));
				updateHitbox();
				antialiasing = true;
				if(noteType == 1 && !isSustainNote){
					if(noteScale == 0.7){
						if(this.downscroll)
							offset.y += 201;
						else
							offset.y += 51;
						offset.x += 40;
					}else{
						if(this.downscroll)
							offset.y += 291 * noteScale;
						else
							offset.y += 71 * noteScale;
						offset.x += 58 * noteScale;
					}
				}
			case 'stellar':
				frames = Paths.getSparrowAtlas('keen/STELLAR_Note');
				var colores = ['purple', 'blue', 'green', 'red', 'white', 'purple', 'blue', 'green', 'red'];
				for (i in 0...9)
					{
						animation.addByPrefix(noteColors[i] + 'Scroll', colores[i] + '0'); // Normal notes
						animation.addByPrefix(noteColors[i] + 'hold', colores[i] + ' hold piece'); // Hold
						animation.addByPrefix(noteColors[i] + 'holdend', colores[i] + ' hold end'); // Tails
					}	
				altNotes();
				setGraphicSize(Std.int(width * noteScale));
				updateHitbox();
				antialiasing = true;
				if(noteType == 1 && !isSustainNote){
					if(noteScale == 0.7){
						if(this.downscroll)
							offset.y += 201;
						else
							offset.y += 51;
						offset.x += 40;
					}else{
						if(this.downscroll)
							offset.y += 291 * noteScale;
						else
							offset.y += 71 * noteScale;
						offset.x += 58 * noteScale;
					}
				}
			case "black":
				frames = Paths.getSparrowAtlas('noteassets/NOTE_Black');
				var colores = ['purple', 'blue', 'green', 'red', 'white', 'purple', 'blue', 'green', 'red'];
				for (i in 0...9)
					{
						animation.addByPrefix(noteColors[i] + 'Scroll', colores[i] + '0'); // Normal notes
						animation.addByPrefix(noteColors[i] + 'hold', colores[i] + ' hold piece'); // Hold
						animation.addByPrefix(noteColors[i] + 'holdend', colores[i] + ' hold end'); // Tails
					}
				altNotes([2]);
				if(noteType == 2){
					if(isSustainNote){
						frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_types');
						for (i in 0...9)
						{
							animation.addByPrefix(noteColors[i] + 'Scroll', 'fire ' + noteColors[i] + '0'); // Normal notes
							animation.addByPrefix(noteColors[i] + 'hold', 'fire hold piece'); // Hold
							animation.addByPrefix(noteColors[i] + 'holdend', 'fire hold end'); // Tails
						}
					}else{
						frames = Paths.getSparrowAtlas('noteassets/NOTE_assets');
						colores = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'darkred', 'dark'];
						for (i in 0...9)
						{
							animation.addByIndices(noteColors[i] + 'Scroll', colores[i] + ' press', [0], "", 0, false); // Normal notes
						}
					}
				}
				setGraphicSize(Std.int(width * noteScale));
				updateHitbox();
				antialiasing = true;
				if(noteType == 1 && !isSustainNote){
					if(noteScale == 0.7){
						if(this.downscroll)
							offset.y += 201;
						else
							offset.y += 51;
						offset.x += 40;
					}else{
						if(this.downscroll)
							offset.y += 291 * noteScale;
						else
							offset.y += 71 * noteScale;
						offset.x += 58 * noteScale;
					}
				}
			case 'sacred':
				frames = Paths.getSparrowAtlas('noteassets/Holy_Note');
				var colores = ['purple', 'blue', 'green', 'red', 'white', 'purple', 'blue', 'green', 'red'];
				for (i in 0...9)
					{
						animation.addByPrefix(noteColors[i] + 'Scroll', colores[i] + '0'); // Normal note
						animation.addByPrefix(noteColors[i] + 'hold', colores[i] + ' hold piece'); // Hold
						animation.addByPrefix(noteColors[i] + 'holdend', colores[i] + ' hold end'); // Tails
					}	
				altNotes();
				setGraphicSize(Std.int(width * noteScale));
				updateHitbox();
				antialiasing = true;
				if(noteType == 1 && !isSustainNote){
					if(noteScale == 0.7){
						if(this.downscroll)
							offset.y += 201;
						else
							offset.y += 51;
						offset.x += 40;
					}else{
						if(this.downscroll)
							offset.y += 291 * noteScale;
						else
							offset.y += 71 * noteScale;
						offset.x += 58 * noteScale;
					}
				}
			case "cat":
				frames = Paths.getSparrowAtlas('noteassets/NOTE_Cat');
				var colores = ['purple', 'blue', 'green', 'red', 'blue', 'purple', 'blue', 'green', 'red'];
				for (i in 0...9)
					{
						animation.addByPrefix(noteColors[i] + 'Scroll', colores[i] + '0'); // Normal notes
						animation.addByPrefix(noteColors[i] + 'hold', colores[i] + ' hold piece'); // Hold
						animation.addByPrefix(noteColors[i] + 'holdend', colores[i] + ' hold end'); // Tails
					}
				altNotes();
				setGraphicSize(Std.int(width * noteScale));
				updateHitbox();
				antialiasing = true;
				if(noteType == 1 && !isSustainNote){
					if(noteScale == 0.7){
						if(this.downscroll)
							offset.y += 201;
						else
							offset.y += 51;
						offset.x += 40;
					}else{
						if(this.downscroll)
							offset.y += 291 * noteScale;
						else
							offset.y += 71 * noteScale;
						offset.x += 58 * noteScale;
					}
				}
			default:
				frames = Paths.getSparrowAtlas('noteassets/NOTE_assets');
				for (i in 0...9)
					{
						animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
						animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
						animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
					}
				altNotes();
				/*if (burning || death || warning || angel || bob || glitch)
					{
						frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_types');
						switch(noteType)
						{
							case 1: 
								for (i in 0...9)
									{
										animation.addByPrefix(noteColors[i] + 'Scroll', 'fire ' + noteColors[i] + '0'); // Normal notes
										animation.addByPrefix(noteColors[i] + 'hold', 'fire hold piece'); // Hold
										animation.addByPrefix(noteColors[i] + 'holdend', 'fire hold end'); // Tails
									}
							case 2: 
								for (i in 0...9)
									{
										animation.addByPrefix(noteColors[i] + 'Scroll', 'halo ' + noteColors[i] + '0'); // Normal notes
										animation.addByPrefix(noteColors[i] + 'hold', 'halo hold piece'); // Hold
										animation.addByPrefix(noteColors[i] + 'holdend', 'halo hold end'); // Tails
									}
							case 3: 
								for (i in 0...9)
									{
										animation.addByPrefix(noteColors[i] + 'Scroll', 'warning ' + noteColors[i] + '0'); // Normal notes
										animation.addByPrefix(noteColors[i] + 'hold', 'warning hold piece'); // Hold
										animation.addByPrefix(noteColors[i] + 'holdend', 'warning hold end'); // Tails
									}
							case 4: 
								for (i in 0...9)
									{
										animation.addByPrefix(noteColors[i] + 'Scroll', 'angel ' + noteColors[i] + '0'); // Normal notes
										animation.addByPrefix(noteColors[i] + 'hold', 'angel hold piece'); // Hold
										animation.addByPrefix(noteColors[i] + 'holdend', 'angel hold end'); // Tails
									}
							case 6: 
								for (i in 0...9)
									{
										animation.addByPrefix(noteColors[i] + 'Scroll', 'bob ' + noteColors[i] + '0'); // Normal notes
										animation.addByPrefix(noteColors[i] + 'hold', 'bob hold piece'); // Hold
										animation.addByPrefix(noteColors[i] + 'holdend', 'bob hold end'); // Tails
									}
							case 7:
								for (i in 0...9)
									{
										animation.addByPrefix(noteColors[i] + 'Scroll', 'glitch ' + noteColors[i] + '0'); // Normal notes
										animation.addByPrefix(noteColors[i] + 'hold', 'glitch hold piece'); // Hold
										animation.addByPrefix(noteColors[i] + 'holdend', 'glitch hold end'); // Tails
									}
						}
					}*/
				setGraphicSize(Std.int(width * noteScale));
				updateHitbox();
				antialiasing = true;
				if(noteType == 1 && !isSustainNote){
					if(noteScale == 0.7){
						if(this.downscroll)
							offset.y += 201;
						else
							offset.y += 51;
						offset.x += 40;
					}else{
						if(this.downscroll)
							offset.y += 291 * noteScale;
						else
							offset.y += 71 * noteScale;
						offset.x += 58 * noteScale;
					}
				}
				/*if(noteType == 1 && !isSustainNote){
					if(noteScale == 0.7){
						if(this.downscroll)
							offset.y += PlayState.instance.noteOffsets.downscroll.trickyYNormal;
						else
							offset.y += PlayState.instance.noteOffsets.upscroll.trickyYNormal;
						offset.x += PlayState.instance.noteOffsets.trickyXNormal;
					}else{
						if(this.downscroll)
							offset.y += PlayState.instance.noteOffsets.downscroll.trickyYSmall * noteScale;
						else
							offset.y += PlayState.instance.noteOffsets.upscroll.trickyYSmall  * noteScale;
						offset.x += PlayState.instance.noteOffsets.trickyXSmall * noteScale;
					}
				}*/
		}

		switch (mania)
		{
			case 1: 
				frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
			case 2: 
				frameN = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'darkred', 'dark'];
			case 3: 
				frameN = ['purple', 'blue', 'white', 'green', 'red'];
			case 4: 
				frameN = ['purple', 'green', 'red', 'white', 'yellow', 'blue', 'dark'];
			case 5: 
				frameN = ['purple', 'blue', 'green', 'red', 'yellow', 'violet', 'darkred', 'dark'];
			case 6: 
				frameN = ['white'];
			case 7: 
				frameN = ['purple', 'red'];
			case 8: 
				frameN = ['purple', 'white', 'red'];

		}

		if(noteType != 9)
			x += swagWidth * noteData;
		animation.play(frameN[noteData] + 'Scroll');
		noteColor = noteData;
		stepHeight = (0.45 * Conductor.stepCrochet * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? PlayState.SONG.speed : PlayStateChangeables.scrollSpeed, 2));
		// trace(prevNote);

		// we make sure its downscroll and its a SUSTAIN NOTE (aka a trail, not a note)
		// and flip it so it doesn't look weird.
		// THIS DOESN'T FUCKING FLIP THE NOTE, CONTRIBUTERS DON'T JUST COMMENT THIS OUT JESUS
		if (this.downscroll && isSustainNote) 
			flipY = true;




		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			animation.play(frameN[noteData] + 'holdend');

			updateHitbox();

			x -= width / 2;

			if (this.estilo.startsWith('pixel'))
				x += 30;

			if (isTrailNote && !tailNote)
			{

				animation.play(frameN[prevNote.noteData] + 'hold');

				scale.y *= (stepHeight + 1) / height; // + 1 so that there's no odd gaps as the notes scroll
				updateHitbox();

				//noteYOff = Math.round(-offset.y);

				// prevNote.setGraphicSize();
			}

			if (prevNote.isSustainNote && tailNote)
			{

				prevNote.animation.play(frameN[prevNote.noteData] + 'hold');
				prevNote.updateHitbox();

				prevNote.isTrailNote = true;

				prevNote.scale.y *= (stepHeight + 1) / prevNote.height; // + 1 so that there's no odd gaps as the notes scroll
				prevNote.updateHitbox();
				prevNote.noteYOff = Math.round(-prevNote.offset.y);

				// prevNote.setGraphicSize();

				noteYOff = Math.round(-offset.y);

				// prevNote.setGraphicSize();
			}
		}
		this.estilo = estilo;
	}//fin del setGraphic

	private function altNotes(?ignoreTypes:Array<Int>){
		if(ignoreTypes == null){
			ignoreTypes = [0];
		}
		if(!ignoreTypes.contains(1) && noteType == 1){
			if(isSustainNote){
				frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_types');
				for (i in 0...9)
				{
					animation.addByPrefix(noteColors[i] + 'Scroll', 'fire ' + noteColors[i] + '0'); // Normal notes
					animation.addByPrefix(noteColors[i] + 'hold', 'fire hold piece'); // Hold
					animation.addByPrefix(noteColors[i] + 'holdend', 'fire hold end'); // Tails
				}
			}else{
				frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_fire');
				var colores:Array<String> = ['purple', 'blue', 'green', 'red', 'blue', 'purple', 'blue', 'green', 'red'];
				if(this.downscroll){
					colores = ['purple', 'green', 'blue', 'red', 'blue', 'purple', 'green', 'blue', 'red'];
					this.flipY = true;
				}
				for (i in 0...9){
					animation.addByPrefix(noteColors[i] + 'Scroll', colores[i] + ' fire0'); // Normal notes
				}
			}
		}
		if(!ignoreTypes.contains(3) && noteType == 3){
			frames = Paths.getSparrowAtlas('noteassets/notetypes/HURTNote');
			var colores = ['purple', 'blue', 'green', 'red', 'white', 'purple', 'blue', 'green', 'red'];
			for (i in 0...9)
			{
				animation.addByPrefix(noteColors[i] + 'Scroll', colores[i] + '0'); // Normal notes
				animation.addByPrefix(noteColors[i] + 'hold', colores[i] + ' hold piece'); // Hold
				animation.addByPrefix(noteColors[i] + 'holdend', colores[i] + ' hold end'); // Tails
			}
		}
		if(!ignoreTypes.contains(2) && noteType == 2){
			frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_types');
			for (i in 0...9)
			{
				animation.addByPrefix(noteColors[i] + 'Scroll', 'halo ' + noteColors[i] + '0'); // Normal notes
				animation.addByPrefix(noteColors[i] + 'hold', 'halo hold piece'); // Hold
				animation.addByPrefix(noteColors[i] + 'holdend', 'halo hold end'); // Tails
			}
		}
		if(!ignoreTypes.contains(4) && noteType == 4){
			frames = Paths.getSparrowAtlas('noteassets/notetypes/GoldNote');
			var colores = ['purple', 'blue', 'green', 'red', 'white', 'purple', 'blue', 'green', 'red'];
			for (i in 0...9)
			{
				animation.addByPrefix(noteColors[i] + 'Scroll', colores[i] + '0'); // Normal notes
				animation.addByPrefix(noteColors[i] + 'hold', 'purple hold piece'); // Hold
				animation.addByPrefix(noteColors[i] + 'holdend', 'purple end hold'); // Tails
			}
		}
		if(!ignoreTypes.contains(5) && noteType == 5){
			frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_types');
			for (i in 0...9)
			{
				animation.addByPrefix(noteColors[i] + 'Scroll', 'warning ' + noteColors[i] + '0'); // Normal notes
				animation.addByPrefix(noteColors[i] + 'hold', 'warning hold piece'); // Hold
				animation.addByPrefix(noteColors[i] + 'holdend', 'warning hold end'); // Tails
			}
		}
		if(!ignoreTypes.contains(6) && noteType == 6){
			frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_types');
			for (i in 0...9)
			{
				animation.addByPrefix(noteColors[i] + 'Scroll', 'angel ' + noteColors[i] + '0'); // Normal notes
				animation.addByPrefix(noteColors[i] + 'hold', 'angel hold piece'); // Hold
				animation.addByPrefix(noteColors[i] + 'holdend', 'angel hold end'); // Tails
			}
		}
		if(!ignoreTypes.contains(8) && noteType == 8){
			frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_types');
			for (i in 0...9)
			{
				animation.addByPrefix(noteColors[i] + 'Scroll', 'glitch ' + noteColors[i] + '0'); // Normal notes
				animation.addByPrefix(noteColors[i] + 'hold', 'glitch hold piece'); // Hold
				animation.addByPrefix(noteColors[i] + 'holdend', 'glitch hold end'); // Tails
			}
		}
		if(!ignoreTypes.contains(9) && noteType == 9){
			frames = Paths.getSparrowAtlas('noteassets/square_note');
			for (i in 0...9)
			{
				animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
				animation.addByPrefix(noteColors[i] + 'hold', 'glitch hold piece'); // Hold
				animation.addByPrefix(noteColors[i] + 'holdend', 'glitch hold end'); // Tails
			}
		}
	}

	public function updateStep(step:Int):Void{
		this.curStep = step;
		if(!stepFlag){
			stepFlag = true;
		}
	}
}