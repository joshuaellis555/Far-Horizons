package observer;

/**
 * ...
 * @author JoshuaEllis
 */
class Event 
{
	public var eventType:EventType;
	public var eventSource:Int;
	public function new(subject:Subject)
	{
		eventType = subject.getType();
		eventSource = subject.getID();
	}
}