package com.maskedpixel.mathsushi;

import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.entities.quiz.MathProblem;
import haxe.EnumFlags;

/**
 * ...
 * @author Erin M Gunn
 */

class ProblemDef
{
	public var difficulty:ProblemDifficulty;
	public var operator:EnumFlags<ProblemOp>;
	
	public function new()
	{
		difficulty = ProblemDifficulty.Easy;
		
		operator.init();
		operator.set(ProblemOp.Addition);
	}
	
	public function chooseOperator():ProblemOp
	{
		var pick:Int;
		var bit:Int;
		do
		{
			pick = HXP.rand(4);
			bit = 1 << pick;
		} while (operator.toInt() & bit != bit);
		return Type.createEnumIndex(ProblemOp, pick);
	}
	
	static public function fromXml(xml:Xml):ProblemDef
	{
		var def:ProblemDef = new ProblemDef();
		
		def.difficulty = xml.exists("difficulty") ? Type.createEnum(ProblemDifficulty, xml.get("difficulty")) : G.PROBLEM_DEF.difficulty;
		if (xml.exists("operators"))
		{
			def.operator.init();
			var ops:Array<String> = xml.get("operators").split(";");
			for (op in ops)
			{
				def.operator.set(Type.createEnum(ProblemOp, op));
			}
		}
		else
		{
			def.operator = G.PROBLEM_DEF.operator;
		}
		
		return def;
	}
}