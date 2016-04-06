package com.maskedpixel.mathsushi.entities.quiz;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.G;
import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;
//import MathProblem.ProblemDifficulty;
import com.maskedpixel.mathsushi.entities.quiz.MathProblem;

/**
 * ...
 * @author Erin M Gunn
 */

class Answer extends Entity
{
	public var difficulty:ProblemDifficulty;
	public var onAnswers(default, null):Signaler<Int>;
	public var answer(getAnswer, never):Int;
	private function getAnswer():Int
	{
		var a:Int = 0;
		for (i in 0..._activeNumbers.length)
		{
			a += _activeNumbers[i].value * cast Math.pow(10, _activeNumbers.length - i - 1);
		}
		return a;
	}
	
	public var numberPad(default, setNumberPad):NumberPad;
	private function setNumberPad(value:NumberPad):NumberPad
	{
		if (numberPad == value) return numberPad;
		numberPad = value;
		for (drop in _numbers)
		{
			drop.numberPad = numberPad;
		}
		return numberPad;
	}

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		
		layer = G.LAYER_GUI;
		difficulty = ProblemDifficulty.Easy;
		onAnswers = new DirectSignaler(this);
		_activeNumbers = new Array<AnswerNumber>();
		
		_numbers = new Array<AnswerNumber>();
		for (i in 0...4)
		{
			_numbers.push(new AnswerNumber(0, 0, G.GUI_NUMBER_SIZE, G.GUI_NUMBER_SIZE));
		}
	}
	
	override public function added():Void
	{
		var numbers:Int = Type.enumIndex(difficulty) + 2;
		setHitbox(G.GUI_NUMBER_SIZE * numbers, G.GUI_NUMBER_SIZE);
		var leftDrop:Int = cast left + G.GUI_NUMBER_SIZE / 2 - width / 2;
		for (i in 0...numbers)
		{
			//_numbers[i].x = leftDrop + (width / numbers) * i;
			_numbers[i].x = leftDrop + _numbers[i].width * i;
			_numbers[i].y = y;
			_activeNumbers.push(_numbers[i]);
		}
		
		scene.addList(cast _activeNumbers);
		enable();
	}
	
	override public function removed():Void
	{
		scene.removeList(cast _activeNumbers);
		HXP.clear(_activeNumbers);
		disable();
	}
	
	public function disable():Void
	{
		for (drop in _activeNumbers)
		{
			drop.active = drop.collidable = false;
		}
	}
	
	public function enable():Void
	{
		for (drop in _activeNumbers)
		{
			drop.active = drop.collidable = true;
		}
	}
	
	public function clear():Void
	{
		for (i in 0..._activeNumbers.length)
		{
			addValue(0);
		}
	}
	
	public function addValue(value:Int):Void
	{
		var an:AnswerNumber;
		for (i in 0..._activeNumbers.length - 1)
		{
			_activeNumbers[i].value = _activeNumbers[i + 1].value;
		}
		_activeNumbers[_activeNumbers.length - 1].value = value;
	}
	
	private function onNumberDropped():Void
	{
		for (drop in _numbers)
		{
			if (drop.value < 0) return;
		}
		onAnswers.dispatch(answer);
	}
	
	private var _numbers:Array<AnswerNumber>;
	private var _activeNumbers:Array<AnswerNumber>;
}