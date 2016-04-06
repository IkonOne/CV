package com.maskedpixel.mathsushi.entities.customerstates;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.behaviours.MoveToTarget;
import com.maskedpixel.util.State;
import com.maskedpixel.mathsushi.entities.Customer;
import com.maskedpixel.mathsushi.entities.Customer.CustomerState;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

/**
 * ...
 * @author Erin M Gunn
 */

class CustomerLeave extends State
{
	public var onComplete(default, null):Signaler<CustomerLeave>;

	public function new(c:Customer)
	{
		super(Std.string(CustomerState.Leaving));
		_customer = c;
		onComplete = new DirectSignaler(this);
	}
	
	override public function enter():Void
	{
		_customer.move.active = true;
		_customer.move.start(_customer.x, HXP.height + _customer.height);
		_customer.move.onComplete.bindVoid(onMoveComplete);
	}
	
	override public function leave():Void
	{
		_customer.move.active = false;
	}
	
	private function onMoveComplete():Void
	{
		_customer.move.onComplete.unbindVoid(onMoveComplete);
		onComplete.dispatch(this);
	}
	
	private var _customer:Customer;
	private var _move:MoveToTarget;
}