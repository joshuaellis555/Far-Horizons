package planets;
import button.Button;
import event.Event;
import event.MouseEvent;
import event.MouseEventType;
import event.ResourceEvent;
import event.ResourceEventType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import groups.Groups;
import observer.Observer;
import observer.Subject;
import planets.PlanetMenu;
import player.Player;
import resources.ResourceEnabled;
import resources.ResourceTypes;
import resources.Resources;

/**
 * ...
 * @author 
 */
class Planet extends Button implements Observer implements ResourceEnabled
{
	private var menu:PlanetMenu;
	
	public var resources:Resources;
	public var upgradeCosts:Resources;
	
	private var owner:Player;
	
	private var planetSubject:Subject;
	
	public var statsImgs:Map<FlxColor, FlxSprite>;
	private var maxResource = 20;
	private var popupResources:Int = 0;
	public var showResources:Bool = false;
	private var NofResources:Int = 0;
	
	public var size:Int;
	
	private var locked:Bool;
	
	public function new(x:Int,y:Int,size:Int,type:Int,player:Player,resources:Resources,costs:Resources)
	{
		this.size = size;
		
		super(size, size, Std.int(x - size / 2), Std.int(y - size / 2), FlxColor.WHITE, this, FlxG.cameras.list[2]);
		
		owner = player;
		this.resources = resources;
		planetSubject = new Subject([owner]);
		
		loadGraphic(AssetPaths.imgPlanets__png, true, 401, 401);
		setGraphicSize(size, size);
		offset.x = (401-size)/2;
		offset.y = offset.x;
		animation.add("base", [type], 1, false);
		animation.play("base");
		width = size;
		height = size;
		
		var NofResources = resources.length();
		var rTypes:Array<FlxColor> = resources.types();
		
		statsImgs = [for (key in  ResourceTypes.types) key => new FlxSprite(x, y)];
		
		for (key in ResourceTypes.types)
		{
			statsImgs[key].loadGraphic(AssetPaths.Wedges__png, true, 300, 300);
			statsImgs[key].camera = FlxG.cameras.list[2];
			statsImgs[key].color = cast key;
			statsImgs[key].origin.x = 0;
			statsImgs[key].origin.y = 0;
			statsImgs[key].antialiasing = true;
			statsImgs[key].visible = false;
			FlxG.state.add(statsImgs[key]);
			for (i in 0...ResourceTypes.types.length)
				statsImgs[key].animation.add(Std.string(i+1), [i+1], 1, false);
		}
		for (i in 0...NofResources){
			statsImgs[rTypes[i]].angle = i / NofResources * 360 -135;
		}
		for (key in resources.types()){
			statsImgs[key].animation.play(Std.string(NofResources));
		}
		updateStatsImg();
		
		Groups.planets.add(this);
	}//###  new  ###
	
	private function updateStatsImg()
	{
		if (NofResources != resources.types().length){
			
			for (key in ResourceTypes.types)
				statsImgs[key].visible = false;
			
			NofResources = resources.types().length;
			
			var rTypes:Array<FlxColor> = resources.types();
			
			for (i in 0...NofResources){
				statsImgs[rTypes[i]].angle = i / NofResources * 360 -135;
				statsImgs[rTypes[i]].visible = true;
				statsImgs[rTypes[i]].animation.play(Std.string(NofResources));
			}
			
		}
		for (key in resources.types()){
			statsImgs[key].scale.x = 0.445/300*size* ((resources.get(key)>0?resources.get(key)+1:0) + maxResource) / maxResource * (popupResources/10);
			statsImgs[key].scale.y = statsImgs[key].scale.x;
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		//trace(FlxG.cameras.list[5].scroll,"planet1");
		super.update(elapsed);
		if (showResources){
			if (popupResources < 10){
				if (popupResources==0)
					for (key in resources.types())
						statsImgs[key].visible = true;
				popupResources += 1;
				updateStatsImg();
			}
		}else{
			if (popupResources > 0){
				popupResources -= 1;
				updateStatsImg();
				if (popupResources==0)
					for (key in resources.types())
						statsImgs[key].visible = false;
			}
		}
		//trace(FlxG.cameras.list[5].scroll,"planet");
	}
	public function getOwner():Player
	{
		return owner;
	}
	public function setOwner(player:Player)
	{
		owner = player;
		planetSubject = new Subject([owner]);
	}
	
	public function upkeep()
	{
		planetSubject.notify(new ResourceEvent(planetSubject,resources, ResourceEventType.Gain));
	}
	public function reportIncome()
	{
		planetSubject.notify(new ResourceEvent(planetSubject,resources, ResourceEventType.Update));
	}
	public function updatePlayers()
	{
		Groups.planets.updatePlayers();
	}
	
	public function getID():Int
	{
		return planetSubject.getID();
	}
	public function setID(newID:Int)
	{
		planetSubject.setID(newID);
	}
	
	public function lock()
	{
		locked = true;
	}
	public function unlock()
	{
		locked = false;
	}
	
	/* INTERFACE observer.Observer */
	
	public function onNotify(event:Event):Void 
	{
		switch(event.eventType){
			case Mouse:{
				var m:MouseEvent = cast event;
				for (mouseEvent in m.mouseEvents)
				{
					if (!locked){
						switch(mouseEvent)
						{
							case MouseEventType.LeftJustClicked:{
								trace("menu");
								this.lock();
								menu = new PlanetMenu(FlxColor.BLACK, 0.6, this);
								popupResources = 10;
								updateStatsImg();
								FlxG.state.openSubState(menu);
							}
							case MouseEventType.RightJustClicked:{
								for (key in ResourceTypes.types){
									if (resources.get(key) == null){
										resources.setResource(key, 1);
										break;
									}
								}
								updateStatsImg();
							}
							case MouseEventType.MouseOver:{
								showResources = true;
							}
							case MouseEventType.MouseOff:{
								showResources = false;
							}
							default:null;
						}
					}
				}
			}
			case Resource:{
				var resourceEvent:ResourceEvent = cast event;
				switch(resourceEvent.transactionType)
				{
					case Gain:{
						trace("Gain");
						resources.add(resourceEvent.resources);
						updateStatsImg();
					}
					case Lose:{
						trace("Lose");
						if (resourceEvent.returnCall!=null){
							resourceEvent.returnCall(resources.remove(resourceEvent.resources));
						}else{
							resources.remove(resourceEvent.resources);
						}
						updateStatsImg();
					}
					case LoseNoCheck:{
						trace("LoseNoCheck");
						resources.remove(resourceEvent.resources, false);
						updateStatsImg();
					}
					case Check:{
						trace("Check");
						if (resourceEvent.returnCall!=null){
							resourceEvent.returnCall(resources.check(resourceEvent.resources));
						}
					}
					default:null;
				}
			}
			default:null;
		}
	}
}