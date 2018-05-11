package;
import button.Button;
import event.Event;
import event.MouseEvent;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import groups.Groups;
import observer.Observer;
import planets.Planet;
import planets.PlanetType;
import player.Player;
import resources.ResourceTypes;
import resources.Resources;

class PlayState extends FlxState implements Observer
{
	public var activePlayer:Player;
	
	var mapCam:FlxCamera; //The camera that renders the tilemap being drawn
	var uiCam:FlxCamera; //The camera that renders the UI elements
	var bgCam:FlxCamera; //The camera that renders background elements
	var menuUiCam:FlxCamera; //The camera that renders the UI elements
	var planetCam:FlxCamera; //The camera that renders the planet in PlanetMenu
	var menuCam:FlxCamera; //The camera that renders the UI elements in menus
	
	var grabbedPos:FlxPoint = new FlxPoint( -1, -1); //For camera scrolling
	
	var uiTextIncome:Map<FlxColor,FlxText>;
	var uiTextResources:Map<FlxColor,FlxText>;
	
	var uiMouseText:FlxText;
	var mouseOn:Int = 0;
	
	var theta:Float = 0;
	var planetlist:Array<Int> = [0, 1, 2, 3, 4, 5];
	
	override public function create():Void
	{
		super.create();
		
		this.persistentUpdate = true;
		
		activePlayer = new Player(new Resources([0, 0, 0, 0, 0]));
		
		// ################### Cameras #######################
		mapCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		mapCam.bgColor = FlxColor.TRANSPARENT;
		mapCam.antialiasing = true;
		
		bgCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		bgCam.antialiasing = true;
		
		menuUiCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		menuUiCam.bgColor = FlxColor.TRANSPARENT;
		menuUiCam.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		menuUiCam.antialiasing = true;
		
		planetCam = new FlxCamera(0,0,FlxG.width,FlxG.height);
		planetCam.bgColor = FlxColor.TRANSPARENT;
		planetCam.antialiasing = true;
		
		menuCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		menuCam.bgColor = FlxColor.TRANSPARENT;
		menuCam.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		menuCam.antialiasing = true;
		
		uiCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		uiCam.bgColor = FlxColor.TRANSPARENT;
		uiCam.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		uiCam.antialiasing = true;
		
		FlxG.camera.antialiasing = true;
		
		FlxG.cameras.add(bgCam);
		FlxG.cameras.add(mapCam);
		FlxG.cameras.add(menuUiCam);
		FlxG.cameras.add(planetCam);
		FlxG.cameras.add(menuCam);
		FlxG.cameras.add(uiCam);
		// ################################################
		
		var background = new Button(FlxG.width*4, FlxG.height*4, Std.int(-FlxG.width*2), Std.int(-FlxG.height*2) , FlxColor.BLACK,this,99,bgCam,AssetPaths.Stars__png, 4096, 2304);
		add(background);
		
		makePlanet();
		makePlanet();
			
		var bar:FlxSprite = new FlxSprite();
		bar.cameras = [uiCam];
		bar.makeGraphic(1024, 52, FlxColor.GRAY);
		add(bar);
		
		var uiIcons = new Map<FlxColor, Button>();
		uiTextIncome = new Map<FlxColor,FlxText>();
		uiTextResources = new Map<FlxColor,FlxText>();
		var rTypes:Array<FlxColor> = ResourceTypes.types;
		
		for (i in 0...ResourceTypes.types.length)
		{
			uiIcons[rTypes[i]] = new Button(0, 0, 0, 0, FlxColor.WHITE, this, i, uiCam, false, false, AssetPaths.Icons__png, true, 52, 52);
			
			uiIcons[rTypes[i]].antialiasing = true;
			
			uiIcons[rTypes[i]].animation.add(Std.string(rTypes[i]), [i], 1, false);
			uiIcons[rTypes[i]].animation.play(Std.string(rTypes[i]));
			
			uiIcons[rTypes[i]].setPosition(i * 128, 0);
			
			uiIcons[rTypes[i]].width = 128;
			
			add(uiIcons[rTypes[i]]);
			
			uiTextIncome[rTypes[i]] = new FlxText(54 + i * 128, 1, 74, Std.string(activePlayer.resources.get(rTypes[i])), 20, true);
			uiTextIncome[rTypes[i]].cameras = [uiCam];
			uiTextIncome[rTypes[i]].color = 0x00ff00;
			add(uiTextIncome[rTypes[i]]);
			
			uiTextResources[rTypes[i]] = new FlxText(54 + i * 128, 24, 74, Std.string(activePlayer.resources.get(rTypes[i])), 20, true);
			uiTextResources[rTypes[i]].cameras = [uiCam];
			add(uiTextResources[rTypes[i]]);
			
			if (activePlayer.resources.get(rTypes[i]) == null){
				uiIcons[rTypes[i]].visible = false;
				uiTextIncome[rTypes[i]].visible = false;
				uiTextResources[rTypes[i]].visible = false;
			}
		}
		
		uiMouseText = new FlxText(0, 0, 300, "", 20);
		uiMouseText.cameras = [uiCam];
		uiMouseText.color = 0x00ff00;
		add(uiMouseText);
		
		Groups.planets.upkeep();
		
		Groups.planets.updatePlayers();
		activePlayer.updateIncome();
		
		mapCam.zoom = 0.7;
		bgCam.zoom = (mapCam.zoom + 39) / 60;
	}
	
