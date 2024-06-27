import flixel.input.gamepad.FlxGamepad;
import openfl.Lib;
import flixel.FlxG;

class KadeEngineData
{
    public static function initSave()
    {
        if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.antialiasing == null)
			FlxG.save.data.antialiasing = true;

		if (FlxG.save.data.missSounds == null)
			FlxG.save.data.missSounds = true;

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;
			
		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.songPosition == null)
			FlxG.save.data.songPosition = false;

		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = false;

		if (FlxG.save.data.changedHit == null)
		{
			FlxG.save.data.changedHitX = -1;
			FlxG.save.data.changedHitY = -1;
			FlxG.save.data.changedHit = false;
		}

		if (FlxG.save.data.fpsRain == null)
			FlxG.save.data.fpsRain = false;

		if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = 70;

		if (FlxG.save.data.fpsCap > 285 || FlxG.save.data.fpsCap < 60)
			FlxG.save.data.fpsCap = 120; // baby proof so you can't hard lock ur copy of kade engine
		
		if (FlxG.save.data.scrollSpeed == null || FlxG.save.data.scrollSpeed != 1)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.npsDisplay == null)
			FlxG.save.data.npsDisplay = false;

		if (FlxG.save.data.frames == null)
			FlxG.save.data.frames = 10;

		if (FlxG.save.data.accuracyMod == null)
			FlxG.save.data.accuracyMod = 1;

		if (FlxG.save.data.watermark == null)
			FlxG.save.data.watermark = true;

		if (FlxG.save.data.ghost == null)
			FlxG.save.data.ghost = true;

		if (FlxG.save.data.distractions == null)
			FlxG.save.data.distractions = true;

		if (FlxG.save.data.flashing == null)
			FlxG.save.data.flashing = true;

		if (FlxG.save.data.resetButton == null)
			FlxG.save.data.resetButton = false;

		if (FlxG.save.data.InstantRespawn == null)
			FlxG.save.data.InstantRespawn = false;
		
		if (FlxG.save.data.botplay == null)
			FlxG.save.data.botplay = false;

		if (FlxG.save.data.cpuStrums == null)
			FlxG.save.data.cpuStrums = true;

		if (FlxG.save.data.strumline == null)
			FlxG.save.data.strumline = false;
		
		if (FlxG.save.data.customStrumLine == null)
			FlxG.save.data.customStrumLine = 0;

		if (FlxG.save.data.camzoom == null)
			FlxG.save.data.camzoom = true;

		if (FlxG.save.data.scoreScreen == null)
			FlxG.save.data.scoreScreen = true;

		if (FlxG.save.data.inputShow == null)
			FlxG.save.data.inputShow = false;

		if (FlxG.save.data.optimize == null)
			FlxG.save.data.optimize = false;
		
		if (FlxG.save.data.cacheImages == null)
			FlxG.save.data.cacheImages = false;

		if (FlxG.save.data.oldtimings == null)
			FlxG.save.data.oldtimings = false;

		if (FlxG.save.data.gracetmr == null)
			FlxG.save.data.gracetmr = true;

		if (FlxG.save.data.noteSplash == null)
			FlxG.save.data.noteSplash = true;

		if (FlxG.save.data.zoom == null)
			FlxG.save.data.zoom = 1;

		if (FlxG.save.data.noteColor == null)
			FlxG.save.data.noteColor = "darkred";

		if (FlxG.save.data.gthc == null)
			FlxG.save.data.gthc = false;

		if (FlxG.save.data.gthm == null)
			FlxG.save.data.gthm = false;

		if (FlxG.save.data.randomNotes == null)
			FlxG.save.data.randomNotes = false;

		if (FlxG.save.data.randomSection == null)
			FlxG.save.data.randomSection = true;

		if (FlxG.save.data.mania == null)
			FlxG.save.data.mania = -1;

		if (FlxG.save.data.randomMania == null)
			FlxG.save.data.randomMania = 0;

		if (FlxG.save.data.flip == null)
			FlxG.save.data.flip = false;

		if (FlxG.save.data.bothSide == null)
			FlxG.save.data.bothSide = false;

		if (FlxG.save.data.randomNoteTypes == null)
			FlxG.save.data.randomNoteTypes = 0;

		if(FlxG.save.data.saveReplays == null){
			FlxG.save.data.saveReplays = false;
		}

		if(FlxG.save.data.enableCharchange == null)
			FlxG.save.data.enableCharchange = true;

		if(FlxG.save.data.singCam == null){
			FlxG.save.data.singCam = true;
		}
		if(FlxG.save.data.camFactor == null){
			FlxG.save.data.camFactor = 35;
		}
		if(FlxG.save.data.gameVolume == null){
			FlxG.save.data.gameVolume = 1;
		}
		FlxG.sound.volume = FlxG.save.data.gameVolume;
		if(FlxG.save.data.healthValues == null){
			setHealthValues();
		}

		var map:Map<String,Dynamic> = new Map<String,Dynamic>();

		map = FlxG.save.data.healthValues;
		if(map["0"].get("Normal").get("longN") == null || map["0"].get("score").get("LNScore") == null){
			trace("Resetting\nBefore: " + map["0"].get("Normal") + "\n" + map["0"].get("score"));
			setHealthValues();
			trace("After: " + map["0"].get("Normal") + "\n" + map["0"].get("score"));
		}
		
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		
		KeyBinds.gamepad = gamepad != null;

		Conductor.recalculateTimings();
		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();

		Main.watermarks = FlxG.save.data.watermark;

		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
	}

	public static function setHealthValues():Void{
		var map:Map<String,Dynamic> = [
			"0" => new Map<String,Dynamic>(),
			"1" => new Map<String,Dynamic>(),
			"2" => new Map<String,Dynamic>(),
			"3" => new Map<String,Dynamic>(),
			"4" => new Map<String,Dynamic>(),
			"5" => new Map<String,Dynamic>(),
			"6" => new Map<String,Dynamic>(),
			"7" => new Map<String,Dynamic>(),
			"8" => new Map<String,Dynamic>(),
			"missPressed" => ["Hard" => -0.075, "Easy" => -0.025, "Normal" => -0.05]
		];

		map["0"].set("Hard",["shit"=>-0.1,"bad"=>-0.06,"good"=>0,"sick"=>0.04,"miss"=>-0.15,"missLN"=>-0.05,"longN"=>0]);
		map["0"].set("Normal",["shit"=>-0.1,"bad"=>-0.06,"good"=>0.03,"sick"=>0.07,"miss"=>-0.15,"missLN"=>-0.05,"longN"=>0]);
		map["0"].set("Easy",["shit"=>-0.07,"bad"=>-0.03,"good"=>0.03,"sick"=>0.07,"miss"=>-0.1,"missLN"=>-0.03,"longN"=>0]);
		map["0"].set("score",["shitScore"=>-100,"badScore"=>0,"goodScore"=>200,"sickScore"=>350,"missScore"=>-150,"missLNScore"=>-50,"LNScore"=>50]);
		map["0"].set("damage",false);

		map["1"].set("Hard",["shit"=>0,"bad"=>0,"good"=>-2,"sick"=>-2,"miss"=>0,"missLN"=>0,"longN"=>-0.65]);
		map["1"].set("Normal",["shit"=>0,"bad"=>0,"good"=>-1,"sick"=>-1,"miss"=>0,"missLN"=>0,"longN"=>-0.3]);
		map["1"].set("Easy",["shit"=>0,"bad"=>0,"good"=>-0.75,"sick"=>-0.75,"miss"=>0,"missLN"=>0,"longN"=>-0.2]);
		map["1"].set("score",["shitScore"=>0,"badScore"=>0,"goodScore"=>-1000,"sickScore"=>-1000,"missScore"=>0,"missLNScore"=>0,"LNScore"=>-250]);
		map["1"].set("damage",true);

		map["2"].set("Hard",["shit"=>0,"bad"=>0,"good"=>-0.1,"sick"=>-0.1,"miss"=>0,"missLN"=>0,"longN"=>-0.03]);
		map["2"].set("Normal",["shit"=>0,"bad"=>0,"good"=>-0.075,"sick"=>-0.075,"miss"=>0,"missLN"=>0,"longN"=>-0.02]);
		map["2"].set("Easy",["shit"=>0,"bad"=>0,"good"=>-0.05,"sick"=>-0.05,"miss"=>0,"missLN"=>0,"longN"=>-0.01]);
		map["2"].set("score",["shitScore"=>0,"badScore"=>0,"goodScore"=>-300,"sickScore"=>-300,"missScore"=>0,"missLNScore"=>0,"LNScore"=>-75]);
		map["2"].set("damage",true);

		map["3"].set("Hard",["shit"=>0,"bad"=>0,"good"=>-0.2,"sick"=>-0.2,"miss"=>0,"missLN"=>0,"longN"=>-0.06]);
		map["3"].set("Normal",["shit"=>0,"bad"=>0,"good"=>-0.15,"sick"=>-0.15,"miss"=>0,"missLN"=>0,"longN"=>-0.05]);
		map["3"].set("Easy",["shit"=>0,"bad"=>0,"good"=>-0.1,"sick"=>-0.1,"miss"=>0,"missLN"=>0,"longN"=>-0.03]);
		map["3"].set("score",["shitScore"=>0,"badScore"=>0,"goodScore"=>-500,"sickScore"=>-500,"missScore"=>0,"missLNScore"=>0,"LNScore"=>-125]);
		map["3"].set("damage",true);

		map["4"].set("Hard",["shit"=>0.14,"bad"=>0.14,"good"=>0.14,"sick"=>0.14,"miss"=>-0.3,"missLN"=>-0.1,"longN"=>0]);
		map["4"].set("Normal",["shit"=>0.1,"bad"=>0.1,"good"=>0.1,"sick"=>0.1,"miss"=>-0.2,"missLN"=>-0.075,"longN"=>0]);
		map["4"].set("Easy",["shit"=>0.1,"bad"=>0.1,"good"=>0.1,"sick"=>0.1,"miss"=>-0.1,"missLN"=>-0.05,"longN"=>0]);
		map["4"].set("score",["shitScore"=>420,"badScore"=>420,"goodScore"=>420,"sickScore"=>420,"missScore"=>-600,"missLNScore"=>-100,"LNScore"=>105]);
		map["4"].set("damage",false);

		map["5"].set("Hard",["shit"=>-0.1,"bad"=>-0.06,"good"=>0,"sick"=>0.04,"miss"=>-1,"missLN"=>-0.15,"longN"=>0]);
		map["5"].set("Normal",["shit"=>-0.1,"bad"=>-0.06,"good"=>0.03,"sick"=>0.07,"miss"=>-0.75,"missLN"=>-0.15,"longN"=>0]);
		map["5"].set("Easy",["shit"=>-0.07,"bad"=>-0.03,"good"=>0.03,"sick"=>0.07,"miss"=>-0.5,"missLN"=>-0.1,"longN"=>0]);
		map["5"].set("score",["shitScore"=>-100,"badScore"=>0,"goodScore"=>200,"sickScore"=>350,"missScore"=>-1000,"missLNScore"=>-150,"LNScore"=>50]);
		map["5"].set("damage",false);

		map["6"].set("Hard",["shit"=>-0.05,"bad"=>-0.03,"good"=>0.03,"sick"=>0.07,"miss"=>-0.3,"missLN"=>-0.1,"longN"=>0]);
		map["6"].set("Normal",["shit"=>-0.05,"bad"=>-0.03,"good"=>0.07,"sick"=>0.15,"miss"=>-0.3,"missLN"=>-0.07,"longN"=>0]);
		map["6"].set("Easy",["shit"=>-0.03,"bad"=>0,"good"=>0.07,"sick"=>0.15,"miss"=>-0.2,"missLN"=>-0.05,"longN"=>0]);
		map["6"].set("score",["shitScore"=>-50,"badScore"=>100,"goodScore"=>300,"sickScore"=>500,"missScore"=>-300,"missLNScore"=>-75,"LNScore"=>75]);
		map["6"].set("damage",false);

		map["7"].set("Hard",["shit"=>-0.1,"bad"=>-0.06,"good"=>0,"sick"=>0.04,"miss"=>-0.15,"missLN"=>-0.05,"longN"=>0]);
		map["7"].set("Normal",["shit"=>-0.1,"bad"=>-0.06,"good"=>0.03,"sick"=>0.07,"miss"=>-0.15,"missLN"=>-0.05,"longN"=>0]);
		map["7"].set("Easy",["shit"=>-0.07,"bad"=>-0.03,"good"=>0.03,"sick"=>0.07,"miss"=>-0.1,"missLN"=>-0.03,"longN"=>0]);
		map["7"].set("score",["shitScore"=>-100,"badScore"=>0,"goodScore"=>200,"sickScore"=>350,"missScore"=>-150,"missLNScore"=>-50,"LNScore"=>50]);
		map["7"].set("damage",false);

		map["8"].set("Hard",["shit"=>0,"bad"=>0,"good"=>-0.003,"sick"=>-0.003,"miss"=>0,"missLN"=>0,"longN"=>0]);
		map["8"].set("Normal",["shit"=>0,"bad"=>0,"good"=>-0.002,"sick"=>-0.002,"miss"=>0,"missLN"=>0,"longN"=>0]);
		map["8"].set("Easy",["shit"=>0,"bad"=>0,"good"=>-0.001,"sick"=>-0.001,"miss"=>0,"missLN"=>0,"longN"=>0]);
		map["8"].set("score",["shitScore"=>0,"badScore"=>0,"goodScore"=>-300,"sickScore"=>-300,"missScore"=>0,"missLNScore"=>0,"LNScore"=>-300]);
		map["8"].set("damage",true);

		FlxG.save.data.healthValues = map;
	}
}