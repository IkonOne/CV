package com.maskedpixel.mathsushi.behaviours;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.maskedpixel.util.Behaviour;
import nme.geom.Point;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

/**
 * ...
 * @author Erin M Gunn
 */

class DragObject extends Behaviour
{
	public var speed:Float = 15;
	public var attachedTo:DragTarget;
	
	public var onDragStart:Signaler<DragObject>;
	public var onDragStop:Signaler<DragObject>;
	
	public var isAttached(getIsAttached, never):Bool;
	private function getIsAttached():Bool
	{
		return attachedTo != null;
	}
	
	public var isDragging(default, setIsDragging):Bool;
	private function setIsDragging(value:Bool):Bool
	{
		if (isDragging == value) return isDragging;
		isDragging = value;
		
		if (isDragging)
		{
			onDragStart.dispatch(this);
		}
		else
		{
			onDragStop.dispatch(this);
		}
		
		return isDragging;
	}
	
	public function new()
	{
		super();
		
		onDragStart = new DirectSignaler(this);
		onDragStop = new DirectSignaler(this);
	}
	
	override public function added():Void
	{
		_prevTarget = new Point();
		_initialPos = new Point(parent.x, parent.y);
	}
	
	override public function update():Void
	{
		if (isDragging)
		{
			parent.x = HXP.lerp(parent.x, parent.scene.mouseX, HXP.elapsed * speed);
			parent.y = HXP.lerp(parent.y, parent.scene.mouseY, HXP.elapsed * speed);
		}
		else if(!isAttached)
		{
			parent.x = HXP.lerp(parent.x, _initialPos.x, HXP.elapsed * speed);
			parent.y = HXP.lerp(parent.y, _initialPos.y, HXP.elapsed * speed);
			
			if (Math.abs(parent.x - _initialPos.x) <= 1) parent.x = _initialPos.x;
			if (Math.abs(parent.y - _initialPos.y) <= 1) parent.y = _initialPos.y;
		}
		
		if (!isDragging && Input.mousePressed && parent.collidePoint(parent.x, parent.y, parent.scene.mouseX, parent.scene.mouseY))
		{
			isDragging = true;
			_prevTarget.x = parent.scene.mouseX;
			_prevTarget.y = parent.scene.mouseY;
		}
		
		if (isDragging && Input.mouseReleased)
		{
			isDragging = false;
		}
	}
	
	public function snapPosition(x:Float, y:Float)
	{
		parent.x = x;
		parent.y = y;
		
		isDragging = false;
	}
	
	public function resetPosition():Void
	{
		parent.x = _initialPos.x;
		parent.y = _initialPos.y;
		
		isDragging = false;
		attachedTo = null;
	}
	
	private var _prevTarget:Point;
	private var _initialPos:Point;
}