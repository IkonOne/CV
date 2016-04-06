package com.maskedpixel.mathsushi.entities.masterstates;
import com.maskedpixel.mathsushi.entities.Customer;
import com.maskedpixel.mathsushi.entities.MasterQueue;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.ProblemDef;
import com.maskedpixel.mathsushi.entities.quiz.MathProblem;

/**
 * ...
 * @author Erin M Gunn
 */

class MasterLevelOne extends MasterState
{
	static public inline var NAME:String = "MasterLevelOne";

	public function new(masterQueue:MasterQueue) 
	{
		super(masterQueue, NAME);
	}
	
	override public function enter():Void 
	{
		_masterQueue.addCustomer(ProblemDifficulty.Easy);
		_masterQueue.addCustomer(ProblemDifficulty.Easy);
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (_elapsed >= 30) stateMachine.transitionToNext();
	}
	
	override public function customerLeft(c:Customer):Void 
	{
		_masterQueue.addCustomer(ProblemDifficulty.Easy);
	}
}