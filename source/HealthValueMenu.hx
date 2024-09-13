package;

import flixel.input.gamepad.FlxGamepad;
import openfl.Lib;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Json;
import lime.utils.Assets;

import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import ui.FlxUIDropDownMenuCustom;
import flixel.addons.ui.FlxUIInputText;
import ui.FlxCustomStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;

using StringTools;

class HealthValueMenu extends FlxSubState
{
    private var UI_box:FlxUITabMenu;
    private var blackBox:FlxSprite;
    private var stepperMap:Map<String,Map<String,FlxCustomStepper>>;
	override function create()
	{	
        var tabs = [
			{name: "Easy", label: 'Easy'},
			{name: "Normal", label: 'Normal'},
			{name: "Hard", label: 'Hard'}
		];
        stepperMap = [
            "Easy" => new Map<String,FlxCustomStepper>(),
            "Normal" => new Map<String,FlxCustomStepper>(),
            "Hard" => new Map<String,FlxCustomStepper>()
        ];

        FlxG.mouse.visible = true;

        blackBox = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
        add(blackBox);

        UI_box = new FlxUITabMenu(null, tabs, true);
        UI_box.resize(1000, 1100);
		UI_box.x = 140;
		UI_box.y = 20;

        var datos = cast Json.parse( Assets.getText( Paths.json('offsets') ).trim() );
        var posiciones = datos.menuPos;

        for (i in 0...3){
            var texto:String = "Normal";
            switch(i){
                case 0: texto = "Easy";
                case 1: texto = "Hard";
            }
            var tab_group = new FlxUI(null, UI_box);
            tab_group.name = texto;

            var normalNoteLabel:FlxText = new FlxText(210,15,-1,'Normal notes',16);
            var label0:FlxText = new FlxText(370,40,-1, "Shit      Bad    Good    Sick   Miss Miss(LN) LongNote",16);
            var normalNote:FlxSprite = new FlxSprite();
            normalNote.frames = Paths.getSparrowAtlas('NOTE_assets',"shared");
            normalNote.animation.addByPrefix('greenScroll', 'green0');
            normalNote.animation.play("greenScroll");
            normalNote.setGraphicSize(Std.int(normalNote.width * 0.4));
            normalNote.updateHitbox();
            normalNote.x = 240;
            normalNote.y = 45;
            for(j in 0...7){
                var texto2:String = "sick";
                switch(j){
                    case 0: texto2 = "shit";
                    case 1: texto2 = "bad";
                    case 2: texto2 = "good";
                    case 3: texto2 = "sick";
                    case 4: texto2 = "miss";
                    case 5: texto2 = "missLN";
                    case 6: texto2 = "longN";
                }
                var stepper:FlxCustomStepper;
                stepper = new FlxCustomStepper(365 + j * 67,65, 0.01, FlxG.save.data.healthValues.get("0").get(texto).get(texto2), -2, 2, 2, 30);
                stepperMap.get(texto).set(texto2 + "0", stepper);
                tab_group.add(stepper);
            }
            
            var trickyNoteLabel:FlxText = new FlxText(210,110,-1,'Tricky notes',16);
            var label1:FlxText = new FlxText(370, 140,-1, "Shit      Bad    Good    Sick   Miss Miss(LN) LongNote",16);
            var trickyNote:FlxSprite = new FlxSprite();
            trickyNote.frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_fire',"shared");
            trickyNote.animation.addByPrefix('greenScroll', 'green fire0');
            trickyNote.animation.play("greenScroll");
            trickyNote.setGraphicSize(Std.int(trickyNote.width * 0.3));
            trickyNote.updateHitbox();
            trickyNote.x = 230;
            trickyNote.y = 120;
            for(j in 0...7){
                var texto2:String = "sick";
                switch(j){
                    case 0: texto2 = "shit";
                    case 1: texto2 = "bad";
                    case 2: texto2 = "good";
                    case 3: texto2 = "sick";
                    case 4: texto2 = "miss";
                    case 5: texto2 = "missLN";
                    case 6: texto2 = "longN";
                }
                var stepper:FlxCustomStepper;
                stepper = new FlxCustomStepper(365 + j * 67,165, 0.01, FlxG.save.data.healthValues.get("1").get(texto).get(texto2), -2, 2, 2, 30);
                stepperMap.get(texto).set(texto2 + "1", stepper);
                tab_group.add(stepper);
            }

            var blackNoteLabel:FlxText = new FlxText(200, 230,-1,'Damage notes',16);
            var label2:FlxText = new FlxText(370, 260,-1, "Shit      Bad    Good    Sick   Miss Miss(LN) LongNote",16);
            var blackNote:FlxSprite = new FlxSprite();
            blackNote.frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_types',"shared");
            blackNote.animation.addByPrefix('greenScroll', 'halo green0');
            blackNote.animation.play("greenScroll");
            blackNote.setGraphicSize(Std.int(blackNote.width * 1.3));
            blackNote.updateHitbox();
            blackNote.x = 240;
            blackNote.y = 260;
            for(j in 0...7){
                var texto2:String = "sick";
                switch(j){
                    case 0: texto2 = "shit";
                    case 1: texto2 = "bad";
                    case 2: texto2 = "good";
                    case 3: texto2 = "sick";
                    case 4: texto2 = "miss";
                    case 5: texto2 = "missLN";
                    case 6: texto2 = "longN";
                }
                var stepper:FlxCustomStepper;
                stepper = new FlxCustomStepper(365 + j * 67,285, 0.01, FlxG.save.data.healthValues.get("2").get(texto).get(texto2), -2, 2, 2, 30);
                stepperMap.get(texto).set(texto2 + "2", stepper);
                tab_group.add(stepper);
            }

            var hurtNoteLabel:FlxText = new FlxText(220, 330,-1,'Hurt notes',16);
            var label3:FlxText = new FlxText(370, 360,-1, "Shit      Bad    Good    Sick   Miss Miss(LN) LongNote",16);
            var hurtNote:FlxSprite = new FlxSprite();
            hurtNote.frames = Paths.getSparrowAtlas('noteassets/notetypes/HURTNote',"shared");
            hurtNote.animation.addByPrefix('greenScroll', 'green0');
            hurtNote.animation.play("greenScroll");
            hurtNote.setGraphicSize(Std.int(hurtNote.width * 1.3));
            hurtNote.updateHitbox();
            hurtNote.x = 240;
            hurtNote.y = 360;
            for(j in 0...7){
                var texto2:String = "sick";
                switch(j){
                    case 0: texto2 = "shit";
                    case 1: texto2 = "bad";
                    case 2: texto2 = "good";
                    case 3: texto2 = "sick";
                    case 4: texto2 = "miss";
                    case 5: texto2 = "missLN";
                    case 6: texto2 = "longN";
                }
                var stepper:FlxCustomStepper;
                stepper = new FlxCustomStepper(365 + j * 67,385, 0.01, FlxG.save.data.healthValues.get("3").get(texto).get(texto2), -2, 2, 2, 30);
                stepperMap.get(texto).set(texto2 + "3", stepper);
                tab_group.add(stepper);
            }

            var goldNoteLabel:FlxText = new FlxText(215, 430,-1,'Gold notes',16);
            var label4:FlxText = new FlxText(370, 460,-1, "Shit      Bad    Good    Sick   Miss Miss(LN) LongNote",16);
            var goldNote:FlxSprite = new FlxSprite();
            goldNote.frames = Paths.getSparrowAtlas('noteassets/notetypes/GoldNote',"shared");
            goldNote.animation.addByPrefix('greenScroll', 'green0');
            goldNote.animation.play("greenScroll");
            goldNote.setGraphicSize(Std.int(goldNote.width * 0.4));
            goldNote.updateHitbox();
            goldNote.x = 240;
            goldNote.y = 460;
            for(j in 0...7){
                var texto2:String = "sick";
                switch(j){
                    case 0: texto2 = "shit";
                    case 1: texto2 = "bad";
                    case 2: texto2 = "good";
                    case 3: texto2 = "sick";
                    case 4: texto2 = "miss";
                    case 5: texto2 = "missLN";
                    case 6: texto2 = "longN";
                }
                var stepper:FlxCustomStepper;
                stepper = new FlxCustomStepper(365 + j * 67,485, 0.01, FlxG.save.data.healthValues.get("4").get(texto).get(texto2), -2, 2, 2, 30);
                stepperMap.get(texto).set(texto2 + "4", stepper);
                tab_group.add(stepper);
            }

            var warningNoteLabel:FlxText = new FlxText(200, 530,-1,'Warning notes',16);
            var label5:FlxText = new FlxText(370, 560,-1, "Shit      Bad    Good    Sick   Miss Miss(LN) LongNote",16);
            var warningNote:FlxSprite = new FlxSprite();
            warningNote.frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_types',"shared");
            warningNote.animation.addByPrefix('greenScroll', 'warning green0');
            warningNote.animation.play("greenScroll");
            warningNote.setGraphicSize(Std.int(warningNote.width * 1.3));
            warningNote.updateHitbox();
            warningNote.x = 242;
            warningNote.y = 560;
            for(j in 0...7){
                var texto2:String = "sick";
                switch(j){
                    case 0: texto2 = "shit";
                    case 1: texto2 = "bad";
                    case 2: texto2 = "good";
                    case 3: texto2 = "sick";
                    case 4: texto2 = "miss";
                    case 5: texto2 = "missLN";
                    case 6: texto2 = "longN";
                }
                var stepper:FlxCustomStepper;
                stepper = new FlxCustomStepper(365 + j * 67,585, 0.01, FlxG.save.data.healthValues.get("5").get(texto).get(texto2), -2, 2, 2, 30);
                var stepper:FlxCustomStepper = new FlxCustomStepper(365 + j * 67,585, 0.01, FlxG.save.data.healthValues.get("5").get(texto).get(texto2), -2, 2, 2, 30);
                stepperMap.get(texto).set(texto2 + "5", stepper);
                tab_group.add(stepper);
            }

            var whiteNoteLabel:FlxText = new FlxText(220, 630,-1,'Angel notes',16);
            var label6:FlxText = new FlxText(370, 660,-1, "Shit      Bad    Good    Sick   Miss Miss(LN) LongNote",16);
            var whiteNote:FlxSprite = new FlxSprite();
            whiteNote.frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_types',"shared");
            whiteNote.animation.addByPrefix('greenScroll', 'angel green0');
            whiteNote.animation.play("greenScroll");
            whiteNote.setGraphicSize(Std.int(whiteNote.width * 1.3));
            whiteNote.updateHitbox();
            whiteNote.x = 245;
            whiteNote.y = 660;
            for(j in 0...7){
                var texto2:String = "sick";
                switch(j){
                    case 0: texto2 = "shit";
                    case 1: texto2 = "bad";
                    case 2: texto2 = "good";
                    case 3: texto2 = "sick";
                    case 4: texto2 = "miss";
                    case 5: texto2 = "missLN";
                    case 6: texto2 = "longN";
                }
                var stepper:FlxCustomStepper;
                stepper = new FlxCustomStepper(365 + j * 67,685, 0.01, FlxG.save.data.healthValues.get("6").get(texto).get(texto2), -2, 2, 2, 30);
                stepperMap.get(texto).set(texto2 + "6", stepper);
                tab_group.add(stepper);
            }

            var glitchNoteLabel:FlxText = new FlxText(220, 730,-1,'Glitch notes',16);
            var label7:FlxText = new FlxText(370, 760,-1, "Shit      Bad    Good    Sick   Miss Miss(LN) LongNote",16);
            var glitchNote:FlxSprite = new FlxSprite();
            glitchNote.frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_types',"shared");
            glitchNote.animation.addByPrefix('greenScroll', 'glitch green0');
            glitchNote.animation.play("greenScroll");
            glitchNote.setGraphicSize(Std.int(glitchNote.width * 1.3));
            glitchNote.updateHitbox();
            glitchNote.x = 245;
            glitchNote.y = 760;
            for(j in 0...7){
                var texto2:String = "sick";
                switch(j){
                    case 0: texto2 = "shit";
                    case 1: texto2 = "bad";
                    case 2: texto2 = "good";
                    case 3: texto2 = "sick";
                    case 4: texto2 = "miss";
                    case 5: texto2 = "missLN";
                    case 6: texto2 = "longN";
                }
                var stepper:FlxCustomStepper;
                stepper = new FlxCustomStepper(365 + j * 67,785, 0.01, FlxG.save.data.healthValues.get("8").get(texto).get(texto2), -2, 2, 2, 30);
                stepperMap.get(texto).set(texto2 + "8", stepper);
                tab_group.add(stepper);
            }

            var beatNoteLabel:FlxText = new FlxText(220, 830,-1,'Beat notes',16);
            var label8:FlxText = new FlxText(370, 860,-1, "Shit      Bad    Good    Sick    Miss",16);
            var beatNote:FlxSprite = new FlxSprite();
            beatNote.frames = Paths.getSparrowAtlas('noteassets/square_note',"shared");
            beatNote.animation.addByPrefix('greenScroll', 'green0');
            beatNote.animation.play("greenScroll");
            beatNote.setGraphicSize(Std.int(beatNote.width * 0.4));
            beatNote.updateHitbox();
            beatNote.x = 245;
            beatNote.y = 860;
            for(j in 0...5){
                var texto2:String = "sick";
                switch(j){
                    case 0: texto2 = "shit";
                    case 1: texto2 = "bad";
                    case 2: texto2 = "good";
                    case 3: texto2 = "sick";
                    case 4: texto2 = "miss";
                }
                var stepper:FlxCustomStepper;
                stepper = new FlxCustomStepper(365 + j * 67,885, 0.01, FlxG.save.data.healthValues.get("9").get(texto).get(texto2), -2, 2, 2, 30);
                stepperMap.get(texto).set(texto2 + "9", stepper);
                tab_group.add(stepper);
            }
            var hint:FlxText = new FlxText(-220,300,-1,'Scroll using keys or mouse wheel',28);
            hint.angle -= 90;
            tab_group.add(hint);
            var hint2:FlxText = new FlxText(30,300,-1,'Hold shift for more\nincrease/decrease',16);
            hint2.angle -= 90;
            tab_group.add(hint2);

            var misspressLabel = new FlxText(390, 955,-1,'Miss press',16);
            var stepperMiss:FlxCustomStepper = new FlxCustomStepper(515, 961, 0.005, FlxG.save.data.healthValues.get("missPressed").get(texto), -2, 0, 3, 35, 0.1);
            stepperMap.get(texto).set("missPress",stepperMiss);
            tab_group.add(misspressLabel);
            tab_group.add(stepperMiss);

            tab_group.add(label0);
            tab_group.add(normalNoteLabel);
            tab_group.add(normalNote);

            tab_group.add(label1);
            tab_group.add(trickyNoteLabel);
            tab_group.add(trickyNote);

            tab_group.add(label2);
            tab_group.add(blackNoteLabel);
            tab_group.add(blackNote);

            tab_group.add(label3);
            tab_group.add(hurtNoteLabel);
            tab_group.add(hurtNote);

            tab_group.add(label4);
            tab_group.add(goldNoteLabel);
            tab_group.add(goldNote);

            tab_group.add(label5);
            tab_group.add(warningNoteLabel);
            tab_group.add(warningNote);

            tab_group.add(label6);
            tab_group.add(whiteNoteLabel);
            tab_group.add(whiteNote);

            tab_group.add(label7);
            tab_group.add(glitchNoteLabel);
            tab_group.add(glitchNote);

            tab_group.add(label8);
            tab_group.add(beatNoteLabel);
            tab_group.add(beatNote);

            var reloadBtn:FlxButton = new FlxButton(300,1010, "Reset Values", function()
		    {
			    reset();
		    });
            var saveBtn:FlxButton = new FlxButton(600,1010, "Save", function()
		    {
			    save();
		    });
            tab_group.add(reloadBtn);
            tab_group.add(saveBtn);

            UI_box.addGroup(tab_group);
        }
        add(UI_box);

        super.create();
	}

