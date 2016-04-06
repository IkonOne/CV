package com.maskedpixel.mathsushi.entities.quiz;

import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.utils.Key;
import com.maskedpixel.mathsushi.behaviours.Clicked;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.util.BehaviourEntity;
import com.maskedpixel.mathsushi.behaviours.DragObject;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

/**
 * ...
 * @author Erin M Gunn
 */

enum NumPadOrientation
{
	Vertical;
	Horizontal;
}

class NumberPad extends BehaviourEntity
{
	public var numberPressed(default, null):Signaler<Int>;
	
	public var focusedItem:QuizItem;
	public var quizItems(default, null):Array<QuizItem>;
	

	public function new(x:Float = 0, y:Float = 0, w:Float = 1, h:Float = 1, oriented:NumPadOrientation = null)
	{
		super(x, y);
		
		layer = G.LAYER_GUI;
		
		if (oriented == null) oriented = NumPadOrientation.Vertical;
		
		quizItems = new Array<QuizItem>();
		
		var img:Image = new Image(G.getSource("gfx/bar/barWall.png"));
		img.scaleX = w / img.width * 1.1;
		img.scaleY = h / img.height * 1.1;
		img.centerOrigin();
		graphic = img;
		
		setHitbox(cast w, cast h);
		centerOrigin();
		
		numberPressed = new DirectSignaler(this);
		_numbers = new Array<PadNumber>();
		var num:PadNumber;
		var yTop:Float = y - halfHeight + height / 10;
		switch(oriented)
		{
			case NumPadOrientation.Vertical:
				// 0
				num = new PadNumber(left + width / 3, bottom - halfHeight / 4, width / 3 * 2 * 0.95, height / 4 * 0.9, Std.string(0));
				num.clicked.hotKeys.push(Key.DIGIT_0);
				num.clicked.hotKeys.push(Key.NUMPAD_0);
				_numbers.push(num);
				num.clicked.onClicked.bind(onNumberClicked);
				
				// 1 - 9
				for (i in 0...3)
				{
					for (j in 0...3)
					{
						num = new PadNumber(left + halfWidth / 3 + width / 3 * i, (bottom - height / 4 * 1.5) - height / 4 * j, width / 3 * 0.9, height / 4 * 0.9, Std.string((i + 1) + (j * 3)));
						num.clicked.hotKeys.push(cast Reflect.field(Key, "DIGIT_" + Std.parseInt(num.text.text)));
						num.clicked.hotKeys.push(cast Reflect.field(Key, "NUMPAD_" + Std.parseInt(num.text.text)));
						_numbers.push(num);
						num.clicked.onClicked.bind(onNumberClicked);
					}
				}
				
				// =
				num = new PadNumber(right - halfWidth / 3, bottom - halfHeight / 4, width / 3 * 0.9, height / 4 * 0.9, "=");
				num.clicked.hotKeys.push(Key.ENTER);
				num.clicked.hotKeys.push(Key.NUMPAD_ENTER);
				_numbers.push(num);
				num.clicked.onClicked.bind(onNumberClicked);
				
			default:
		}
	}
	
	private function onNumberClicked(c:Clicked):Void
	{
		var pn:PadNumber = cast c.parent;
		if (pn == null) return;
		
		if (pn.text.text == "=")
		{
			focusedItem.checkAnswer();
		}
		else
		{
			focusedItem.addValue(Std.parseInt(pn.text.text));
		}
	}
	
	private function onQuizItemClicked(c:Clicked):Void
	{
		var qi:QuizItem = cast c.parent;
		if (Lambda.has(quizItems, qi))
		{
			if (!qi.correctAnswer) focusedItem = cast c.parent;
		}
	}
	
	override public function added():Void
	{
		scene.addList(cast _numbers);
		
		for (qi in quizItems)
		{
			qi.clicked.onClicked.bind(onQuizItemClicked);
		}
	}
	
	override public function removed():Void
	{
		scene.removeList(cast _numbers);
	}
	
	private var _numbers:Array<PadNumber>;
}