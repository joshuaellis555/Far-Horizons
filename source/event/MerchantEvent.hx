package event;

import observer.Subject;
import resources.ResourceEnabled;
import resources.Resources;

/**
 * ...
 * @author JoshuaEllis
 */
class MerchantEvent extends Event 
{
	public var transactionType:MerchantEventType;
	public var returnCall:Null<Array<Bool>->Array<Bool>>;
	public var buyers:Array<ResourceEnabled>;
	public var sellers:Array<ResourceEnabled>;
	
	public function new(subject:Subject, type:MerchantEventType, ?buyers:Array<ResourceEnabled>, ?sellers:Array<ResourceEnabled>, ?ret:Null<Array<Bool>->Array<Bool>> = null)
	{
		super(subject.getID(), EventType.Merchant);
		this.sellers = sellers;
		this.buyers = buyers;
		transactionType = type;
		returnCall = ret;
	}
	
}