	override function update(elapsed:Float)
	{
        if(FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE){
            quit();
        }
        super.update(elapsed);

        if (FlxG.mouse.wheel > 0){
            UI_box.y += 40;
        }
        if (FlxG.mouse.wheel < 0){
            UI_box.y -= 40;
        }
        if (FlxG.keys.pressed.UP)
			UI_box.y += 10;
		if (FlxG.keys.pressed.DOWN)
			UI_box.y -= 10;
        if(UI_box.y < -420)
            UI_box.y = -420;
        if(UI_box.y > 20)
            UI_box.y = 20;
	}

    function save(){
        var texto:String = UI_box.selected_tab_id;
        var map:Map<String,Dynamic>;
        for(key in stepperMap.keys()){
            map = stepperMap.get(texto);
            for(i in 0...10){
                var j:Int = i;
                if(i == 7)
                    j = 0;
                FlxG.save.data.healthValues.get(""+i).get(texto).set("shit", map.get("shit"+j).value);
                FlxG.save.data.healthValues.get(""+i).get(texto).set("bad", map.get("bad"+j).value);
                FlxG.save.data.healthValues.get(""+i).get(texto).set("good", map.get("good"+j).value);
                FlxG.save.data.healthValues.get(""+i).get(texto).set("sick", map.get("sick"+j).value);
                FlxG.save.data.healthValues.get(""+i).get(texto).set("miss", map.get("miss"+j).value);
                if(i != 9){
                    FlxG.save.data.healthValues.get(""+i).get(texto).set("missLN", map.get("missLN"+j).value);
                    FlxG.save.data.healthValues.get(""+i).get(texto).set("longN", map.get("longN"+j).value);
                }
            }
            FlxG.save.data.healthValues.get("missPressed").set(texto, map.get("missPress").value);
        }
        FlxG.save.flush();
    }

