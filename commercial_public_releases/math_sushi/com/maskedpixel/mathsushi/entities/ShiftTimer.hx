package com.maskedpixel.mathsushi.entities;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.Alarm;
import com.maskedpixel.mathsushi.G;

import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

/**
 * ...
 * @author Erin M Gunn
 */

class ShiftTimer extends Entity
{
	public var onShiftOver(default, null):Signaler<ShiftTimer>;
	
	public var timeString(getTimeString, null):String;
	private function getTimeString():String
	{
		var time:Float = G.SHIFT_DURATION * (1 - _alarm.percent);
		var minutes:Int = Math.floor(time / 60);
		var seconds:Int = Math.floor(time - (minutes * 60));
		
		return Std.string(minutes) + ":" + (seconds < 10 ? "0" : "") + Std.string(seconds);
	}
	
	public var percentage(getPercentage, null):Float;
	private function getPercentage():Float
	{
		return _alarm.percent;
	}

	public function new()
	{
		super();
		
		onShiftOver = new DirectSignaler(this);
		_alarm = new Alarm(G.SHIFT_DURATION, onAlarm, TweenType.OneShot);
	}
	
	override public function added():Void
	{
		addTween(_alarm, true);
	}
	
	override public function removed():Void
	{
		removeTween(_alarm);
	}
	
	private function onAlarm(e:Dynamic):Void
	{
		onShiftOver.dispatch(this);
	}
	
	private var _alarm:Alarm;
}