package com.maskedpixel.mathsushi.entities.gui;

import com.haxepunk.graphics.Stamp;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.GS;
import com.maskedpixel.util.graphics.NineSlice;
import flash.geom.Rectangle;
import nme.Assets;

/**
 * ...
 * @author Erin M Gunn
 */

class CalculatorButton extends Button
{

	public function new(?X:Float = 0, ?Y:Float = 0, ?Width:Float = 1, ?Height:Float = 1, ?Label:String = "Button")
	{
		var source:Dynamic = G.getSource("gfx/gui/CalculatorButton.png");
		
		var Normal:NineSlice = new NineSlice(source, new Rectangle(source.width / 2 - 1, source.height / 2 - 1, 2, 2));
		Normal.width = Width;
		Normal.height = Height;
		Normal.centerOrigin();
		
		var Hover:NineSlice = new NineSlice(source, new Rectangle(source.width / 2 - 1, source.height / 2 - 1, 2, 2));
		Hover.width = Width;
		Hover.height = Height;
		Hover.centerOrigin();
		Hover.color = 0xCCCCCC;
		
		var Pressed:NineSlice = new NineSlice(source, new Rectangle(source.width / 2 - 1, source.height / 2 - 1, 2, 2));
		Pressed.width = Width;
		Pressed.height = Height;
		Pressed.centerOrigin();
		Pressed.color  = 0xCCCCCC;
		Pressed.originX -= 2;
		Pressed.originY -= 2;
		
		super(X, Y, Width, Height, Label, Normal, Hover, Pressed);
		
		text.resizable = true;
		text.size = G.getTextScale(32);
		text.updateBuffer();
		text.resizable = false;
		text.centerOrigin();
		text.color = 0xFFFFFF;
		
		//clicked.onClicked.bindVoid(function():Void { GS.BUTTON_CLICKED.play(); } );
	}
}