	private function makePlanet()
	{
		var t = 0;
		if (planetlist.length < 6)
			planetlist=planetlist.concat([0, 1, 2, 3, 4, 5]);
		var n = Std.random(6);
		t = planetlist[n];
		planetlist.remove(planetlist[n]);
		Groups.planets.addRandom(Std.int(Math.cos(theta) * (Std.int(theta + Std.random(1000) / 1000) * 60 + 200))+300, Std.int(Math.sin(theta) * (Std.int(theta + Std.random(1000) / 1000) * 60 + 200))+230, 100 + Std.random(50), cast t, activePlayer);
		theta += 1/Std.int(theta/6.283+1) + Std.random(500) / 1000;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		var bounds:Array<Float> = Groups.planets.getCameraBounds();
		bounds = [bounds[0] + FlxG.width / 2 * mapCam.zoom, bounds[1] - FlxG.width / 2 * mapCam.zoom, bounds[2] + FlxG.height / 2 * mapCam.zoom, bounds[3] - FlxG.height / 2 * mapCam.zoom];
		
		if (FlxG.mouse.wheel != 0)
		{
			mapCam.zoom = Math.min(Math.max(0.1, mapCam.zoom + (FlxG.mouse.wheel / Math.abs(FlxG.mouse.wheel) * mapCam.zoom / 4)), 1);
			bgCam.zoom = (mapCam.zoom + 39) / 60;
			if (FlxG.mouse.wheel>0 && mapCam.zoom < 1){
				var mousePosChange:FlxPoint = FlxG.mouse.getWorldPosition(mapCam).subtractPoint(grabbedPos);
				mapCam.scroll.subtractPoint(mousePosChange);
				if (mapCam.scroll.x < bounds[0]) mapCam.scroll.x = bounds[0];
				if (mapCam.scroll.x > bounds[1]) mapCam.scroll.x = bounds[1];
				if (mapCam.scroll.y < bounds[2]) mapCam.scroll.y = bounds[2];
				if (mapCam.scroll.y > bounds[3]) mapCam.scroll.y = bounds[3];
				bgCam.scroll.set(mapCam.scroll.x/40,mapCam.scroll.y/40);
			}
		}
		
		if (!FlxG.mouse.pressedMiddle || FlxG.mouse.justPressedMiddle){
			grabbedPos = FlxG.mouse.getWorldPosition(mapCam);
		}else{
			var mousePosChange:FlxPoint = FlxG.mouse.getWorldPosition(mapCam).subtractPoint(grabbedPos);
			mapCam.scroll.subtractPoint(mousePosChange);
			if (mapCam.scroll.x < bounds[0]) mapCam.scroll.x = bounds[0];
			if (mapCam.scroll.x > bounds[1]) mapCam.scroll.x = bounds[1];
			if (mapCam.scroll.y < bounds[2]) mapCam.scroll.y = bounds[2];
			if (mapCam.scroll.y > bounds[3]) mapCam.scroll.y = bounds[3];
			bgCam.scroll.set(mapCam.scroll.x/40,mapCam.scroll.y/40);
		}
		
		uiMouseText.setPosition(FlxG.mouse.x, FlxG.mouse.y + 30);
		
		var income = activePlayer.income;
		for (key in income.types()){
			uiTextIncome[key].text = "+" + Std.string(income.get(key));
			uiTextResources[key].text = Std.string(activePlayer.resources.get(key));
		}
	}
	
	
	
	/* INTERFACE observer.Observer */
	
	public function onNotify(event:Event):Void 
	{
		switch(event.eventType){
			case Mouse:{
				var m:MouseEvent = cast event;
				for (mouseEvent in m.mouseEvents)
				{
					switch(mouseEvent)
					{
						case RightJustReleased:{
							if (event.eventSource==99){
								trace("upkeep");
								Groups.planets.upkeep();
								makePlanet();
								Groups.planets.updatePlayers();
								activePlayer.updateIncome();
								for (key in ResourceTypes.types)
									uiTextResources[key].text = Std.string(activePlayer.resources.get(key));
								
							}
						}
						case MouseOver:{
							if (event.eventSource < 8){
								mouseOn = event.eventSource;
							}
						}
						case MouseOff:{
							if (mouseOn==event.eventSource)
								uiMouseText.text = "";
						}
						default:null;
					}
				}
			}
			default:null;
		}
	}
}