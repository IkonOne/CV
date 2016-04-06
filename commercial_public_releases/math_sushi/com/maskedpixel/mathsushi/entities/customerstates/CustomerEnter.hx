package com.maskedpixel.mathsushi.entities.customerstates;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.entities.Customer;
import com.maskedpixel.mathsushi.entities.Customer.CustomerState;
import com.maskedpixel.mathsushi.entities.Seat;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.util.State;

/**
 * ...
 * @author Erin M Gunn
 */

class CustomerEnter extends State
{

	public function new(c:Customer)
	{
		super(Std.string(CustomerState.Entering));
		_customer = c;
	}
	
	override public function enter():Void
	{
		var seats:Array<Seat> = new Array<Seat>();
		_customer.scene.getType(G.TYPE_SEAT, cast seats);
		var target:Seat;
		do
		{
			target = HXP.choose(seats);
		} while (target.customer != null);
		_customer.seat = target;
		
		_customer.x = _customer.seat.x;
		_customer.y = HXP.height + _customer.seat.height;
		_customer.move.start(_customer.seat.x, _customer.seat.y - _customer.height - 20);
		//_customer.move.start(_customer.seat.x, _customer.seat.y);
		_customer.move.onComplete.bindVoid(onMoveComplete);
	}
	
	override public function leave():Void
	{
		_customer.move.active = false;
	}
	
	private function onMoveComplete():Void
	{
		_customer.move.onComplete.unbindVoid(onMoveComplete);
		
		_stateMachine.transitionToNext();
	}
	
	private var _customer:Customer;
}