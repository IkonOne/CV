package com.maskedpixel.mathsushi.graphics;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.maskedpixel.mathsushi.G;
import nme.geom.Point;
//import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import nme.display.BitmapData;

/**
 * ...
 * @author Erin M Gunn
 */

class SatisfactionBar extends Graphiclist
{
	public var percentage(default, setPercentage):Float = 1;
	private function setPercentage(value:Float):Float
	{
		percentage = HXP.clamp(value, 0, 1);
		_fg.scaleX = (width - borderSize * 2) * percentage;
		return percentage;
	}
	
	public var borderSize(default, setBorderSize):Int = 0xFFFFFF;
	private function setBorderSize(value:Int):Int
	{
		value = cast HXP.clamp(value, 1, HXP.width);
		if (value == borderSize) return borderSize;
		borderSize = value;
		
		_fg.scaleX = width - borderSize * 2;
		_fg.scaleY = height - borderSize * 2;
		
		return borderSize;
	}
	
	public var bgColor(default, setBgColor):Int = 0xFFFFFF;
	private function setBgColor(value:Int):Int
	{
		if (value == bgColor) return bgColor;
		bgColor = value;
		_bg.color = bgColor;
		return bgColor;
	}
	
	public var fgColor(default, setFgColor):Int;
	private function setFgColor(value:Int):Int
	{
		if (value == fgColor) return fgColor;
		fgColor = value;
		_fg.color = fgColor;
		return fgColor;
	}
	
	public var width(default, setWidth):Int;
	private function setWidth(value:Int):Int
	{
		if (value == width) return width;
		width = value;
		_bg.scaleX = width;
		_bg.centerOrigin();
		_fg.scaleX = width - borderSize;
		_fg.centerOrigin();
		return width;
	}
	
	public var height(default, setHeight):Int;
	private function setHeight(value:Int):Int
	{
		if (value == height) return height;
		height = value;
		_bg.scaleY = height;
		_bg.centerOO();
		_fg.scaleY = height - borderSize;
		_fg.centerOO();
		return height;
	}

	public function new()
	{
		super();
		
		_bg = new Image(G.getSource("gfx/pixel.png"));
		_fg = new Image(G.getSource("gfx/pixel.png"));
		
		add(_bg);
		add(_fg);
	}
	
	override public function render(target:BitmapData, point:Point, camera:Point):Void
	{
		_point.x = point.x + x;
		_point.y = point.y + y;
		
		_bg.render(target, point, camera);
		_fg.render(target, point, camera);
	}
	
	public function centerOO():Void
	{
		_bg.x = -_bg.scaleX / 2;
		_bg.y = -_bg.scaleY / 2;
		_fg.x = -_fg.scaleX / 2;
		_fg.y = -_fg.scaleY / 2;
		_fg.x = _bg.x + borderSize;
	}
	
	private var _bg:Image;
	private var _fg:Image;
}