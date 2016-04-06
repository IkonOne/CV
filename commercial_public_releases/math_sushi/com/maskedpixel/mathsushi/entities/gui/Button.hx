package com.maskedpixel.mathsushi.entities.gui;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Stamp;
import com.haxepunk.graphics.Text;
import com.maskedpixel.util.BehaviourEntity;
import com.maskedpixel.mathsushi.behaviours.Clicked;
import com.maskedpixel.util.graphics.NineSlice;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import com.haxepunk.Graphic;

/**
 * ...
 * @author Erin M Gunn
 */

class Button extends BehaviourEntity
{
	public var clicked(default, null):Clicked;
	public var text(default, null):Text;
	
	public var normal:Graphic;
	public var hover:Graphic;
	public var pressed:Graphic;
	

	public function new(?X:Float = 0, ?Y:Float = 0, ?Width:Float = 1, ?Height:Float = 1, ?Label:String = "Button", ?Normal:Graphic = null, ?Hover:Graphic = null, ?Pressed:Graphic = null)
	{
		super(X, Y);
		
		clicked = cast addBehaviour(new Clicked());
		clicked.onEnter.bindVoid(onEnter);
		clicked.onLeave.bindVoid(onLeave);
		clicked.onPressed.bindVoid(onPressed);
		clicked.onReleased.bindVoid(onReleased);
		
		setHitbox(cast Width, cast Height, cast Width / 2, cast Height / 2);
		
		if (Normal != null) normal = Normal;
		else normal = new Stamp(new BitmapData(cast Width, cast Height, false, 0xffffff), cast -Width / 2, cast -Height / 2);
		
		if (Hover != null) hover = Hover;
		else hover = new Stamp(new BitmapData(cast Width, cast Height, false, 0xCCCCCC), cast -Width / 2, cast -Height / 2);
		
		if (Pressed != null) pressed = Pressed;
		else pressed = new Stamp(new BitmapData(cast Width, cast Height, false, 0xCCCCCC), cast -Width / 2 + 5, cast -Height / 2 + 5);
		
		text = new Text(Label);
		text.centerOrigin();
		//text.color = 0;
		
		graphic = _gList = new Graphiclist([normal, text]);
	}
	
	private function onReleased()
	{
		if(hover != null) swapGraphic(hover);
	}
	
	private function onPressed():Void
	{
		if(pressed != null) swapGraphic(pressed);
	}
	
	private function onLeave():Void
	{
		swapGraphic(normal);
	}
	
	private function onEnter():Void
	{
		if(hover != null) swapGraphic(hover);
	}
	
	private function swapGraphic(graphic:Graphic):Void
	{
		if (_gList.children.length == 1) _gList.children.insert(0, graphic);
		else _gList.children[0] = graphic;
		graphic.setEntity(this);
	}
	
	private var _gList:Graphiclist;
}