package com.maskedpixel.mathsushi.entities.masterstates;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.entities.Customer;
import com.maskedpixel.mathsushi.entities.MasterQueue;
import com.maskedpixel.mathsushi.entities.quiz.MathProblem;

/**
 * ...
 * @author Erin M Gunn
 */

class MasterLevelFour extends MasterState
{
	static public inline var NAME:String = "MasterLevelFour";

	public function new(masterQueue:MasterQueue) 
	{
		super(masterQueue, NAME);
	}
	
	override public function enter():Void 
	{
		_masterQueue.addCustomer(ProblemDifficulty.Hard);
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (_elapsed >= 45) stateMachine.transitionToNext();
	}
	
	override public function customerLeft(c:Customer):Void 
	{
		var d:ProblemDifficulty = c.problemDef.difficulty;
		if (d == ProblemDifficulty.Easy || d == ProblemDifficulty.Medium)
			_masterQueue.addCustomer(Type.createEnumIndex(ProblemDifficulty, HXP.rand(1)));
		else
			_masterQueue.addCustomer(ProblemDifficulty.Hard);
	}
}