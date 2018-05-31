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
import endscreen.EndScreen;
import planets.Planet;
import planets.PlanetType;
import player.Player;
import resources.ResourceTypes;
import resources.Resources;
import cameras.Cameras;

class PlayState extends FlxState implements Observer
{
	public var activePlayer:Player;
	
	var grabbedPos:FlxPoint = new FlxPoint( -1, -1); //For camera scrolling
	
	var uiTextIncome:Map<FlxColor,FlxText>;
	var uiTextResources:Map<FlxColor,FlxText>;
	
	var uiMouseText:FlxText;
	var mouseOn:Int = 0;
	
	var theta:Float = 0;
	var planetlist:Array<Int> = [0, 1, 2, 3, 4, 5];
	
	var rounds = 9;
	var endRound:Button;
	var roundText:FlxText;
	
	override public function create():Void
	{
		super.create();
		
		this.persistentUpdate = true;
		
		activePlayer = new Player(new Resources([10, 10, 10, 10, 10]));
		
		// ################### Cameras #######################
		Cameras.mapCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		Cameras.mapCam.bgColor = FlxColor.TRANSPARENT;
		Cameras.mapCam.antialiasing = true;
		
		Cameras.bgCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		Cameras.bgCam.antialiasing = true;
		
		Cameras.menuUiCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		Cameras.menuUiCam.bgColor = FlxColor.TRANSPARENT;
		Cameras.menuUiCam.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		Cameras.menuUiCam.antialiasing = true;
		
		Cameras.planetCam = new FlxCamera(0,0,FlxG.width,FlxG.height);
		Cameras.planetCam.bgColor = FlxColor.TRANSPARENT;
		Cameras.planetCam.antialiasing = true;
		
		Cameras.menuCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		Cameras.menuCam.bgColor = FlxColor.TRANSPARENT;
		Cameras.menuCam.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		Cameras.menuCam.antialiasing = true;
		
		Cameras.uiCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		Cameras.uiCam.bgColor = FlxColor.TRANSPARENT;
		Cameras.uiCam.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		Cameras.uiCam.antialiasing = true;
		
		FlxG.camera.antialiasing = true;
		
		FlxG.cameras.add(Cameras.bgCam);
		FlxG.cameras.add(Cameras.mapCam);
		FlxG.cameras.add(Cameras.menuUiCam);
		FlxG.cameras.add(Cameras.planetCam);
		FlxG.cameras.add(Cameras.menuCam);
		FlxG.cameras.add(Cameras.uiCam);
		
		var background = new Button(FlxG.width*4, FlxG.height*4, Std.int(-FlxG.width*2), Std.int(-FlxG.height*2) , FlxColor.BLACK,this,99,Cameras.bgCam,AssetPaths.Stars__png, 4096, 2304);
		add(background);
		
		makePlanet();
		makePlanet();
			
		var bar:FlxSprite = new FlxSprite();
		bar.cameras = [Cameras.uiCam];
		bar.makeGraphic(1024, 52, FlxColor.GRAY);
		add(bar);
		
		var uiIcons = new Map<FlxColor, Button>();
		uiTextIncome = new Map<FlxColor,FlxText>();
		uiTextResources = new Map<FlxColor,FlxText>();
		var rTypes:Array<FlxColor> = ResourceTypes.types;
		
		for (i in 0...ResourceTypes.types.length)
		{
			uiIcons[rTypes[i]] = new Button(0, 0, 0, 0, FlxColor.WHITE, this, i, Cameras.uiCam, false, false, AssetPaths.Icons__png, true, 52, 52);
			
			uiIcons[rTypes[i]].antialiasing = true;
			
			uiIcons[rTypes[i]].animation.add(Std.string(rTypes[i]), [i], 1, false);
			uiIcons[rTypes[i]].animation.play(Std.string(rTypes[i]));
			
			uiIcons[rTypes[i]].setPosition(i * 128, 0);
			
			uiIcons[rTypes[i]].width = 128;
			
			add(uiIcons[rTypes[i]]);
			
			uiTextIncome[rTypes[i]] = new FlxText(54 + i * 128, 1, 74, Std.string(activePlayer.resources.get(rTypes[i])), 20, true);
			uiTextIncome[rTypes[i]].cameras = [Cameras.uiCam];
			uiTextIncome[rTypes[i]].color = 0x00ff00;
			add(uiTextIncome[rTypes[i]]);
			
			uiTextResources[rTypes[i]] = new FlxText(54 + i * 128, 24, 74, Std.string(activePlayer.resources.get(rTypes[i])), 20, true);
			uiTextResources[rTypes[i]].cameras = [Cameras.uiCam];
			add(uiTextResources[rTypes[i]]);
			
			if (activePlayer.resources.get(rTypes[i]) == null){
				uiIcons[rTypes[i]].visible = false;
				uiTextIncome[rTypes[i]].visible = false;
				uiTextResources[rTypes[i]].visible = false;
			}
		}
		
		uiMouseText = new FlxText(0, 0, 300, "", 20);
		uiMouseText.cameras = [Cameras.uiCam];
		uiMouseText.color = 0x00ff00;
		add(uiMouseText);
		
		endRound = new Button(300, 50, FlxG.width - 300, FlxG.height - 50, FlxColor.RED, this, -1, Cameras.menuUiCam);
		add(endRound);
		
		roundText = new FlxText(FlxG.width - 296, FlxG.height - 46, 292, "End Round " + Std.string(rounds)); // x, y, width
		roundText.cameras = [Cameras.menuUiCam];
		roundText.setFormat(null, 36, FlxColor.WHITE, FlxTextAlign.CENTER);
		roundText.setBorderStyle(OUTLINE, FlxColor.BLACK, 5);
		add(roundText);
		
		Groups.planets.upkeep();
		
		Groups.planets.updatePlayers();
		activePlayer.updateIncome();
		
		Cameras.mapCam.zoom = 0.7;
		Cameras.bgCam.zoom = (Cameras.mapCam.zoom + 39) / 60;
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
		bounds = [bounds[0] + FlxG.width / 2 * Cameras.mapCam.zoom, bounds[1] - FlxG.width / 2 * Cameras.mapCam.zoom, bounds[2] + FlxG.height / 2 * Cameras.mapCam.zoom, bounds[3] - FlxG.height / 2 * Cameras.mapCam.zoom];
		
		if (FlxG.mouse.wheel != 0)
		{
			Cameras.mapCam.zoom = Math.min(Math.max(0.1, Cameras.mapCam.zoom + (FlxG.mouse.wheel / Math.abs(FlxG.mouse.wheel) * Cameras.mapCam.zoom / 4)), 1);
			Cameras.bgCam.zoom = (Cameras.mapCam.zoom + 39) / 60;
			if (FlxG.mouse.wheel>0 && Cameras.mapCam.zoom < 1){
				var mousePosChange:FlxPoint = FlxG.mouse.getWorldPosition(Cameras.mapCam).subtractPoint(grabbedPos);
				Cameras.mapCam.scroll.subtractPoint(mousePosChange);
				if (Cameras.mapCam.scroll.x < bounds[0]) Cameras.mapCam.scroll.x = bounds[0];
				if (Cameras.mapCam.scroll.x > bounds[1]) Cameras.mapCam.scroll.x = bounds[1];
				if (Cameras.mapCam.scroll.y < bounds[2]) Cameras.mapCam.scroll.y = bounds[2];
				if (Cameras.mapCam.scroll.y > bounds[3]) Cameras.mapCam.scroll.y = bounds[3];
				Cameras.bgCam.scroll.set(Cameras.mapCam.scroll.x/40,Cameras.mapCam.scroll.y/40);
			}
		}
		
		if (!FlxG.mouse.pressedMiddle || FlxG.mouse.justPressedMiddle){
			grabbedPos = FlxG.mouse.getWorldPosition(Cameras.mapCam);
		}else{
			var mousePosChange:FlxPoint = FlxG.mouse.getWorldPosition(Cameras.mapCam).subtractPoint(grabbedPos);
			Cameras.mapCam.scroll.subtractPoint(mousePosChange);
			if (Cameras.mapCam.scroll.x < bounds[0]) Cameras.mapCam.scroll.x = bounds[0];
			if (Cameras.mapCam.scroll.x > bounds[1]) Cameras.mapCam.scroll.x = bounds[1];
			if (Cameras.mapCam.scroll.y < bounds[2]) Cameras.mapCam.scroll.y = bounds[2];
			if (Cameras.mapCam.scroll.y > bounds[3]) Cameras.mapCam.scroll.y = bounds[3];
			Cameras.bgCam.scroll.set(Cameras.mapCam.scroll.x/40,Cameras.mapCam.scroll.y/40);
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
						case LeftJustReleased:{
							if (event.eventSource == -1){
								if (rounds>0) makePlanet();
								Groups.planets.upkeep();
								Groups.planets.updatePlayers();
								activePlayer.updateIncome();
								for (key in ResourceTypes.types)
									uiTextResources[key].text = Std.string(activePlayer.resources.get(key));
								rounds--;
								if (rounds>1)
									roundText.text = "End Round " + Std.string(rounds);
								else if (rounds == 1)
									roundText.text = "End Game";
								else{
									var score:Int = Groups.players.getScore(activePlayer);
									openSubState(new EndScreen(FlxColor.BLACK, 0.6, score, "Well Done!"));
								}
								var bounds:Array<Float> = Groups.planets.getCameraBounds();
								Cameras.mapCam.scroll.x = (bounds[0] + bounds[1]) / 2;
								Cameras.mapCam.scroll.y = (bounds[2] + bounds[3]) / 2;
								Cameras.mapCam.zoom = Math.min(FlxG.width / (bounds[1] - bounds[0]), FlxG.height / (bounds[3] - bounds[2]));
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