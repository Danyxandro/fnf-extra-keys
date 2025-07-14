package ui;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.addons.ui.FlxUIButton;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import haxe.Json;
import Character;
import flixel.system.debug.interaction.tools.Pointer.GraphicCursorCross;
import lime.system.Clipboard;
import flixel.animation.FlxAnimation;
import flixel.ui.FlxBar;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxGroup;
import ui.InputTextFix;
import ui.FlxUIDropDownMenuCustom.FlxUIDropDownHeader;
import flixel.graphics.frames.FlxAtlasFrames;
import sys.FileSystem;
import sys.io.File;

#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class StageEditor extends MusicBeatState
{
	private var camFollow:FlxObject;
	private var cameraFollowPointer:FlxSprite;
	private var camEditor:FlxCamera;
	private var camHUD:FlxCamera;
	private var camMenu:FlxCamera;
	private var layerBGs:Array<FlxGroup> = [new FlxGroup(), new FlxGroup(), new FlxGroup(), new FlxGroup(), new FlxGroup()];
	private var dad:FlxSprite;
	private var bf:FlxSprite;
	private var gf:Character;
	private var showHUD:Bool = true;
	private var camZoom:Float = 0.9;
	private var stageDropDown:FlxUIDropDownMenuCustom;
	private var UI_box:FlxUITabMenu;
	private var UI_imagebox:FlxUITabMenu;
	private var HUDbutton:FlxButton;
	private var tipGroup:FlxGroup;

	private var zoomDropDown:FlxCustomStepper;
	private var nameInput:InputTextFix;
	private var lockControls:Bool = false;
	private var images:Array<Dynamic> = [];
	private var imagesIDs:Map<String,Array<Int>> = [];
	private var curSelected:Int = 0;
	private var anchorPoint:Array<Float>;
	private var offsets:Array<Int>;
	private var positions:Array<Float>;

	private var objMap:Map<String,Dynamic> = [];

	override function create(){
		FlxG.mouse.visible = true;

		camEditor = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camMenu = new FlxCamera();
		camMenu.bgColor.alpha = 0;

		FlxG.cameras.reset(camEditor);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camMenu);
		FlxCamera.defaultCameras = [camEditor];

		layerBGs[3].cameras = [camHUD];
		layerBGs[4].cameras = [camHUD];

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);
		FlxG.camera.follow(camFollow);

		var pointer:FlxGraphic = FlxGraphic.fromClass(GraphicCursorCross);
		cameraFollowPointer = new FlxSprite().loadGraphic(pointer);
		cameraFollowPointer.setGraphicSize(40, 40);
		cameraFollowPointer.updateHitbox();
		cameraFollowPointer.color = FlxColor.WHITE;
		cameraFollowPointer.screenCenter();
		cameraFollowPointer.cameras = [camHUD];

		add(layerBGs[0]);
		gf = new Character(400, 130, "gf");
		add(gf);
		add(layerBGs[1]);
		dad = new FlxSprite(100, 100);
		dad.loadGraphic(Paths.image('editors/silhouetteDad',"shared"));
		dad.offset.set(-6, 2);
			
		bf = new FlxSprite(770, 450);
		bf.loadGraphic(Paths.image('editors/silhouetteBF',"shared"));
		bf.offset.set(-4, 1);

		bf.antialiasing = dad.antialiasing = FlxG.save.data.antialiasing;
		positions = [bf.x,bf.y,dad.x,dad.y,gf.x,gf.y];
		add(dad);
		add(bf);
		add(layerBGs[2]);
		add(layerBGs[3]);
		add(cameraFollowPointer);
		add(layerBGs[4]);

		var tabs = [
			//{name: 'Offsets', label: 'Offsets'},
			{name: 'Settings', label: 'Settings'},
		];

		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.cameras = [camMenu];

		UI_box.resize(250, 155);
		UI_box.x = FlxG.width - 275;
		UI_box.y = 25;
		UI_box.scrollFactor.set();

		var tabs = [
			{name: 'Images', label: 'Images'},
			{name: 'Animations', label: 'Animations'},
			{name: 'Offsets', label: 'Offsets'},
		];
		UI_imagebox = new FlxUITabMenu(null, tabs, true);
		UI_imagebox.cameras = [camMenu];

		UI_imagebox.resize(350, 250);
		UI_imagebox.x = UI_box.x - 100;
		UI_imagebox.y = UI_box.y + UI_box.height;
		anchorPoint = [UI_imagebox.x + 0, UI_imagebox.y + 0];
		UI_imagebox.scrollFactor.set();
		UI_imagebox.x += 700;
		
		add(UI_imagebox);
		add(UI_box);
		FlxG.camera.zoom = camZoom;

		addUIStuff();
		setDefaultStage();
		reloadStageDropDown();
		UI_imagebox.selected_tab_id = "Images";

		super.create();
	}

	override function update(elapsed:Float)
	{
		lockControls = (InputTextFix.isTyping || stageDropDown.dropPanel.visible || imageSelector.dropPanel.visible);

		if(!lockControls){
			if (FlxG.keys.pressed.W || FlxG.keys.pressed.A || FlxG.keys.pressed.S || FlxG.keys.pressed.D)
			{
				var addToCam:Float = 500 * elapsed;
				if (FlxG.keys.pressed.SHIFT)
					addToCam *= 4;

				if (FlxG.keys.pressed.W)
					camFollow.y -= addToCam;
				else if (FlxG.keys.pressed.S)
					camFollow.y += addToCam;

				if (FlxG.keys.pressed.A)
					camFollow.x -= addToCam;
				else if (FlxG.keys.pressed.D)
					camFollow.x += addToCam;
			}

			if (FlxG.keys.pressed.E && FlxG.camera.zoom < 3) {
				FlxG.camera.zoom += elapsed * FlxG.camera.zoom;
				if(FlxG.camera.zoom > 3) FlxG.camera.zoom = 3;
			}
			if (FlxG.keys.pressed.Q && FlxG.camera.zoom > 0.1) {
				FlxG.camera.zoom -= elapsed * FlxG.camera.zoom;
				if(FlxG.camera.zoom < 0.1) FlxG.camera.zoom = 0.1;
			}
			if (FlxG.keys.justPressed.R) {
				FlxG.camera.zoom = camZoom;
			}
		
			if (FlxG.keys.justPressed.ESCAPE) {
				FlxG.switchState(new EditorsMenu());
				FlxG.mouse.visible = false;
				return;
			}
		}

		FlxG.watch.addQuick('Cam zoom',FlxG.camera.zoom);
		super.update(elapsed);
	}

	private function setDefaultStage(){
		clearStage();
		offsets = [0,0,0,0,0,0];

		var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback',"shared"));
		bg.antialiasing = FlxG.save.data.antialiasing;
		bg.scrollFactor.set(0.9, 0.9);
		bg.active = false;
		layerBGs[0].add(bg);
	
		var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront',"shared"));
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		stageFront.antialiasing = FlxG.save.data.antialiasing;
		stageFront.scrollFactor.set(0.9, 0.9);
		stageFront.active = false;
		layerBGs[0].add(stageFront);
	
		var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains',"shared"));
		stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		stageCurtains.updateHitbox();
		stageCurtains.antialiasing = FlxG.save.data.antialiasing;
		stageCurtains.scrollFactor.set(1.3, 1.3);
		stageCurtains.active = false;
	
		layerBGs[0].add(stageCurtains);
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
		if(id == FlxCustomStepper.CHANGE_EVENT && (sender is FlxCustomStepper)) {
			if (sender == zoomDropDown)
			{
				camZoom = zoomDropDown.value;
				FlxG.camera.zoom = camZoom;
			}
		}/*else if(id == InputTextFix.CHANGE_EVENT && (sender is InputTextFix)) {
			if(sender == imageInputText) {
				if(imageInputText.text.length > 0 && nameInput.text.length > 0){
					insertImage(imageInputText.text);
				}
			}
		}*/
	}

	private var imageInputText:InputTextFix;
	private var imgNameInput:InputTextFix;
	private var imageSelector:FlxUIDropDownMenuCustom;
	private var imageSelector2:FlxUIDropDownMenuCustom;
	private var layerDropdown:FlxUIDropDownMenuCustom;

	private function addUIStuff(){
		var tipTextArray:Array<String> = "E/Q - Camera Zoom In/Out
		\nR - Reset Camera Zoom
		\nWASD - Move Camera
		\nHold Shift to Move 10x faster\n".split('\n');
		tipGroup = new FlxGroup();

		for (i in 0...tipTextArray.length-1)
		{
			var tipText:FlxText = new FlxText(FlxG.width - 320, FlxG.height - 15 - 16 * (tipTextArray.length - i), 300, tipTextArray[i], 12);
			tipText.cameras = [camHUD];
			tipText.setFormat(null, 12, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
			tipText.scrollFactor.set();
			tipText.borderSize = 1;
			tipGroup.add(tipText);
		}
		add(tipGroup);

		var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "Settings";

		stageDropDown = new FlxUIDropDownMenuCustom(10, 30, FlxUIDropDownMenuCustom.makeStrIdLabelArray(['stage'], true), function(stage:String)
		{
			if(stageDropDown.selectedLabel == "stage"){
				UI_imagebox.x = anchorPoint[0] + 700;
				setDefaultStage();
			}else{
				UI_imagebox.x = anchorPoint[0] + 0;
				loadStage(stageDropDown.selectedLabel);
			}
		});
		stageDropDown.selectedLabel = "stage";

		zoomDropDown = new FlxCustomStepper(10, stageDropDown.y + 40, 0.05, 0.9, 0.05, 5, 2, 25, 0.2);
		var reloadBtn:FlxButton = new FlxButton(150, 30, "Create new", function()
		{
			clearStage();
			UI_imagebox.x = anchorPoint[0] + 0;
		});

		var saveBtn:FlxButton = new FlxButton(150, stageDropDown.y + 35, "Save stage", function()
		{
			
		});
		saveBtn.color = FlxColor.fromRGB(17, 176, 14, 255);
		saveBtn.label.color = FlxColor.WHITE;

		nameInput = new InputTextFix(10, 110, 200, '', 8);

		tab_group.add(new FlxText(stageDropDown.x, stageDropDown.y - 18, 0, 'Stage:'));
		tab_group.add(new FlxText(10, zoomDropDown.y - 18, 0, 'Scale:'));
		tab_group.add(zoomDropDown);
		tab_group.add(new FlxText(10, nameInput.y - 18, 0, 'Folder:'));
		tab_group.add(nameInput);
		tab_group.add(reloadBtn);
		tab_group.add(saveBtn);
		tab_group.add(stageDropDown);
		UI_box.addGroup(tab_group);

		HUDbutton = new FlxButton(FlxG.width - 360, 25, "", function()
		{
			//onPixelBG = !onPixelBG;
			showHUD = !showHUD;
			HUDbutton.text = showHUD ? "Hide HUD" : "Show HUD";
			UI_box.visible = tipGroup.visible = !!showHUD;
			if(showHUD)
				UI_imagebox.y = anchorPoint[1] + 0;
			else
				UI_imagebox.y = anchorPoint[1] - 500;
		});
		HUDbutton.text = "Hide HUD";
		HUDbutton.cameras = [camMenu];
		HUDbutton.color = FlxColor.fromRGB(6,57,112,255);
		HUDbutton.label.color = FlxColor.WHITE;
		add(HUDbutton);

		var tab_group2 = new FlxUI(null, UI_imagebox);
		tab_group2.name = "Images";

		imageInputText = new InputTextFix(15, 30, 200, '', 8);

		imgNameInput = new InputTextFix(15, 70, 200, '', 8);

		var addButton:FlxButton = new FlxButton(250, 25, "Add", function()
		{
			insertImage();
		});

		imageSelector = new FlxUIDropDownMenuCustom(15, 110, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(image:String)
		{
			imageSelector2.selectedLabel = imageSelector.selectedLabel;
		},new FlxUIDropDownHeader(200));

		var removeButton:FlxButton = new FlxButton(25 + imageSelector.width, 110, "Remove", function()
		{
			
		});
		removeButton.color = FlxColor.RED;
		removeButton.label.color = FlxColor.WHITE;

		var xStepper = new FlxCustomStepper(15, 155,1,0,-5000,5000);
		objMap.set("xStepper",xStepper);
		var yStepper = new FlxCustomStepper(80, 155,1,0,-5000,5000);
		objMap.set("yStepper",yStepper);
		layerDropdown = new FlxUIDropDownMenuCustom(150, 150, FlxUIDropDownMenuCustom.makeStrIdLabelArray(
			['Behind characters','Between GF and the characters','In front of characters','On HUD behind strums and arrows','In front of HUD']
		, true), function(layer:String)
		{
			
		},new ui.FlxUIDropDownMenuCustom.FlxUIDropDownHeader(170));
		var anti_check = new FlxUICheckBox(15, 195, null, null, "Antialiasing", 70);
		objMap.set("anti_check",anti_check);
		var asLayer_check = new FlxUICheckBox(220, 70, null, null, "Set as layer", 70);
		objMap.set("asLayer_check",asLayer_check);
		var scaleStepper = new FlxCustomStepper(110, 195,0.05,1,0.05,50,2,35,1);
		objMap.set("scaleStepper",scaleStepper);
		var scrollXStepper = new FlxCustomStepper(195, 195,0.1,1,0.1,50,1,30,1);
		objMap.set("scrollXStepper",scrollXStepper);
		var scrollYStepper = new FlxCustomStepper(260, 195,0.1,1,0.1,50,1,30,1);
		objMap.set("scrollYStepper",scrollYStepper);

		tab_group2.add(new FlxText(15, 12, 0, 'Image file:'));
		tab_group2.add(imageInputText);
		tab_group2.add(new FlxText(15, imgNameInput.y - 18, 0, 'Sprite name (for modchart accessing):'));
		tab_group2.add(imgNameInput);
		tab_group2.add(new FlxText(15, imageSelector.y - 18, 0, 'Edit image:'));
		tab_group2.add(addButton);
		tab_group2.add(removeButton);
		tab_group2.add(new FlxText(xStepper.x, xStepper.y - 18, 0, 'X Pos:'));
		tab_group2.add(xStepper);
		tab_group2.add(new FlxText(yStepper.x, yStepper.y - 18, 0, 'Y Pos:'));
		tab_group2.add(yStepper);
		tab_group2.add(new FlxText(layerDropdown.x, layerDropdown.y - 18, 0, 'Layer:'));
		tab_group2.add(anti_check);
		tab_group2.add(asLayer_check);
		tab_group2.add(new FlxText(scaleStepper.x, scaleStepper.y - 18, 0, 'Scale:'));
		tab_group2.add(scaleStepper);
		tab_group2.add(new FlxText(scrollXStepper.x, scrollXStepper.y - 18, 0, 'Scroll X:'));
		tab_group2.add(scrollXStepper);
		tab_group2.add(new FlxText(scrollYStepper.x, scrollYStepper.y - 18, 0, 'Scroll Y:'));
		tab_group2.add(scrollYStepper);
		tab_group2.add(layerDropdown);
		tab_group2.add(imageSelector);

		var tab_group3 = new FlxUI(null, UI_imagebox);
		tab_group3.name = "Animations";

		imageSelector2 = new FlxUIDropDownMenuCustom(15, 30, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(image:String)
		{
			imageSelector.selectedLabel = imageSelector2.selectedLabel;
		},new FlxUIDropDownHeader(150));

		var animationDropdown = new FlxUIDropDownMenuCustom(175, 30, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(anim:String)
		{
			
		},new FlxUIDropDownHeader(150));
		objMap.set("animationDropdown",animationDropdown);
		/*var animInput = new InputTextFix(15, 70, 135, '', 8);
		objMap.set("animInput",animInput);*/
		var XMLInput = new InputTextFix(/*175*/15, 70, 200, '', 8);
		objMap.set("XMLInput",XMLInput);
		var addAnimBtn:FlxUIButton = new FlxUIButton(15, 90, "Add animation", function()
		{
			
		});
		objMap.set("addAnimBtn",addAnimBtn);
		var removeAnimBtn:FlxUIButton = new FlxUIButton(115, 90, "Remove animation", function()
		{
			
		});
		removeAnimBtn.resize(removeAnimBtn.width + 30, removeAnimBtn.height);
		objMap.set("removeAnimBtn",addAnimBtn);
		var startAnimDrop = new FlxUIDropDownMenuCustom(15, 130, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(anim:String)
		{
			
		},new FlxUIDropDownHeader(200));
		objMap.set("startAnimDrop",startAnimDrop);
		var animNameInput = new InputTextFix(15, 170, 150, '', 8);
		objMap.set("animNameInput",animNameInput);
		var prefixInput = new InputTextFix(175, 170, 150, '', 8);
		objMap.set("prefixInput",prefixInput);
		var fpsStepper = new FlxCustomStepper(15, 205,1,24,0,60);
		objMap.set("fpsStepper",fpsStepper);
		var loop_check = new FlxUICheckBox(90, 205, null, null, "Looped", 70);
		objMap.set("loop_check",loop_check);

		tab_group3.add(new FlxText(15, imageSelector2.y - 18, 0, 'Select object to edit:'));
		tab_group3.add(new FlxText(animationDropdown.x, animationDropdown.y - 18, 0, 'Play animation:'));
		/*tab_group3.add(new FlxText(animInput.x, animInput.y - 18, 0, 'Animation name:'));
		tab_group3.add(animInput);*/
		tab_group3.add(new FlxText(XMLInput.x, XMLInput.y - 18, 0, 'XML file:'));
		tab_group3.add(XMLInput);
		tab_group3.add(addAnimBtn);
		tab_group3.add(removeAnimBtn);
		tab_group3.add(new FlxText(startAnimDrop.x, startAnimDrop.y - 18, 0, 'Starting animation:'));
		
		tab_group3.add(new FlxText(animNameInput.x, animNameInput.y - 18, 0, 'Animation name:'));
		tab_group3.add(animNameInput);
		tab_group3.add(new FlxText(prefixInput.x, prefixInput.y - 18, 0, 'Prefix:'));
		tab_group3.add(prefixInput);
		tab_group3.add(new FlxText(fpsStepper.x, fpsStepper.y - 18, 0, 'Framerate:'));
		tab_group3.add(fpsStepper);
		tab_group3.add(loop_check);
		tab_group3.add(startAnimDrop);
		tab_group3.add(animationDropdown);
		tab_group3.add(imageSelector2);

		var tab_group4 = new FlxUI(null, UI_imagebox);
		tab_group4.name = "Offsets";

		var bfXStepper = new FlxCustomStepper(15, 30,1,0,0,80);
		objMap.set("bfXStepper",bfXStepper);
		var bfYStepper = new FlxCustomStepper(175, 30,1,0,0,80);
		objMap.set("bfYStepper",bfYStepper);
		var dadXStepper = new FlxCustomStepper(15, 110,1,0,0,80);
		objMap.set("dadXStepper",dadXStepper);
		var dadYStepper = new FlxCustomStepper(175, 110,1,0,0,80);
		objMap.set("dadYStepper",dadYStepper);
		var gfXStepper = new FlxCustomStepper(15, 70,1,0,0,80);
		objMap.set("gfXStepper",gfXStepper);
		var gfYStepper = new FlxCustomStepper(175, 70,1,0,0,80);
		objMap.set("gfYStepper",gfYStepper);
		tab_group4.add(new FlxText(bfXStepper.x, bfXStepper.y - 18, 0, 'Boyfriend X pos:'));
		tab_group4.add(bfXStepper);
		tab_group4.add(new FlxText(bfYStepper.x, bfYStepper.y - 18, 0, 'Boyfriend Y pos:'));
		tab_group4.add(bfYStepper);
		tab_group4.add(new FlxText(gfXStepper.x, gfXStepper.y - 18, 0, 'Girlfriend X pos:'));
		tab_group4.add(gfXStepper);
		tab_group4.add(new FlxText(gfYStepper.x, gfYStepper.y - 18, 0, 'Girlfriend Y pos:'));
		tab_group4.add(gfYStepper);
		tab_group4.add(new FlxText(dadXStepper.x, dadXStepper.y - 18, 0, 'Dad X pos:'));
		tab_group4.add(dadXStepper);
		tab_group4.add(new FlxText(dadYStepper.x, dadYStepper.y - 18, 0, 'Dad Y pos:'));
		tab_group4.add(dadYStepper);

		UI_imagebox.addGroup(tab_group2);
		UI_imagebox.addGroup(tab_group3);
		UI_imagebox.addGroup(tab_group4);
	}

	private function reloadImageList(){
		var labels:Array<String> = [''];

		for(id in imagesIDs.keys()){
			//labels.push(images[imagesIDs.get(id)].image);
			labels.push(id);
		}

		imageSelector.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(labels, true));
		imageSelector.selectedLabel = "";
		imageSelector2.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(labels, true));
		imageSelector2.selectedLabel = "";
		curSelected = 0;

		trace(images + "\n" + imagesIDs);
	}

	private function reloadStageDropDown() {
		var stageLoaded:Map<String, Bool> = new Map();
		var stageList:Array<String> = ["stage"];

		stageLoaded.set("stage",true);

		var directory:String = "assets/stages/";
		if(sys.FileSystem.exists(directory)) {
			for (file in sys.FileSystem.readDirectory(directory)) {
				var path = haxe.io.Path.join([directory, file]);
				var stageToCheck:String = ""+file;//file.substr(0, file.length - 5);
				if(!stageLoaded.exists(stageToCheck) && stageToCheck.endsWith(".json")) {
					stageList.push(stageToCheck.substr(0, stageToCheck.length - 5));
					stageLoaded.set(stageToCheck, true);
				}
			}
		}

		stageDropDown.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(stageList, true));
		stageDropDown.selectedLabel = "stage";
		reloadImageList();
	}

	private function clearStage(){
		for(layer in layerBGs){
			layer.forEachAlive(function(obj:flixel.FlxBasic){
				obj.destroy();
			});
			layer.clear();
		}
		images = [];
		imagesIDs = [];
		for(obj in objMap){
			if((obj is FlxCustomStepper)){
				var auxStepper:FlxCustomStepper = cast obj;
				auxStepper.value = 0;
			}else if((obj is FlxUICheckBox)){
				var auxCheckbox:FlxUICheckBox = cast obj;
				auxCheckbox.checked = false;
			}else if((obj is FlxUIDropDownMenuCustom)){
				var auxDropdown:FlxUIDropDownMenuCustom = cast obj;
				auxDropdown.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true));
				auxDropdown.selectedLabel = "";
			}
		}
		layerDropdown.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(
		['Behind characters','Between GF and the characters','In front of characters','On HUD behind strums and arrows','In front of HUD']
		,true));
		layerDropdown.selectedLabel = 'Behind characters';
		objMap.get("scaleStepper").value = 1;
		objMap.get("scrollXStepper").value = 1;
		objMap.get("scrollYStepper").value = 1;
		objMap.get("fpsStepper").value = 24;
	}

	private function insertImage(){
		var route:String;
		var sprite:FlxSprite;

		if(imageInputText.text.length > 0 && nameInput.text.length > 0){
			route = "assets/stages/"+nameInput.text+"/"+imageInputText.text+".png";
			
			if(sys.FileSystem.exists(route)) {
				sprite = new FlxSprite();
				sprite.loadGraphic(openfl.display.BitmapData.fromFile(route));
				layerBGs[0].add(sprite);
				var img = {
					"x":0, "y":0,
					"scrollX":1, "scrollY":1,
					"scale":1, "antialiasing": sprite.antialiasing,
					"image":imageInputText.text
				};
				if(imgNameInput.text.length > 0)
					Reflect.setField(img, "spriteName", imgNameInput.text);
				images.push(img);
				if(imagesIDs.exists(imageInputText.text)){
					var count:Int = 0;
					for(id in imagesIDs.keys()){
						if(id.startsWith(imageInputText.text))
							count++;
					}
					imagesIDs.set(imageInputText.text + " " + count,[getLayerIndex(),layerBGs[getLayerIndex()].length -1]);
				}else
					imagesIDs.set(imageInputText.text,[getLayerIndex(),layerBGs[getLayerIndex()].length -1]);
				reloadImageList();
			}
		}
	}

	private function loadStage(stage:String){
		clearStage();
		var routeJSON:String = "assets/stages/" + stage.toLowerCase() + ".json";
		if(FileSystem.exists(routeJSON)){
			var stageData = cast Json.parse(File.getContent(routeJSON).trim());
			trace(stageData);
			var zoom = 1.05;
			zoom = stageData.zoom;
			FlxG.camera.zoom = camZoom = zoomDropDown.value = zoom + 0;
			var sprites:Array<Dynamic> = stageData.sprites;
			for(spr in sprites){
				images.push(spr);
				var bg:FlxSprite = new FlxSprite(spr.x,spr.y);
				var png:String = "assets/stages/"+stage.toLowerCase()+"/"+spr.image+".png";
				if(spr.layerName != null){
					if(imagesIDs.exists(spr.layerName)){
						var count:Int = 0;
						for(id in imagesIDs.keys()){
							if(id.startsWith(spr.layerName))
								count++;
						}
						imagesIDs.set(spr.layerName + " " + count,[spr.zPos,layerBGs[spr.zPos].length -1]);
					}else
						imagesIDs.set(spr.layerName,[spr.zPos,layerBGs[spr.zPos].length -1]);
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
					switch(spr.zPos){
						case 1:
							layerBGs[1].add(bg);
						case 2:
							layerBGs[2].add(bg);
						case 3:
							layerBGs[3].add(bg);
						case 4:
							layerBGs[4].add(bg);
						default:
							layerBGs[0].add(bg);
					}
					if(imagesIDs.exists(spr.image)){
						var count:Int = 0;
						for(id in imagesIDs.keys()){
							if(id.startsWith(spr.image))
								count++;
						}
						imagesIDs.set(spr.image + " " + count,[spr.zPos,layerBGs[spr.zPos].length -1]);
					}else
						imagesIDs.set(spr.image,[spr.zPos,layerBGs[spr.zPos].length -1]);
					if(spr.antialiasing != null){
						if(spr.antialiasing){
							bg.antialiasing = true;
						}
					}
				}//fin del else layername != null
			}//fin del for
			offsets = [stageData.player1X,stageData.player1Y,stageData.player2X,stageData.player2Y,stageData.gfX,stageData.gfY];
			bf.x = positions[0] + offsets[0];
			bf.y = positions[1] + offsets[1];
			dad.x = positions[2] + offsets[2];
			dad.y = positions[3] + offsets[3];
			gf.x = positions[4] + offsets[4];
			gf.y = positions[5] + offsets[5];
			objMap.get("bfXStepper").value = offsets[0];
			objMap.get("bfYStepper").value = offsets[1];
			objMap.get("dadXStepper").value = offsets[2];
			objMap.get("dadYStepper").value = offsets[3];
			objMap.get("gfXStepper").value = offsets[4];
			objMap.get("gfYStepper").value = offsets[5];
		}else
			setDefaultStage();
		reloadImageList();
	}

	private function getLayerIndex():Int{
		switch(layerDropdown.selectedLabel){
			case 'Between GF and the characters':
				return 1;
			case 'In front of characters':
				return 2;
			case 'On HUD behind strums and arrows':
				return 3;
			case 'In front of HUD':
				return 4;
			default:
				return 0;
		}
	}
}