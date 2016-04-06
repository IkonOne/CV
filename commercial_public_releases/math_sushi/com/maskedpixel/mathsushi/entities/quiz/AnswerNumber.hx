package com.maskedpixel.mathsushi.entities.quiz;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.behaviours.DragObject;
import com.maskedpixel.mathsushi.behaviours.DragTarget;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.util.BehaviourEntity;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

/**
 * ...
 * @author Erin M Gunn
 */

class AnswerNumber extends BehaviourEntity
{
	public var value(default, setValue):Int;
	private function setValue(value:Int):Int
	{
		if (this.value == value) return this.value;
		this.value = value;
		_text.text = Std.string(this.value);
		_text.centerOrigin();
		_text.updateBuffer();
		return this.value;
	}
	
	public var numberPad(default, setNumberPad):NumberPad;
	private function setNumberPad(value:NumberPad):NumberPad
	{
		if (value == numberPad) return numberPad;
		numberPad = value;
		return numberPad;
	}

	public function new(x:Float = 0, y:Float = 0, w:Float = 1, h:Float = 1)
	{
		super(x, y);
		
		layer = G.LAYER_GUI;
		
		_text = new Text(Std.string(0));
		_text.size = G.getTextScale(32);
		_text.resizable = true;
		_text.updateBuffer();
		_text.centerOrigin();
		setHitboxTo(_text);
	}
	
	override public function added():Void
	{
		value = 0;
		graphic = _text;
	}
	
	private var _gList:Graphiclist;
	private var _text:Text;
}