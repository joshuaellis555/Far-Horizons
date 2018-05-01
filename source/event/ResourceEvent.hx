package event;

import observer.Subject;
import resources.Resources;

/**
 * ...
 * @author JoshuaEllis
 */
class ResourceEvent extends Event 
{
	public var resources:Resources;
	public var transactionType:ResourceEventType;
	public var returnCall:Null<Bool->Bool>;
	
	public function new(rresources:Resources, type:ResourceEventType, ?ret:Null<Bool->Bool>=null, ?id:Int=0) 
	{
		super(id,EventType.Resource);
		resources = rresources;
		transactionType = type;
		returnCall = ret;
	}
	
}