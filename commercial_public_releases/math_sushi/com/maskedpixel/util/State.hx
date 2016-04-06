package com.maskedpixel.util;

/**
 * ...
 * @author Erin M Gunn
 */

typedef FriendState =
{
	private var _stateMachine:StateMachine;
}

class State
{
	public var name(default, null):String;
	
	public var stateMachine(getStateMachine, never):StateMachine;
	private function getStateMachine():StateMachine
	{
		return _stateMachine;
	}

	public function new(name:String)
	{
		this.name = name;
	}
	
	public function enter():Void
	{
		
	}
	
	public function update():Void
	{
		
	}
	
	public function leave():Void
	{
		
	}
	
	private var _stateMachine:StateMachine;
}