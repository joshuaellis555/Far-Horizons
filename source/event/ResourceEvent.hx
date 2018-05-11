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
	
	public function new(subject:Subject,resources:Resources, type:ResourceEventType) 
	{
		super(subject.getID(),EventType.Resource);
		this.resources = resources;
		transactionType = type;
	}
	
}