package player;

import cameras.Cameras;
import event.Event;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import observer.Observer;
import observer.Subject;
import groups.Players;
import planets.Planet;
import resources.ResourceEnabled;
import resources.ResourceTypes;
import resources.Resources;
import flixel.input.gamepad.FlxGamepad;
import groups.Groups;


/**
 * ...
 * @author ...
 */
class Player extends FlxSprite implements ResourceEnabled
{
	public var income:Resources = new Resources([0, 0, 0, 0, 0, 0, 0, 0]);
	private var incomeSources:Map<Int,Resources>=new Map<Int,Resources>();
	
	public var resources:Resources;
	
	public var ownedPlanets:Array<Planet> = [];
	
	private var id:Int;
	
	private var target:Null<Planet>=null;
	private var tIndex:Null<Int>=null;
	
	//private var gamepad:FlxGamepad;
	private var stickActive:Float=0.0;
	
	public function new(resources:Resources) 
	{
		super(0, 0);
		this.loadGraphic(AssetPaths.Cursor__png, false, 401, 401);
		this.color = FlxColor.RED;
		this.camera = Cameras.cursorCam.flxCam();
		this.resources = resources;
		
		var players:Players = new Players();
		players.add(this);
		
	}
	public function updateIncome()
	{
		income = new Resources([0, 0, 0, 0, 0, 0, 0, 0]);
		for (key in incomeSources.keys())
		{
			income.add(incomeSources[key]);
		}
		
	}
	public function reportIncome(planet:Planet)
	{
		incomeSources[planet.getID()] = planet.resources;
	}
	public function getID():Int
	{
		return id;
	}
	public function setID(newID:Int)
	{
		id = newID;
	}
	
	override public function update(elapsed:Float):Void 
    {
        super.update(elapsed);

        // Important: can be null if there's no active gamepad yet!
        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
        if (gamepad != null)
        {
            updateGamepadInput(gamepad);
        }
		if (target != null){
			this.visible = true;
			this.x = target.getMidpoint().x;
			this.y = target.getMidpoint().y;
			this.scale = new FlxPoint(target.scale.x*.88,target.scale.y*.88);
			this.offset = new FlxPoint(this.width / 2, this.height / 2);
			target.showResources = true;
			target.focused = true;
		} else {
			this.visible = false;
		}
    }
	
	function updateGamepadInput(gamepad:FlxGamepad):Void
    {
        if (gamepad.justPressed.A)
        {
            trace("The bottom face button of the controller is pressed.");
        }
		
		var leftStickPoint = new FlxPoint(gamepad.analog.value.LEFT_STICK_X, gamepad.analog.value.LEFT_STICK_Y);
		var zeroPoint = new FlxPoint(0, 0);
		
		//trace(stickActive);
		//trace(leftStickPoint.distanceTo(zeroPoint));
        if (stickActive<1 && leftStickPoint.distanceTo(zeroPoint)>0.30)
        {
			/*
			var change:Int =-1;
            if (gamepad.analog.value.LEFT_STICK_X > 0){
				change = 1;
			}
			if (tIndex != null){
				tIndex = FlxMath.minInt(FlxMath.maxInt(tIndex + change, 0), Groups.planets.all().length - 1);
			} else {
				tIndex = 0;
			}
			target = Groups.planets.all()[tIndex];
			*/
		
			if (target == null){
				if (Groups.planets.all().length>0)
					target = Groups.planets.all()[0];
			} else {		
				var newBest:Null<Planet> = null;
				if (leftStickPoint.distanceTo(zeroPoint) > .2)
				{
					//trace(leftStickPoint.distanceTo(zeroPoint));
					var angle:Float = zeroPoint.angleBetween(leftStickPoint);
					//trace(angle);
					var best:Null<Float>=null;
					for (planet in Groups.planets.all()){
						if (best == null && planet.getID() != target.getID()){
							var delta = Math.abs(angle-target.point().angleBetween(planet.point()));
							if (delta > 180) delta = 360 - delta;
							if (delta<=55){
								best = Math.pow(target.point().distanceTo(planet.point()),2) * (Math.max(4,delta)+100);
								newBest = planet;
							}
						} else {
							if (planet.getID() != target.getID()){
								var delta = Math.abs(angle-target.point().angleBetween(planet.point()));
								var test = Math.pow(target.point().distanceTo(planet.point()),2) * (Math.max(4,delta)+100);
								if (test < best && delta<=55){
									best = test;
									newBest = planet;
								}
							}
						}
					}
					if (newBest != null){
						//trace('new angle');
						//trace(target.point().angleBetween(newBest.point()));
						var delta = Math.abs(angle-target.point().angleBetween(newBest.point()));
						//trace('delta');
						//trace(delta);
						if (delta > 180) delta = 360 - delta;
						//trace('delta');
						//trace(delta);
						//trace('dist');
						//trace(Math.pow(target.point().distanceTo(newBest.point()), 2));
						//trace(Math.pow(target.point().distanceTo(newBest.point()), 2) * (Math.max(4, delta)+100));
						target = newBest;
					}
				}
			}
			stickActive = 17;
		}
		stickActive -= 1;
    }
}