package com.maskedpixel.mathsushi.entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.tweens.misc.Alarm;
import com.maskedpixel.mathsushi.G;
import com.haxepunk.Tween;

/**
 * ...
 * @author Erin M Gunn
 */

class CustomerQueue extends Entity
{
	public var served(default, null):Int;
	public var customers(default, null):Array<Customer>;
	
	public var activeCustomers(default, setActiveCustomers):Int;
	private function setActiveCustomers(value:Int):Int
	{
		if (activeCustomers == value) return activeCustomers;
		activeCustomers = cast HXP.clamp(value, 0, customers.length);
		var diff:Int = HXP.sign(_addedCustomers.length - activeCustomers);
		if (activeCustomers > _addedCustomers.length)
		{
			var i:Int;
			// Add customers.
			while (activeCustomers > _addedCustomers.length)
			{
				i = 0;
				while (Lambda.has(_addedCustomers, customers[i])) i++;
				_addedCustomers.push(customers[i]);
			}
			scene.addList(cast _addedCustomers);
		}
		
		return activeCustomers;
	}

	public function new()
	{
		super();
		
		customers = new Array<Customer>();
		_addedCustomers = new Array<Customer>();
		type = G.TYPE_CUSTOMER_QUEUE;
		name = G.NAME_CUSTOMER_QUEUE;
		
		var c:Customer;
		for (i in 0...G.NUM_SEATS)
		{
			c = new Customer();
			c.onLeft.bind(onCustomerLeft);
			c.onBilled.bindVoid(onCustomerBilled);
			customers.push(c);
		}
	}
	
	override public function added():Void
	{
		activeCustomers = cast G.NUM_SEATS / 2;
		_addedCustomers[0].enterImmediately = true;
		
		_busyAlarm = new Alarm(HXP.rand(cast G.SHIFT_DURATION / 20) + G.SHIFT_DURATION / 20, onBusyAlarm, TweenType.Looping);
		addTween(_busyAlarm, true);
		
		served = 0;
	}
	
	public function onBusyAlarm(e:Dynamic):Void
	{
		activeCustomers = cast HXP.rand(cast G.NUM_SEATS / 3) + G.NUM_SEATS / 2;
		_busyAlarm.reset(HXP.rand(cast G.SHIFT_DURATION / 20) + G.SHIFT_DURATION / 20);
	}
	
	private function onCustomerBilled():Void
	{
		served++;
	}
	
	private function onCustomerLeft(c:Customer):Void
	{
		if (activeCustomers < _addedCustomers.length)
		{
			_addedCustomers.remove(c);
		}
		c.added();
	}
	
	private var _addedCustomers:Array<Customer>;
	private var _busyAlarm:Alarm;
}