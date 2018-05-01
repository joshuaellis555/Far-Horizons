package event;

import event.MouseEventType;
import event.Event;
import event.EventType;
import observer.Subject;

/**
 * ...
 * @author JoshuaEllis
 */
class MouseEvent extends Event 
{
	public var mouseEvents:Array<MouseEventType>;
	
	public function new(subject:Subject, events:Array<MouseEventType>, ?id:Int=0)
	{
		super(id,EventType.Mouse);
		mouseEvents = events;
	}
	
}