package com.maskedpixel.mathsushi.entities.serverstates;

import com.haxepunk.HXP;
import com.haxepunk.masks.Hitbox;
import com.haxepunk.World;
import com.haxepunk.Entity;
import com.maskedpixel.mathsushi.behaviours.MoveToTarget;
import com.maskedpixel.mathsushi.entities.PrepStation;
import com.maskedpixel.mathsushi.entities.Seat;
import com.maskedpixel.mathsushi.entities.Server;
import com.maskedpixel.mathsushi.entities.Server.ServerState;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.util.State;
import com.maskedpixel.mathsushi.behaviours.Clicked;
import com.maskedpixel.util.StateMachine;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

/**
 * ...
 * @author Erin M Gunn
 */

class ServerMove extends State
{
	public var onComplete:Signaler<ServerMove>;
	public var onTargetChanged:Signaler<ServerMove>;
	public var target(default, null):Entity;
	
	public function new(s:Server)
	{
		super(Std.string(ServerState.Move));
		
		_server = s;
		
		onComplete = new DirectSignaler(this);
		onTargetChanged = new DirectSignaler(this);
		
		_hitBox = new Hitbox(HXP.width, HXP.height);
		
		_move = cast _server.addBehaviour(new MoveToTarget());
		_move.onComplete.bindVoid(onMoveComplete);
		_move.active = false;
		_clicked = cast _server.addBehaviour(new Clicked());
		_clicked.onClicked.bindVoid(onClicked);
		_clicked.active = false;
	}
	
	override public function enter():Void
	{
		_move.active = true;
		_clicked.active = true;
		_server.mask = _hitBox;
	}
	
	override public function leave():Void
	{
		_move.active = false;
		_clicked.active = false;
		_server.mask = null;
	}
	
	override public function update():Void
	{
		_hitBox.x = cast -_server.x;
		_hitBox.y = cast -_server.y;
	}
	
	public function moveToTarget(t:Entity):Void
	{
		_move.start(t.x, _server.y, G.PLAYER_SPEED);
		target = t;
		onTargetChanged.dispatch(this);
	}
	
	private function onClicked():Void
	{
		if (_server.scene == null) return;
		var seat:Seat = cast _server.scene.collidePoint(G.TYPE_SEAT, _server.scene.mouseX, _server.scene.mouseY);
		if (seat != null)
		{
			if (_move.target.x == seat.x)
			{
				_server.performAction();
				return;
			}
			_server.moveToTarget(seat, true);
		}
		
		var prep:PrepStation = cast _server.scene.collidePoint(G.TYPE_PREP_STATION, _server.scene.mouseX, _server.scene.mouseY);
		if (prep != null)
		{
			if (_move.target.x == prep.x)
			{
				_server.performAction();
				return;
			}
			_server.moveToTarget(prep, true);
		}
	}
	
	private function onMoveComplete():Void
	{
		onComplete.dispatch(this);
	}
	
	private var _hitBox:Hitbox;
	private var _move:MoveToTarget;
	private var _clicked:Clicked;
	
	private var _server:Server;
}