package com.maskedpixel.mathsushi.entities.serverstates;

import com.maskedpixel.mathsushi.entities.quiz.MathQuiz;
import com.maskedpixel.util.State;
import com.maskedpixel.mathsushi.entities.Server;
import com.maskedpixel.mathsushi.entities.Server.ServerState;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

/**
 * ...
 * @author Erin M Gunn
 */

class ServerBilling extends State
{
	public var onComplete(default, null):Signaler<ServerBilling>;
	public var billQuiz(default, null):MathQuiz;

	public function new(s:Server)
	{
		super(Std.string(ServerState.Billing));
		_server = s;
		
		onComplete = new DirectSignaler(this);
		
		billQuiz = new MathQuiz();
		billQuiz.onComplete.bindVoid(onQuizComplete);
	}
	
	override public function enter():Void
	{
		billQuiz.problemDef = _server.currentCustomer.problemDef;
		_server.scene.add(billQuiz);
	}
	
	override public function leave():Void
	{
		_server.scene.remove(billQuiz);
	}
	
	private function onQuizComplete():Void
	{
		onComplete.dispatch(this);
	}
	
	private var _server:Server;
}