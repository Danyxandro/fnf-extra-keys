package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import flixel.group.FlxGroup;

using StringTools;

class Stage{
	private var background:FlxGroup = new FlxGroup();
	private var stage:String;
	private var modchartExists:Bool = false;
	private var offsets:Array<Float> = [0.0 ,0.0 ,0.0 ,0.0 ,0.0 ,0.0 ,0.0];
	private var layers:Map<String, flixel.group.FlxGroup.FlxTypedGroup<FlxSprite>> = new Map<String, flixel.group.FlxGroup.FlxTypedGroup<FlxSprite>>();
	private var modchartSprites:Map<String, FlxSprite> = new Map<String, FlxSprite>();
	public var hasLua:Bool = false;

	public function new(stage:String){
		if(stage == null)
			stage = "stage";
		PlayState.curStage = "" + stage;
		this.stage = stage;
		@:privateAccess
		modchartExists = PlayState.instance.executeModchart;
		var luaRoute = "assets/stages/"+stage+"/modchart.lua";
		this.hasLua = FileSystem.exists(luaRoute);
		trace("Song lua: "+modchartExists+" stage lua: "+this.hasLua);
	}

	public function createStage(insertSprites:Bool = true){
		@:privateAccess{
			if(insertSprites)
				PlayState.instance.add(background);
		}
		trace("agregar escenario custom: "+insertSprites);
		switch(this.stage)
		{
			case 'mallEvil':
			{
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG','week5'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					background.add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree','week5'));
					evilTree.antialiasing = FlxG.save.data.antialiasing;
					evilTree.scrollFactor.set(0.2, 0.2);
					background.add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow",'week5'));
						evilSnow.antialiasing = FlxG.save.data.antialiasing;
					background.add(evilSnow);
			}
			case 'annieCave':
			{
				var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('annieCave/evilBG','week5'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				background.add(bg);

				var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('annieCave/evilTree','week5'));
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				background.add(evilTree);

				var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("annieCave/evilSnow",'week5'));
					evilSnow.antialiasing = true;
				background.add(evilSnow);
			}
			case 'stage':
				{
					addDefaultStage();
				}
			case 'none'|'custom':
			{
				
			}
			default:
			{
				var routeJSON:String = "assets/stages/" + stage.toLowerCase() + ".json";
				if(FileSystem.exists(routeJSON)){
					var stageData = cast Json.parse(File.getContent(routeJSON).trim());
					trace(stageData);
					var zoom = 1.05;
					zoom = stageData.zoom;
					PlayState.instance.setDefaultZoom(zoom);
					var sprites:Array<Dynamic> = stageData.sprites;
					for(spr in sprites){
						var bg:FlxSprite = new FlxSprite(spr.x,spr.y);
						var png:String = "assets/stages/"+stage.toLowerCase()+"/"+spr.image+".png";
						if(spr.layerName != null && insertSprites){
							var layer:flixel.group.FlxGroup.FlxTypedGroup<FlxSprite> = new flixel.group.FlxGroup.FlxTypedGroup<FlxSprite>();
							if(spr.zPos != null && insertSprites){
								switch(spr.zPos){
									case 1:
										PlayState.instance.layerBGs[1].add(layer);
									case 2:
										PlayState.instance.layerBGs[2].add(layer);
									case 3:
										PlayState.instance.layerBGs[3].add(layer);
									case 4:
										PlayState.instance.layerBGs[4].add(layer);
									default:
										background.add(layer);
								}
							}else{
								if(insertSprites)
									background.add(layer);
							}
							this.layers.set("" + spr.layerName,layer);
						}else{
							if(FileSystem.exists(png)){
								if(spr.xml != null && sys.FileSystem.exists("assets/stages/"+stage.toLowerCase()+"/"+spr.xml+".xml")){
									bg.frames = FlxAtlasFrames.fromSparrow(openfl.display.BitmapData.fromFile(png), File.getContent("assets/stages/"+stage.toLowerCase()+"/"+spr.xml+".xml"));
									if(spr.animations != null){
										var anims:Array<Dynamic> = spr.animations;
										for(anim in anims){
											bg.animation.addByPrefix(anim[0],anim[1],anim[2],anim[3]);
										}
										if(spr.startAnim != null)
											bg.animation.play(spr.startAnim);
									}
								}else{
									bg.loadGraphic(openfl.display.BitmapData.fromFile(png));
								}
							}
							bg.scrollFactor.set(spr.scrollX,spr.scrollY);
							bg.scale.set(spr.scale,spr.scale);
							bg.updateHitbox();
							if(spr.zPos != null && insertSprites){
								switch(spr.zPos){
									case 1:
										PlayState.instance.layerBGs[1].add(bg);
									case 2:
										PlayState.instance.layerBGs[2].add(bg);
									case 3:
										PlayState.instance.layerBGs[3].add(bg);
									case 4:
										PlayState.instance.layerBGs[4].add(bg);
									default:
										background.add(bg);
								}
							}else{
								if(insertSprites)
									background.add(bg);
							}
							if(spr.antialiasing != null){
								if(spr.antialiasing){
									bg.antialiasing = true;
								}
							}
							if(spr.spriteName != null){
								modchartSprites.set("" + spr.spriteName,bg);
							}
						}//fin del else layername != null
					}//fin del for
					offsets = [stageData.player1X,stageData.player1Y,stageData.player2X,stageData.player2Y,stageData.gfX,stageData.gfY];
				}else
					addDefaultStage();
			}//fin del default
		}//fin del switch
	}//fin del new

	function addDefaultStage():Void{
		PlayState.curStage = "stage";
		PlayState.instance.setDefaultZoom(0.9);
		var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
		bg.antialiasing = FlxG.save.data.antialiasing;
		bg.scrollFactor.set(0.9, 0.9);
		bg.active = false;
		background.add(bg);
	
		var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		stageFront.antialiasing = FlxG.save.data.antialiasing;
		stageFront.scrollFactor.set(0.9, 0.9);
		stageFront.active = false;
		background.add(stageFront);
	
		var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
		stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		stageCurtains.updateHitbox();
		stageCurtains.antialiasing = FlxG.save.data.antialiasing;
		stageCurtains.scrollFactor.set(1.3, 1.3);
		stageCurtains.active = false;
	
		background.add(stageCurtains);
	}

	public function getPlaces(/*offsetX1:Float,offsetY1:Float,offsetX2:Float,offsetY2:Float,gf:Character*/):Array<Float>{
		/*if(offsets[0] != 0)
			offsetX1 += offsets[0] *1;
		if(offsets[1] != 0)
			offsetY1 += offsets[1] *1;
		if(offsets[2] != 0)
			offsetX2 += offsets[2] *1;
		if(offsets[3] != 0)
			offsetY2 += offsets[3] *1;
		if(offsets[4] != 0)
			gf.x += offsets[4] *1;
		if(offsets[5] != 0)
			gf.y += offsets[5] *1;*/
		return this.offsets;
	}

	public function modchartSetting():Void{
		if(modchartExists || hasLua){
			for(layer in layers.keys()){
				PlayState.luaModchart.layers.set(layer,layers[layer]);
			}
			for(spr in modchartSprites.keys()){
				ModchartState.luaSprites.set(spr,modchartSprites[spr]);
				trace("agregados " + ModchartState.luaSprites + "\n" + modchartExists+":"+hasLua);
			}
		}
	}
}//fin de la clase