package com.maskedpixel.util;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.maskedpixel.util.Behaviour;
import com.haxepunk.Graphic;
import com.haxepunk.Mask;

/**
 * ...
 * @author Erin M Gunn
 */

class BehaviourEntity extends Entity
{

	public function new(x:Float = 0, y:Float = 0, graphic:Graphic = null, mask:Mask = null)
	{
		super(x, y, graphic, mask);
		_add = new Array<Behaviour>();
		_remove = new Array<Behaviour>();
		_behaviourNames = new Hash<Behaviour>();
	}
	
	override public function update():Void
	{
		var b:Behaviour,
			fb:FriendBehaviour = _updateFirst;
		while (fb != null)
		{
			b = cast(fb, Behaviour);
			if (b.active)
			{
				b.update();
			}
			fb = fb._updateNext;
		}
		updateLists();
	}
	
	public function addBehaviour(b:Behaviour):Behaviour
	{
		var fb:FriendBehaviour = b;
		if (fb._entity != null) return b;
		_add.push(b);
		fb._added = true;
		return b;
	}
	
	public function removeBehaviour(b:Behaviour):Behaviour
	{
		var fb:FriendBehaviour = b;
		if (fb._entity != this) return b;
		_remove.push(b);
		fb._added = false;
		return b;
	}
	
	public function removeAll():Void
	{
		var b:Behaviour,
			fb:FriendBehaviour = _updateFirst;
		while (fb != null)
		{
			b = cast(fb, Behaviour);
			_remove.push(b);
			fb._entity = null;
			fb = fb._updateNext;
		}
	}
	
	public function addList(list:Array<Behaviour>)
	{
		var b:Behaviour;
		for (b in list) addBehaviour(b);
	}
	
	public function removeList(list:Array<Behaviour>)
	{
		var b:Behaviour;
		for (b in list) removeBehaviour(b);
	}
	
	public function getInstance(name:String):Behaviour
	{
		return _behaviourNames.get(name);
	}
	
	public function getClass<B:Behaviour>(c:Class<B>, into:Array<B>):Void
	{
		var fb:FriendBehaviour = _updateFirst,
			n:Int = into.length;
		while (fb != null)
		{
			if (Std.is(fb, c))
				into[n++] = cast fb;
			fb = fb._updateNext;
		}
	}
	
	public function updateLists()
	{
		var b:Behaviour;
		var fb:FriendBehaviour;
		
		// remove behaviours
		if (_remove.length > 0)
		{
			for (b in _remove)
			{
				fb = b;
				if (fb._added != true && Lambda.indexOf(_add, b) >= 0)
				{
					_add.splice(Lambda.indexOf(_add, b), 1);
					continue;
				}
				fb._added = false;
				b.removed();
				fb._entity = null;
				removeUpdate(b);
			}
			HXP.clear(_remove);
		}
		
		// add behaviours
		if (_add.length > 0)
		{
			for (b in _add)
			{
				fb = b;
				fb._entity = this;
				addUpdate(b);
				b.added();
			}
			HXP.clear(_add);
		}
	}
	
	public function registerName(behaviour:Behaviour)
	{
		var fb:FriendBehaviour = behaviour;
		_behaviourNames.set(fb._name, behaviour);
	}
	
	public function unregisterName(behaviour:Behaviour)
	{
		var fb:FriendBehaviour = behaviour;
		_behaviourNames.remove(fb._name);
	}
	
	private function addUpdate(b:Behaviour)
	{
		var fb:FriendBehaviour = b;
		
		if (_updateFirst != null)
		{
			_updateFirst._updatePrev = b;
			fb._updateNext = _updateFirst;
		}
		else fb._updateNext = null;
		fb._updatePrev = null;
		_updateFirst = b;
		registerName(b);
		_count++;
	}
	
	private function removeUpdate(b:Behaviour)
	{
		var fb:FriendBehaviour = b;
		
		if (_updateFirst == b) _updateFirst = fb._updateNext;
		if (fb._updateNext != null) fb._updateNext._updatePrev = fb._updatePrev;
		if (fb._updatePrev != null) fb._updatePrev._updateNext = fb._updateNext;
		fb._updateNext = fb._updatePrev = null;
		unregisterName(b);
		_count--;
	}
	
	// Update information
	private var _updateFirst:FriendBehaviour;
	private var _count:Int;
	private var _add:Array<Behaviour>;
	private var _remove:Array<Behaviour>;
	
	// Render information
	private var _renderFirst:FriendBehaviour;
	
	private var _behaviourNames:Hash<Behaviour>;
}