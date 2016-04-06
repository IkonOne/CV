package com.maskedpixel.mathsushi.entities.serverstates;

import com.haxepunk.Sfx;
import com.maskedpixel.mathsushi.entities.quiz.MathQuiz;
import com.maskedpixel.mathsushi.entities.Server;
import com.maskedpixel.util.State;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

/**
 * ...
 * @author Erin M Gunn
 */

class ServerTakeOrder extends State
{
	public var onComplete:Signaler<MathQuiz>;
	
	public var orderQuiz(default, null):MathQuiz;

	public function new(s:Server)
	{
		super(Std.string(ServerState.TakeOrder));
		_server = s;
		onComplete = new DirectSignaler(this);
		
		orderQuiz = new MathQuiz();
		orderQuiz.onComplete.bindVoid(onQuizComplete);
	}
	
	private function onQuizComplete():Void
	{
		onComplete.dispatch(this);
	}
	
	override public function enter():Void
	{
		orderQuiz.problemDef = _server.currentCustomer.problemDef;
		_server.scene.add(orderQuiz);
		
		GS.playSfx(GS.TAKE_ORDER);
	}
	
	override public function leave():Void
	{
		_server.scene.remove(orderQuiz);
	}
	
	private var _server:Server;
}