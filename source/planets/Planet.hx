package planets;
import button.Button;
import event.Event;
import event.MouseEvent;
import event.MouseEventType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
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
	private var id:Int;
	
	public var resources:Resources;
	
	public var type:Int;
	
	private var growth:Float=0;
	
	private var owners:Array<Player>;
	
	public var statsImgs:Map<FlxColor, Button> = new Map<FlxColor, Button>();
	private var maxResource = 20;
	private var popupResources:Int = 0;
	public var showResources:Bool = false;
	private var mouseOverIDs:Array<Int> = [];
	public var mousedOver:Bool = false;
	private var NofResources:Int = 0;
	
	var costText:Map<FlxColor,FlxText> = new Map<FlxColor,FlxText>();
	
	public var size:Int;
	
	private var locked:Bool;
	
	public function new(x:Int,y:Int,size:Int,type:Int,player:Player,resources:Resources)
	{
		this.size = size;
		this.type = type;
		this.resources = resources;
		
		owners = [player];
		
		super(size, size, Std.int(x - size / 2), Std.int(y - size / 2), FlxColor.WHITE, this, 0, FlxG.cameras.list[2], false, true);
		
		loadGraphic(AssetPaths.Planets__png, true, 401, 401);
		setGraphicSize(size, size);
		offset.x = (401-size)/2;
		offset.y = offset.x;
		animation.add("base", [type], 1, false);
		animation.play("base");
		width = size;
		height = size;
		
		var NofResources = resources.length();
		var rTypes:Array<FlxColor> = ResourceTypes.types;
		
		for (i in 0...ResourceTypes.types.length)
		{
			statsImgs[rTypes[i]] = new Button(125, 125, x, y, FlxColor.WHITE, this, i, null, true,true);
			statsImgs[rTypes[i]].loadGraphic(AssetPaths.Wedges__png, true, 125, 125);
			statsImgs[rTypes[i]].camera = FlxG.cameras.list[2];
			statsImgs[rTypes[i]].color = cast rTypes[i];
			statsImgs[rTypes[i]].origin.x = 0;
			statsImgs[rTypes[i]].origin.y = 0;
			statsImgs[rTypes[i]].antialiasing = true;
			FlxG.state.add(statsImgs[rTypes[i]]);
			for (j in 0...ResourceTypes.types.length){
				statsImgs[rTypes[i]].animation.add(Std.string(j + 1), [j + 1], 1, false);
			}
				
			costText[rTypes[i]] = new FlxText(54 + i * 128, 50, 74, null, 20, true);
			costText[rTypes[i]].color = FlxColor.RED;
			costText[rTypes[i]].cameras = [FlxG.cameras.list[6]];
			FlxG.state.add(costText[rTypes[i]]);
			
		}
		for (i in 0...NofResources){
			statsImgs[rTypes[i]].angle = i / NofResources * 360 -135;
		}
		for (key in resources.types()){
			statsImgs[key].animation.play(Std.string(NofResources));
		}
		
		updateStatsImg();
		
		Groups.planets.add(this);
		buttonSubject.setID(getID());
	}//###  new  ###
	
	override public function update(elapsed:Float):Void
	{
		if (mousedOver)
			showResources = true;
		
		super.update(elapsed);
		if (!locked){
			if (showResources){
				if (popupResources < 10){
					popupResources += 1;
					updateStatsImg();
				}
			}else{
				if (popupResources > 0){
					popupResources -= 1;
					updateStatsImg();
				}
			}
		}
		
		if (mouseOverIDs.length==0){
			mousedOver = false;
			for (key in resources.types())
				costText[key].text = "";
		}
		showResources = false;
	}
	
	public function updateStatsImg()
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
			statsImgs[key].scale.x = 0.445/125*size* ((resources.get(key)>0?resources.get(key)+1:0) + maxResource) / maxResource * (popupResources/10);
			statsImgs[key].scale.y = statsImgs[key].scale.x;
		}
	}
	
	public function getUpgradeCost(type:FlxColor):Resources
	{
		var cost:Resources = switch (type)
		{	//							O,P,S,C,M
			case ResourceTypes.Organic:{
				resources.retMultiply([1, .5, null, null, null]);
			}
			case ResourceTypes.Productivity:{
				resources.retMultiply([.5, 1, .5, null, null]);
			}
			case ResourceTypes.Science:{
				resources.retMultiply([null, .5, 1, .5, null]);
			}
			case ResourceTypes.Credits:{
				resources.retMultiply([null, null, .5, 1, .5]);
			}
			case ResourceTypes.Materials:{
				resources.retMultiply([.5, null, null, .5, 1]);
			}
			default:null;
		}
		return cost;
	}
	
	public function upgrade(type:FlxColor)
	{
		var cost:Resources = getUpgradeCost(type);
		
		if (owners[0].resources.remove(cost)){
			switch (type)
			{	//							O,P,S,C,M
				case ResourceTypes.Organic:{
					resources.add(new Resources([1,0,0,0,0]));
				}
				case ResourceTypes.Productivity:{
					resources.add(new Resources([0,1,0,0,0]));
				}
				case ResourceTypes.Science:{
					resources.add(new Resources([0,0,1,0,0]));
				}
				case ResourceTypes.Credits:{
					resources.add(new Resources([0,0,0,1,0]));
				}
				case ResourceTypes.Materials:{
					resources.add(new Resources([-1,0,0,0,1]));
					if (resources.get(ResourceTypes.Organic) == 0)
						resources.setResource(ResourceTypes.Organic, null);
				}
				default:null;
			}
		}
		
		updateStatsImg();
		reportIncome();
		updatePlayers();
	}
	
	public function grow(growBy:Null<Float>=null)
	{
		if (growBy == null)
		{
			if (resources.get(ResourceTypes.Organic) == null)
				growth += 1;
			else
				growth += 1 + resources.get(ResourceTypes.Organic) * 20 / population();
			while (growth >= 1){
				resources.addResource(resources.types()[Std.random(resources.length())], 1);
				growth -= 1;
			}
		}else{
			while (growBy >= 1){
				resources.addResource(resources.types()[Std.random(resources.length())], 1);
				growBy -= 1;
			}
			growth += growBy;
		}
	}
	
	public function population():Int
	{
		var i:Int = 0;
		for (type in resources.types())
			i += resources.get(type);
		return i;
	}
	
	public function getOwners():Array<Player>
	{
		return owners;
	}
	public function addOwner(player:Player)
	{
		owners.push(player);
	}
	public function removeOwner(player:Player)
	{
		owners.remove(player);
	}
	
	public function upkeep()
	{
		for (owner in owners)
			if (owner!=null)
				owner.resources.add(resources);
	}
	public function reportIncome()
	{
		for (owner in owners)
			if (owner!=null)
				owner.reportIncome(this);
	}
	public function updatePlayers()
	{
		Groups.planets.updatePlayers();
	}
	
	public function point():FlxPoint
	{
		return new FlxPoint(x, y);
	}
	
	public function getID():Int
	{
		return id;
	}
	public function setID(newID:Int)
	{
		id=newID;
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
							case MouseEventType.LeftJustReleased:{
								if (buttonSubject.getID() == event.eventSource){
									mouseOverIDs = [];
									for (key in ResourceTypes.types)
										costText[key].text = "";
									this.lock();
									popupResources = 10;
									updateStatsImg();
									FlxG.state.openSubState(new PlanetMenu(FlxColor.BLACK, 0.6, this));
								}
							}
							case MouseEventType.RightJustReleased:{
							}
							case MouseEventType.MouseOver:{
								trace(event.eventSource);
								mouseOverIDs.remove(event.eventSource);
								mouseOverIDs.push(event.eventSource);
								mousedOver = true;
								if (event.eventSource < ResourceTypes.types.length)
								{
									var cost:Resources = getUpgradeCost(ResourceTypes.types[event.eventSource]);
									for (key in ResourceTypes.types)
										if (cost.get(key) != null)
											costText[key].text = "-" + Std.string(cost.get(key));
										else
											costText[key].text = "";
								}
							}
							case MouseEventType.MouseOff:{
								mouseOverIDs.remove(event.eventSource);
							}
							default:null;
						}
					}
				}
			}
			default:null;
		}
	}
}