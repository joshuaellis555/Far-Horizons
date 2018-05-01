package event;
import event.EventType;
import observer.Subject;

/**
 * ...
 * @author JoshuaEllis
 */
class Event 
{
	public var eventType:EventType;
	public var eventSource:Int;
	public function new(id:Int,type:EventType)
	{
		eventType = type;
		eventSource = id;
	}
}