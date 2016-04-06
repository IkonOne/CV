package com.maskedpixel.mathsushi.behaviours;

import com.maskedpixel.util.Behaviour;
import com.maskedpixel.util.graphics.GrapeSheet;

/**
 * ...
 * @author Erin M Gunn
 */

class GrapeSheetPlayer extends Behaviour
{
	public var sheet(getSheet, setSheet):GrapeSheet;
	private function getSheet():GrapeSheet { return _sheet; }
	private function setSheet(value:GrapeSheet):GrapeSheet
	{
		_sheet = value;
		return _sheet;
	}
	
	@:isVar
	public var defaultAnim(default, setDefaultAnim):String;
	private function setDefaultAnim(value:String):String
	{
		if (defaultAnim == value) return defaultAnim;
		if (!_sheet.animations.exists(value)) throw "Animation does not exists.";
		defaultAnim = value;
		return defaultAnim;
	}

	public function new(sheet:GrapeSheet, autoPlayAnim:String = "")
	{
		super();
		
		_sheet = sheet;
		defaultAnim = autoPlayAnim;
	}
	
	public function play(anim:String, loop:Bool = true):Void
	{
		if (_sheet.animations.exists(anim))
		{
			_sheet.play(anim).loop = loop;
			return;
		}
		_sheet.play(defaultAnim).loop = loop;
	}
	
	private var _sheet:GrapeSheet;
}