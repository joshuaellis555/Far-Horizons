package player;

/**
 * ...
 * @author ...
 */
class Resources 
{
	private var ResourceMap:Map<ResourceTypes, Null<Int>>;
	
	public function new(?manpower:Null<Int> = null, ?natural:Null<Int> = null, ?science:Null<Int> = null, ?minerals:Null<Int> = null, ?credits:Null<Int> = null) 
	{	
		ResourceMap = [ResourceTypes.Manpower => manpower, ResourceTypes.Natural => natural, ResourceTypes.Science => science, ResourceTypes.Minerals => minerals, ResourceTypes.Credits => credits];
	}
	public function get(type:ResourceTypes):Null<Int>
	{
		return ResourceMap[type];
	}
	public function add(resources:Resources)
	{
		for (type in Type.allEnums(ResourceTypes))
		{
			ResourceMap[type] += resources.get(type);
		}
	}
	public function addResource(type:ResourceTypes, value:Int)
	{
		ResourceMap[type] += value;
	}
	public function remove(resources:Resources):Bool
	{
		for (type in Type.allEnums(ResourceTypes))
		{
			if (ResourceMap[type] < resources.get(type))
			{
				return false;
			}
		}
		for (type in Type.allEnums(ResourceTypes))
		{
			ResourceMap[type] -= resources.get(type);
		}
		return true;
	}
	public function removeResource(type:ResourceTypes, value:Int):Bool
	{
		if (ResourceMap[type] < value)
		{
			return false;
		}
		ResourceMap[type] -= value;
		return true;
	}
}