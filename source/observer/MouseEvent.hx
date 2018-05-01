package observer;

import observer.Event;
import observer.EventType;

/**
 * ...
 * @author JoshuaEllis
 */
class MouseEvent extends Event 
{
	public var mouseEvents:Array<MouseEventType>;
	
	public function new(subject:Subject, events:Array<MouseEventType>)
	{
		super(subject);
		mouseEvents = events;
	}
	
}