package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.FlxCamera;
import openfl.Lib;
import openfl.net.URLRequest;
import haxe.io.Path;
import flixel.graphics.FlxGraphic;

import flixel.addons.display.FlxGridOverlay;

class MainState extends FlxState
{
	var mapCam:FlxCamera; //The camera that renders the tilemap being drawn
	var uiCam:FlxCamera; //The camera that renders the UI elements
	var bgCam:FlxCamera; //The camera that renders background elements
	var grabbedPos:FlxPoint = new FlxPoint( -1, -1); //For camera scrolling
	var initialScroll:FlxPoint = new FlxPoint(0, 0); //Ditto ^
	var editing:Bool = false; //Bool that determines whether or not the user is editing something
	var backgroundImage:FlxSprite; //Background
	
	var grid:FlxSprite;
	var file:Dropdown;
	var help:Dropdown;
	
	var saved:String;
	
	
	public function new(Editing:Bool = false){
		super();
		editing = Editing;
	}
	
	override public function create():Void
	{	
		super.create();
		FlxG.mouse.useSystemCursor = true;
		
		
		//Camera
		uiCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		uiCam.bgColor = FlxColor.TRANSPARENT;
		uiCam.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		uiCam.antialiasing = true;
		
		bgCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		bgCam.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		bgCam.antialiasing = true;
		
		if(editing){
			//Create map camera
			if((Current.MAP_SIZE.x * Current.TILE_SIZE) >= 1920 && (Current.MAP_SIZE.y * Current.TILE_SIZE) >= 1080){
				mapCam = new FlxCamera(Std.int((Current.MAP_SIZE.x * Current.TILE_SIZE)*-0.25), Std.int((Current.MAP_SIZE.y * Current.TILE_SIZE)*-0.25), Std.int((Current.MAP_SIZE.x * Current.TILE_SIZE)*1.5), Std.int((Current.MAP_SIZE.y * Current.TILE_SIZE)*1.5), 1);
				mapCam.scroll.x = ((Current.MAP_SIZE.x * Current.TILE_SIZE) * -0.23);
				mapCam.scroll.y = ((Current.MAP_SIZE.y * Current.TILE_SIZE) * -0.125);
			}else{
				mapCam = new FlxCamera(-480, -270, 2880, 1620, 1);
				mapCam.scroll.set((2880 * -0.5)+(Current.TILE_SIZE*Current.MAP_SIZE.x/2), (1620 * -0.5)+(Current.TILE_SIZE*Current.MAP_SIZE.y/2));
			}
			mapCam.bgColor = FlxColor.TRANSPARENT;
			FlxG.cameras.reset(bgCam);
			FlxG.cameras.add(mapCam);
			mapCam.antialiasing = true;
		}
		FlxG.camera.antialiasing = true;
		FlxG.cameras.add(uiCam);
		
		//BG
		backgroundImage = new FlxSprite(0, 0, "assets/sprites/background.png");
		backgroundImage.scrollFactor.set(0, 0);
		if (editing){
			backgroundImage.alpha = 0.25;
			backgroundImage.cameras = [bgCam];
		}
		
		//Grid
		grid = new FlxSprite(0, 0, FlxGraphic.fromBitmapData(FlxGridOverlay.createGrid(Current.TILE_SIZE, Current.TILE_SIZE, Std.int(Current.MAP_SIZE.x * Current.TILE_SIZE), Std.int(Current.MAP_SIZE.y * Current.TILE_SIZE), true, FlxColor.WHITE, FlxColor.fromRGB(204, 204, 204))));
		if (editing){
			grid.cameras = [mapCam];
			grid.alpha = 0.25;
		}
		
		//Toolbar
		file = new Dropdown(' File... ', ["New..", "Save..", "Save as..", "Open..", "Config"], new FlxPoint(0, 0), uiCam, fileEvent);
		help = new Dropdown(' Help... ', ["About", "Manual"], new FlxPoint(file.items[0].x + file.items[0].width, 0), uiCam, helpEvent);
		
		//Add things
		add(backgroundImage);
		if(editing){
			add(grid);
			//Add tiles
		}
		
		//Toolbar
		add(file);
		add(help);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if(editing){
			
			//Zoom in and out with the scrollwheel
			mapCam.zoom += 0.2 * FlxG.mouse.wheel;
			
			if (mapCam.zoom < 0.75)
				mapCam.zoom = 0.75;
			if (mapCam.zoom > 4)
				mapCam.zoom = 4;
			
			//Scroll the camera by pressing the middle button
			if (FlxG.mouse.justPressedMiddle){
				grabbedPos = FlxG.mouse.getWorldPosition(mapCam);
				initialScroll = mapCam.scroll;
			}
			if (FlxG.mouse.pressedMiddle){
				var mousePosChange:FlxPoint = FlxG.mouse.getWorldPosition(mapCam).subtractPoint(grabbedPos);
				mapCam.scroll.subtractPoint(mousePosChange);
			}
		}
	}
	
	function getPath(File:String){
		return Path.join([Path.directory(Sys.executablePath()), File]);
	}
	
	function fileEvent(ID:String):Void{
		switch(ID){
			case "New..":
				FlxG.switchState(new MainState(true)); //Needs a dialogue for setting map/tile sizes and whether or not to make it a nape map
			case "Save..":
				
			case "Save as..":
				
			case "Open..":
				
			case "Config":
				
		}
	}
	
	function helpEvent(ID:String):Void{
		switch(ID){
			case 'About':
				Lib.getURL(new URLRequest("file:///" + getPath("assets/doc/About.pdf")));
			case 'Manual':
				trace("file:///" + getPath("docs/About.pdf"));
		}
	}
}