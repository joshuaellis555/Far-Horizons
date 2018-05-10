package;
import arbiters.Merchant;
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
	var mouseOn:Int=0;
	
	var merchant:Merchant = new Merchant();
	
	override public function create():Void
	{
		trace("play");
		super.create();
		
		this.persistentUpdate = true;
		
		activePlayer = new Player(new Resources([1, 1, 1, 1, 1]));
		
		// ############### Cameras #########################
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
		
		var planet = new Planet(Std.int(FlxG.width/2), Std.int(FlxG.height/2),200,PlanetType.GREEN,activePlayer, new Resources([13,2,8,0,7]), new Resources([1,1,1,1,1,1,1,1]));
		
		var planet = new Planet(0, 0,140,PlanetType.RED,activePlayer, new Resources([11,null,6,2,null]), new Resources([1,1,1,1,1,1,1,1]));
		var planet = new Planet(FlxG.width, 0,140,PlanetType.PURPLE,activePlayer, new Resources([7,14,null,null,null]), new Resources([1,1,1,1,1,1,1,1]));
		var planet = new Planet(0, FlxG.height,140,PlanetType.BLUE,activePlayer, new Resources([7,15,null,4,1]), new Resources([1,1,1,1,1,1,1,1]));
		var planet = new Planet(FlxG.width, FlxG.height,140,PlanetType.GRAY,activePlayer, new Resources([null,null,7,null,null]), new Resources([1,1,1,1,1,1,1,1]));
		
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
		
		Groups.planets.updatePlayers();
		activePlayer.updateIncome();
		
		mapCam.zoom = 0.7;
		bgCam.zoom = (mapCam.zoom + 39) /60;
	}

	override public function update(elapsed:Float):Void
	{
		//trace(FlxG.cameras.list[5].scroll,"playstate1");
		super.update(elapsed);
		
		if (FlxG.mouse.wheel != 0)
		{
			mapCam.zoom = Math.min(Math.max(0.1, mapCam.zoom + (FlxG.mouse.wheel / Math.abs(FlxG.mouse.wheel) * mapCam.zoom / 4)), 1);
			bgCam.zoom = (mapCam.zoom + 39) / 60;
			if (FlxG.mouse.wheel>0 && mapCam.zoom < 1){
				var mousePosChange:FlxPoint = FlxG.mouse.getWorldPosition(mapCam).subtractPoint(grabbedPos);
				mapCam.scroll.subtractPoint(mousePosChange);
				bgCam.scroll.subtract(mousePosChange.x/40,mousePosChange.y/40);
			}
		}
		
		if (!FlxG.mouse.pressedMiddle || FlxG.mouse.justPressedMiddle){
			grabbedPos = FlxG.mouse.getWorldPosition(mapCam);
		}else{
			var mousePosChange:FlxPoint = FlxG.mouse.getWorldPosition(mapCam).subtractPoint(grabbedPos);
			mapCam.scroll.subtractPoint(mousePosChange);
			bgCam.scroll.subtract(mousePosChange.x / 40, mousePosChange.y / 40);
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
								for (key in ResourceTypes.types)
									uiTextResources[key].text = Std.string(activePlayer.resources.get(key));
							}
						}
						case MouseOver:{
							if (event.eventSource < 8){
								//uiMouseText.text = "   +" + Std.string(activePlayer.income.get(ResourceTypes.types[event.eventSource]));
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