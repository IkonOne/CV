package com.maskedpixel.util;
import com.haxepunk.HXP;

/**
 * ...
 * @author Erin M Gunn
 */

/**
 * Friend class used by Behaviours
 */
typedef FriendBehaviour = {
	private var _name:String;
	private var _entity:BehaviourEntity;
	private var _added:Bool;

	private var _updatePrev:FriendBehaviour;
	private var _updateNext:FriendBehaviour;
	private var _renderPrev:FriendBehaviour;
	private var _renderNext:FriendBehaviour;
}

class Behaviour
{
	public var name(getName, setName):String;
	private function getName():String { return _name; }
	private function setName(value:String):String
	{
		if (_name == value) return _name;
		if (!_added)
		{
			_name = value;
			return _name;
		}
		if (_name != "") _entity.unregisterName(this);
		_name = value;
		if (_name != "") _entity.registerName(this);
		return _name;
	}
	
	public var active(default, setActive):Bool = true;
	private function setActive(value:Bool):Bool
	{
		if (value == active) return active;
		active = value;
		active ? activated() : deactivated();
		return active;
	}
	
	public var parent(getParent, null):BehaviourEntity;
	private function getParent():BehaviourEntity
	{
		return _entity;
	}
	
	public function new()
	{
		
	}
	
	public function activated():Void
	{
		
	}
	
	public function deactivated():Void
	{
		
	}
	
	public function added():Void
	{
		
	}
	
	public function update():Void
	{
		
	}
	
	public function lateUpdate():Void
	{
		
	}
	
	public function removed():Void
	{
		
	}
	
	// Behaviour information.
	private var _name:String;
	private var _entity:BehaviourEntity;
	private var _added:Bool;

	private var _updatePrev:FriendBehaviour;
	private var _updateNext:FriendBehaviour;
	private var _renderPrev:FriendBehaviour;
	private var _renderNext:FriendBehaviour;
	
}