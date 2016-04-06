package com.maskedpixel.mathsushi.entities.gui;

import com.haxepunk.graphics.Stamp;
import com.haxepunk.Sfx;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.GS;
import com.maskedpixel.util.graphics.NineSlice;
import flash.geom.Rectangle;
import flash.display.BitmapData;

/**
 * ...
 * @author Erin M Gunn
 */

class BambooButton extends Button
{

	public function new(?X:Float = 0, ?Y:Float = 0, ?Width:Float = 1, ?Height:Float = 1, ?Label:String = "Button")
	{
		X = Math.floor(X);
		Y = Math.floor(Y);
		Width = Math.floor(Width);
		Height = Math.floor(Height);
		
		var Normal:NineSlice = new NineSlice(G.getSource("gfx/gui/BambooButton.png"), new Rectangle(10, 10, 190, 80));
		Normal.color = 0x00DDDD;
		Normal.width = Width;
		Normal.height = Height;
		Normal.centerOrigin();
		
		var Hover:NineSlice = new NineSlice(G.getSource("gfx/gui/BambooButton.png"), new Rectangle(10, 10, 190, 80));
		Hover.color = 0x00FFFF;
		Hover.width = Width;
		Hover.height = Height;
		Hover.centerOrigin();
		
		var Pressed:NineSlice = new NineSlice(G.getSource("gfx/gui/BambooButtonFlipped.png"), new Rectangle(10, 10, 190, 80));
		Pressed.color = 0x00FFFF;
		Pressed.width = Width;
		Pressed.height = Height;
		Pressed.centerOrigin();
		Pressed.originX -= 1;
		Pressed.originY -= 1;
		
		super(X, Y, Width, Height, Label, Normal, Hover, Pressed);
		
		text.resizable = true;
		text.size = G.getTextScale(32);
		text.updateBuffer();
		text.resizable = false;
		text.centerOrigin();
	}
}