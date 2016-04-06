package com.maskedpixel.mathsushi.entities.customerstates;
import com.maskedpixel.mathsushi.entities.Customer;
import com.maskedpixel.util.State;

/**
 * ...
 * @author Erin M Gunn
 */

class CustomerWaitToOrder extends State
{

	public function new(n:String, c:Customer)
	{
		super(n);
	}
	
	override public function enter():Void
	{
		_customer.seat.clicked.onClicked.bindVoid(onSeatClicked);
	}
	
	private function onSeatClicked()
	{
		// Display the Menu.
	}
	
	private var _customer:Customer;
}