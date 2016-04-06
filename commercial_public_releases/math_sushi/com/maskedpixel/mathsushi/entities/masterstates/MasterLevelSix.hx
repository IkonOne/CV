package com.maskedpixel.mathsushi.entities.masterstates;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.entities.Customer;
import com.maskedpixel.mathsushi.entities.MasterQueue;
import com.maskedpixel.mathsushi.entities.quiz.MathProblem;

/**
 * ...
 * @author Erin M Gunn
 */

class MasterLevelSix extends MasterState
{
	static public inline var NAME:String = "MasterLevelSix";

	public function new(masterQueue:MasterQueue) 
	{
		super(masterQueue, NAME);
	}
	
	override public function enter():Void 
	{
		_masterQueue.addCustomer(ProblemDifficulty.Hard);
	}
	
	override public function customerLeft(c:Customer):Void 
	{
		_masterQueue.addCustomer(c.problemDef.difficulty);
	}
	
}