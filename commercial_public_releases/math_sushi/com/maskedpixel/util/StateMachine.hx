package com.maskedpixel.util;

//import State.FriendState;
import com.maskedpixel.util.State;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

/**
 * ...
 * @author Erin M Gunn
 */

class StateMachine extends Behaviour
{
	public var onStateChanged(default, null):Signaler<StateMachine>;
	public var currentState(default, null):State;

	public function new()
	{
		super();
		
		onStateChanged = new DirectSignaler(this);
		_states = new Hash<State>();
		_stateOrder = new Array<String>();
	}
	
	public function addState(state:State):State
	{
		if (state.stateMachine != null) return state;
		var fs:FriendState = state;
		fs._stateMachine = this;
		
		_states.set(state.name, state);
		_stateOrder.push(state.name);
		return state;
	}
	
	public function removeState(state:State):State
	{
		if (state.stateMachine != this) return state;
		var fs:FriendState = state;
		fs._stateMachine = null;
		
		_states.remove(state.name);
		_stateOrder.remove(state.name);
		return state;
	}
	
	public function transitionTo(stateName:String):State
	{
		_next == null;
		for (state in _states)
		{
			if (state.name == stateName)
			{
				_next = state;
				return _next;
			}
		}
		
		return _next;
		
	}
	
	public function transitionToNext():State
	{
		var idx:Int = Lambda.indexOf(_stateOrder, currentState.name) + 1;
		if (idx == 0 || idx == _stateOrder.length) return null;
		_next = _states.get(_stateOrder[idx]);
		return _next;
	}
	
	public function transitionToPrev():State
	{
		var idx:Int = Lambda.indexOf(_stateOrder, currentState.name) - 1;
		if (idx < 0) return null;
		_next = _states.get(_stateOrder[idx]);
		return _next;
	}
	
	override public function update():Void
	{
		if (_next != null) changeState();
		if(currentState != null) currentState.update();
	}
	
	private function changeState()
	{
		if(currentState != null) currentState.leave();
		currentState = _states.get(_next.name);
		currentState.enter();
		_next = null;
		onStateChanged.dispatch(this);
	}
	
	private var _states:Hash<State>;
	private var _stateOrder:Array<String>;
	private var _next:State;
}