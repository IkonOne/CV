package com.maskedpixel.mathsushi.entities.quiz;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.behaviours.Clicked;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.ProblemDef;
import com.maskedpixel.util.BehaviourEntity;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;
import com.maskedpixel.mathsushi.entities.quiz.MathProblem;

/**
 * ...
 * @author Erin M Gunn
 */

class QuizItem extends BehaviourEntity
{
	public var clicked(default, null):Clicked;
	public var onAnswered(default, null):Signaler<QuizItem>;
	public var correctAnswer(default, null):Bool;
	
	public var problem(getProblem, never):MathProblem;
	private function getProblem():MathProblem
	{
		return _problem;
	}
	
	public var answer(getAnswer, never):Answer;
	private function getAnswer():Answer
	{
		return _answer;
	}
	
	public var numberPad(default, setNumberPad):NumberPad;
	private function setNumberPad(value:NumberPad):NumberPad
	{
		if (numberPad == value) return numberPad;
		numberPad = value;
		_answer.numberPad = numberPad;
		return numberPad;
	}

	public function new(x:Float = 0, y:Float = 0, width:Float = 1, height:Float = 1)
	{
		super(x, y);
		
		onAnswered = new DirectSignaler(this);
		clicked = cast addBehaviour(new Clicked());
		
		layer = G.LAYER_GUI;
		
		_background =  new Image(G.getSource("gfx/bar/barTop.png"));
		_background.centerOrigin();
		_background.scaleX = width / _background.width;
		_background.scaleY = height / _background.height;
		graphic = _background;
		
		setHitbox(cast width, cast height);
		centerOrigin();
		
		_problem = new MathProblem((x - halfWidth) + width / 4, y - height / 8);
		
		_answer = new Answer((x + halfWidth) - width / 4, y - height / 8);
	}
	
	override public function added():Void
	{
		_answer.difficulty = _problem.definition.difficulty;
		scene.add(_problem);
		scene.add(_answer);
		_background.color = HXP.convertColor(0xFFFFFF);
		
		correctAnswer = false;
	}
	
	override public function removed():Void
	{
		scene.remove(_problem);
		scene.remove(_answer);
	}
	
	public function enable():Void
	{
		active = visible = true;
		_problem.active = _problem.visible = true;
		_answer.enable();
	}
	
	public function disable():Void
	{
		active = visible = false;
		_problem.active = _problem.visible = false;
		_answer.disable();
	}
	
	public function checkAnswer():Void
	{
		correctAnswer = _problem.checkAnswer(_answer.answer);
		if (correctAnswer)
		{
			_background.color = HXP.convertColor(0x00FF00);
			_answer.disable();
		}
		else
		{
			_background.color = HXP.convertColor(0xFF0000);
			_answer.clear();
			//_problem.changeProblem();
		}
		onAnswered.dispatch(this);
	}
	
	public function addValue(value:Int):Void
	{
		_answer.addValue(value);
	}
	
	public function setDefinition(def:ProblemDef):Void
	{
		_problem.definition = def;
	}
	
	private var _background:Image;
	private var _problem:MathProblem;
	private var _answer:Answer;
}
