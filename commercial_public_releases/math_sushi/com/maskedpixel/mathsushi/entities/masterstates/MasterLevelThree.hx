package com.maskedpixel.mathsushi.entities.masterstates;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.entities.Customer;
import com.maskedpixel.mathsushi.entities.MasterQueue;
import com.maskedpixel.mathsushi.entities.quiz.MathProblem;

/**
 * ...
 * @author Erin M Gunn
 */

class MasterLevelThree extends MasterState
{
	static public inline var NAME:String = "MasterLevelThree";

	public function new(masterQueue:MasterQueue) 
	{
		super(masterQueue, NAME);
	}
	
	override public function enter():Void 
	{
		super.enter();
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (_elapsed >= 45) stateMachine.transitionToNext();
	}
	
	override public function customerLeft(c:Customer):Void 
	{
		_masterQueue.addCustomer(c.problemDef.difficulty);
	}
}