package observer;

/**
 * ...
 * @author JoshuaEllis
 */
class Event 
{
	public var eventType:EventType;
	public var eventSource:Int;
	public function new(source:Int,type:EventType)
	{
		eventType = type;
		eventSource = source;
	}
}