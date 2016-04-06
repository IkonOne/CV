package com.maskedpixel.mathsushi.entities.customerstates;

import com.haxepunk.HXP;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.Tween;
import com.maskedpixel.mathsushi.entities.Customer;
import com.maskedpixel.mathsushi.entities.Customer.CustomerState;
import com.maskedpixel.util.State;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

/**
 * ...
 * @author Erin M Gunn
 */

class CustomerEating extends State
{
	public var onComplete(default, null):Signaler<CustomerEating>;
	public var eatTime:Float = 1;

	public function new(c:Customer)
	{
		super(Std.string(CustomerState.Eating));
		_customer = c;
		
		_alarm = new Alarm(eatTime, onAlarm, TweenType.OneShot);
		onComplete = new DirectSignaler(this);
	}
	
	override public function enter():Void
	{
		_stateMachine.parent.addTween(_alarm);
		_alarm.reset(eatTime);
	}
	
	override public function leave():Void
	{
		if(_alarm.active) _stateMachine.parent.removeTween(_alarm);
	}
	
	private function onAlarm(e:Dynamic):Void
	{
		onComplete.dispatch(this);
	}
	
	private var _customer:Customer;
	private var _alarm:Alarm;
}