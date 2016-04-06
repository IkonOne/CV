package com.maskedpixel.mathsushi.entities.quiz;

import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.ProblemDef;
import com.maskedpixel.util.BehaviourEntity;
import haxe.EnumFlags;

/**
 * ...
 * @author Erin M Gunn
 */

enum ProblemDifficulty
{
	Easy;
	Medium;
	Hard;
}

enum ProblemOp
{
	Addition;
	Subtraction;
	Multiplication;
	Division;
}

class MathProblem extends BehaviourEntity
{
	public var lastAnswer(default, null):Int;
	
	public var a:Int;
	public var b:Int;
	
	public var operator:ProblemOp;
	public var definition:ProblemDef;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		
		_text = new Text("NaN ? NaN");
		_text.centerOrigin();
		_text.resizable = true;
		_text.size = G.getTextScale(32);
		graphic = _text;
		
		definition = new ProblemDef();
		
		layer = G.LAYER_GUI;
		
		lastAnswer = -1;
	}
	
	override public function added():Void
	{
		// Create a Math Problem
		changeProblem();
		
		_text.text = getString(this);
		_text.updateBuffer();
		_text.centerOrigin();
	}
	
	public function changeProblem():Void
	{
		operator = definition.chooseOperator();
		
		switch(operator)
		{
			case ProblemOp.Addition:
				createAddition(this);
			case ProblemOp.Subtraction:
				createSubtraction(this);
			case ProblemOp.Multiplication:
				createMultiplication(this);
			case ProblemOp.Division:
				createDivision(this);
		}
		
		_text.text = getString(this);
		_text.updateBuffer();
		_text.centerOrigin();
	}
	
	public function checkAnswer(answer:Int):Bool
	{
		lastAnswer = answer;
		switch(operator)
		{
			case ProblemOp.Addition:
				return a + b == answer;
				
			case ProblemOp.Subtraction:
				return a - b == answer;
				
			case ProblemOp.Multiplication:
				return a * b == answer;
				
			case ProblemOp.Division:
				return a / b == answer;
				
			default:
				return false;
		}
	}
	
	private var _text:Text;
	
	
	// ----  Static ----
	
	public static function createAddition(p:MathProblem):Void
	{
		var range:Float = G.RANGE_ADD[Type.enumIndex(p.definition.difficulty)];
		
		do
		{
			p.a = Math.floor(Math.random() * range);
			p.b = Math.floor(Math.random() * range);
		} while (p.a == 0 || p.b == 0);
		p.operator = ProblemOp.Addition;
	}
	
	public static function createSubtraction(p:MathProblem):Void
	{
		var range:Int = G.RANGE_SUB[Type.enumIndex(p.definition.difficulty)];
		
		do
		{
			p.a = Math.floor(Math.random() * range);
			p.b = Math.floor(Math.random() * p.a);
		} while (p.a == 0 || p.b == 0);
		p.operator = ProblemOp.Subtraction;
	}
	
	public static function createMultiplication(p:MathProblem):Void
	{
		var range:Int = G.RANGE_MUL[Type.enumIndex(p.definition.difficulty)];
		
		do
		{
			p.a = Math.floor(Math.random() * range);
			p.b = Math.floor(Math.random() * range);
		} while ( p.a == 0 || p.b == 0);
		p.operator = ProblemOp.Multiplication;
	}
	
	public static function createDivision(p:MathProblem):Void
	{
		var range:Int = G.RANGE_DIV[Type.enumIndex(p.definition.difficulty)];
		var a:Int;
		var b:Int;
		do
		{
			a = Math.floor(Math.random() * range);
			b = Math.floor(Math.random() * range);
		} while (a == 0 || b == 0);
		p.a = a * b;
		p.b = Math.random() > 0.5 ? a : b;
		p.operator = ProblemOp.Division;
	}
	
	public static function getString(p:MathProblem):String
	{
		var s:String = Std.string(p.a);
		switch(p.operator)
		{
			case ProblemOp.Addition:
				s += " + ";
				
			case ProblemOp.Subtraction:
				s += " - ";
				
			case ProblemOp.Multiplication:
				s += " * ";
				
			case ProblemOp.Division:
				s += " / ";
				
			default:
		}
		
		s += Std.string(p.b) + " =";
		
		return s;
	}
}