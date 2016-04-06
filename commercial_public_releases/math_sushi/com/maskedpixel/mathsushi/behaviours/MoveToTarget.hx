package com.maskedpixel.mathsushi.behaviours;

import com.haxepunk.HXP;
import com.maskedpixel.util.Behaviour;
import nme.geom.Point;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

/**
 * ...
 * @author Erin M Gunn
 */

class MoveToTarget extends Behaviour
{
	static public inline var NAME:String = "MoveToTarget";
	
	public var onComplete:Signaler<MoveToTarget>;
	
	public var target(default, null):Point;
	public var collisionTypes(default, null):Array<String>;
	
	public var isMoving(default, null):Bool;
	
	public var speed:Float = 100;

	public function new()
	{
		super();
		
		name = NAME;
		
		target = new Point();
		
		onComplete = new DirectSignaler(this);
	}
	
	override public function update():Void
	{
		if (!isMoving) return;
		
		var travel:Float = HXP.clamp(speed * HXP.elapsed, 0, HXP.distance(parent.x, parent.y, target.x, target.y)); // don't overshoot
		
		parent.moveTowards(target.x, target.y, travel, collisionTypes, true);
		if (Math.floor(parent.x) == Math.floor(target.x) && Math.floor(parent.y) == Math.floor(target.y))
		{
			stop();
			onComplete.dispatch(this);
		}
	}
	
	public function start(?x:Float=null, ?y:Float=null, ?s:Float=null):Void
	{
		if (x != null) target.x = x;
		if (y != null) target.y = y;
		if (s != null) speed = s;
		
		isMoving = true;
		active = true;
	}
	
	public function stop():Void
	{
		isMoving = false;
	}
}