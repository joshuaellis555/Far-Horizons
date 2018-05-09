package resources;
import event.Event;
import flixel.util.FlxColor;
import resources.ResourceTypes;

/**
 * ...
 * @author ...
 */
class Resources implements ResourceEnabled
{
	private var ResourceMap:Map<FlxColor, Null<Int>>;
	
	public var resources:Resources;
	
	public function new(resources:Array<Null<Int>>) 
	{
		ResourceMap = new Map<FlxColor, Null<Int>>();
		for (i in 0...resources.length){
			if (resources[i]!=null)
				ResourceMap[ResourceTypes.types[i]] = resources[i];
		}
		for (i in resources.length...ResourceTypes.types.length){
			ResourceMap[ResourceTypes.types[i]] = null;
		}
		
		this.resources = this;
	}
	
	public function get(type:FlxColor):Null<Int>
	{
		return ResourceMap[type];
	}
	public function getMap():Map<FlxColor, Null<Int>>
	{
		return ResourceMap;
	}
	
	public function set(resources:Resources)
	{
		ResourceMap = resources.getMap();
	}
	public function setResource(type:FlxColor, value:Null<Int>)
	{
		ResourceMap[type] = value;
	}
	
	public function add(resources:Resources)
	{
		for (type in ResourceTypes.types)
		{
			if (ResourceMap[type] != null && resources.get(type) != null) ResourceMap[type] += resources.get(type);
			if (ResourceMap[type] > 9999) ResourceMap[type] = 9999;
		}
	}
	public function addResource(type:FlxColor, value:Int)
	{
		if (ResourceMap[type] != null) ResourceMap[type] += value;
		if (ResourceMap[type] > 9999) ResourceMap[type] = 9999;
	}
	
	public function remove(resources:Resources,?check:Bool=true,?allowNeg:Bool=false):Array<Bool>
	{
		if (allowNeg){
			for (type in ResourceTypes.types)
			{
				if (resources.get(type) == null) continue;
				if (ResourceMap[type] == null) return [false];
				ResourceMap[type] -= resources.get(type);
			}
		}else if (check){
			for (type in ResourceTypes.types)
			{
				trace(ResourceMap[type] , resources.get(type));
				if (resources.get(type) == null) continue;
				if (ResourceMap[type] == null) return [false];
				
				if (ResourceMap[type] < resources.get(type))
				{
					return [false];
				}
			}
			for (type in ResourceTypes.types)
			{
				if (resources.get(type) == null) continue;
				if (ResourceMap[type] == null) continue;
				ResourceMap[type] -= resources.get(type);
			}
		}else{
			for (type in ResourceTypes.types)
			{
				if (resources.get(type) == null) continue;
				if (ResourceMap[type] == null) return [false];
				
				if (ResourceMap[type] < resources.get(type)){
					ResourceMap[type] = 0;
				}else{
					ResourceMap[type] -= resources.get(type);
				}
			}
		}
		return [true];
	}
	public function removeResource(type:FlxColor, value:Int,?check:Bool=true,?allowNeg:Bool=false):Array<Bool>
	{
		if (ResourceMap[type] == null) return [false];
		if (allowNeg){
			ResourceMap[type] -= value;
		}else if (check){
			if (ResourceMap[type] < value)
			{
				return [false];
			}
			ResourceMap[type] -= value;
		}else{
			if (ResourceMap[type] < value){
				ResourceMap[type] = 0;
			}else{
				ResourceMap[type] -= value;
			}
		}
		return [true];
	}
	
	public function check(resources:Resources):Array<Bool>
	{
		for (type in ResourceTypes.types)
		{
			if (resources.get(type) == null) continue;
			if (ResourceMap[type] == null) return [false];
			
			if (ResourceMap[type] < resources.get(type))
			{
				return [false];
			}
		}
		return [true];
	}
	
	public function length():Int
	{
		var l = 0;
		for (key in ResourceMap.keys())
		{
			if (ResourceMap[key] != null) l += 1;
		}
		return l;
	}
	public function types():Array<FlxColor>
	{
		var a:Array<FlxColor>;
		a = [];
		for (key in ResourceTypes.types)
		{
			if (ResourceMap[key] != null) a.push(key);
		}
		return a;
	}

	public function onNotify(event:Event):Void{}
}