    function reset(){
        KadeEngineData.setHealthValues();
        var map:Map<String,Dynamic> = FlxG.save.data.healthValues;
        var map2:Map<String,Dynamic>;
		var map3:Map<String,Dynamic>;
		for (key in map.keys()){
			if(key != "missPressed"){
				map2 = map.get(key);
				for(key2 in map2.keys()){
					map3 = map2.get(key2);
					if(key2 != "damage" && key2 != "score" && key != "7"){
						for(key3 in map3.keys()){
                            if(stepperMap.get(key2).get(key3+key) != null)
                                stepperMap.get(key2).get(key3+key).value = map3.get(key3);
                        }
					}
				}
			}else{
                map2 = map.get(key);
                for(key2 in map2.keys()){
					stepperMap.get(key2).get("missPress").value = map2.get(key2);
				}
            }
			//healthValues.set(key,map.get(key).copy());
		}
        
        //FlxG.save.data.healthValues = map;
        FlxG.save.flush();
    }

    function quit(){

        /*state = "exiting";

        save();*/

        FlxG.mouse.visible = false;
        OptionsMenu.instance.acceptInput = true;
        close();

        /*FlxTween.tween(UI_box, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(blackBox, {alpha: 0}, 1.1, {ease: FlxEase.expoInOut, onComplete: function(flx:FlxTween){close();}});
        FlxTween.tween(infoText, {alpha: 0}, 1, {ease: FlxEase.expoInOut});*/
    }

}//Fin de la clase