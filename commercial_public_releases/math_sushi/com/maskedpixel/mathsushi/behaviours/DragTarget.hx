package com.maskedpixel.mathsushi.behaviours;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.maskedpixel.util.Behaviour;
import nme.events.Event;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

/**
 * ...
 * @author Erin M Gunn
 */

class DragTarget extends Behaviour
{
	
	public var onDragEnter:Signaler<DragTarget>;
	public var onDragLeave:Signaler<DragTarget>;
	public var onDragDropped:Signaler<DragObject>;
	
	public function new()
	{
		super();
		
		_objects = new Array<DragObject>();
		_dragged = new Array<DragObject>();
		_entered = new Array<DragObject>();
		
		onDragEnter = new DirectSignaler(this);
		onDragLeave = new DirectSignaler(this);
		onDragDropped = new DirectSignaler(this);
	}
	
	override public function update():Void
	{
		for (obj in _dragged)
		{
			if (parent.collidable && parent.collideWith(obj.parent, parent.x, parent.y) != null)
			{
				if(!Lambda.has(_entered, obj))
				{
					_entered.push(obj);
					onDragEnter.dispatch(this);
				}
			}
			else if (Lambda.has(_entered, obj))
			{
				_entered.remove(obj);
				if (obj.attachedTo == this)
				{
					obj.attachedTo = null;
				}
				onDragLeave.dispatch(this);
			}
		}
	}
	
	public function addObject(obj:DragObject):DragObject
	{
		_objects.push(obj);
		obj.onDragStart.bind(onObjectDragStart);
		obj.onDragStop.bind(onObjectDragStop);
		return obj;
	}
	
	public function removeObject(obj:DragObject):DragObject
	{
		_objects.remove(obj);
		obj.onDragStart.unbind(onObjectDragStart);
		obj.onDragStop.unbind(onObjectDragStop);
		obj.resetPosition();
		return obj;
	}
	
	public function addList(array:Array<DragObject>):Void
	{
		for (dt in array)
		{
			addObject(dt);
		}
	}
	
	public function removeList(array:Array<DragObject>):Void
	{
		for (dt in array)
		{
			removeObject(dt);
		}
	}
	
	public function removeAll():Void
	{
		for (obj in _objects)
		{
			removeObject(obj);
		}
	}
	
	public function releaseAll():Void
	{
		for (obj in _objects)
		{
			if (obj.attachedTo == this)
			{
				obj.attachedTo = null;
			}
		}
	}
	
	private function onObjectDragStart(obj:DragObject):Void
	{
		_dragged.push(obj);
	}
	
	private function onObjectDragStop(obj:DragObject):Void
	{
		_dragged.remove(obj);
		
		if (Lambda.has(_entered, obj) && active && parent.active && parent.collidePoint(parent.x, parent.y, parent.scene.mouseX, parent.scene.mouseY))
		{
			obj.snapPosition(parent.x, parent.y);
			obj.attachedTo = this;
			onDragDropped.dispatch(obj);
		}
	}
	
	private var _objects:Array<DragObject>;
	private var _dragged:Array<DragObject>;
	private var _entered:Array<DragObject>;
}