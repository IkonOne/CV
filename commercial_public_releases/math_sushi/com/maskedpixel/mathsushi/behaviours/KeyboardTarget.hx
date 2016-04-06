package com.maskedpixel.mathsushi.behaviours;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.maskedpixel.mathsushi.entities.Seat;
import com.maskedpixel.mathsushi.entities.Server;
import com.maskedpixel.mathsushi.entities.serverstates.ServerMove;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.util.Behaviour;

/**
 * ...
 * @author Erin M Gunn
 */

class KeyboardTarget extends Behaviour
{
	static private inline var left:String = "left";
	static private inline var right:String = "right";

	public function new(server:Server)
	{
		super();
		
		_server = server;
		_move = cast _server.getInstance(MoveToTarget.NAME);
		
		Input.define(left, [Key.A, Key.LEFT]);
		Input.define(right, [Key.D, Key.RIGHT]);
	}
	
	override public function update():Void
	{
		if (_seats == null)
		{
			var temp:Array<Seat> = new Array<Seat>();
			_server.scene.getClass(Seat, temp);
			_seats = cast temp;
			_seats.push(_server.scene.getInstance(G.NAME_PREP_STATION));
			_seats.sort(function(a:Entity, b:Entity):Int {
				return cast a.x - b.x;
			});
			_currentSeat = Lambda.indexOf(_seats, _server.scene.getInstance(G.NAME_PREP_STATION));
			_server.x = _seats[_currentSeat].x;
			
			_move = cast _server.getInstance(MoveToTarget.NAME);
			_server.moveState.onTargetChanged.bindVoid(targetChanged);
		}
		
		if (!_move.active) return;
		
		if (Input.check(left) && Math.floor(_server.x) <= Math.floor(_seats[_currentSeat].x))
		{
			_currentSeat = cast HXP.clamp(_currentSeat - 1, 0, _seats.length - 1);
			_server.moveToTarget(_seats[_currentSeat]);
		}
		
		if (Input.check(right) && Math.floor(_server.x) >= Math.floor(_seats[_currentSeat].x))
		{
			_currentSeat = cast HXP.clamp(_currentSeat + 1, 0, _seats.length - 1);
			_server.moveToTarget(_seats[_currentSeat]);
		}
		
		if (Input.pressed(Key.SPACE) && !_move.isMoving)
		{
			_server.performAction();
		}
	}
	
	private function targetChanged():Void
	{
		_currentSeat = Lambda.indexOf(_seats, _server.moveState.target);
	}
	
	private var _server:Server;
	private var _serverMove:ServerMove;
	private var _move:MoveToTarget;
	private var _seats:Array<Entity>;
	private var _currentSeat:Int;
}