package com.maskedpixel.mathsushi.entities.serverstates;

import com.haxepunk.Sfx;
import com.maskedpixel.mathsushi.entities.Server;
import com.maskedpixel.mathsushi.entities.quiz.MathQuiz;
import com.maskedpixel.util.State;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

/**
 * ...
 * @author Erin M Gunn
 */

class ServerPrepFood extends State
{
	public var onComplete(default, null):Signaler<MathQuiz>;
	
	public var prepQuiz(default, null):MathQuiz;

	public function new(s:Server)
	{
		super(Std.string(ServerState.PrepFood));
		_server = s;
		
		onComplete =  new DirectSignaler(this);
		
		prepQuiz = new MathQuiz();
		prepQuiz.onComplete.bindVoid(onQuizComplete);
	}
	
	override public function enter():Void
	{
		prepQuiz.problemDef = _server.currentCustomer.problemDef;
		_server.scene.add(prepQuiz);
		GS.playSfx(GS.CHOP_CHOP);
	}
	
	override public function leave():Void
	{
		_server.scene.remove(prepQuiz);
	}
	
	private function onQuizComplete():Void
	{
		onComplete.dispatch(prepQuiz);
	}
	
	private var _server:Server;
}