package com.maskedpixel.mathsushi.entities.quiz;

import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Draw;
import com.maskedpixel.mathsushi.behaviours.DragObject;
import com.maskedpixel.mathsushi.entities.gui.CalculatorButton;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.entities.gui.Button;

/**
 * ...
 * @author Erin M Gunn
 */

class PadNumber extends CalculatorButton
{
	public var value(default, null):Int;
	//public var dragObject(default, null):DragObject;

	public function new(X:Float = 0, Y:Float = 0, Width:Float = 1, Height:Float = 1, num:String = "0")
	{
		super(Math.round(X), Math.round(Y), Width, Height, num);
		
		layer = G.LAYER_GUI;
		type = G.TYPE_QUIZ_ITEM;
		
		centerOrigin();
		
		//var img:Image = Image.createRect(G.GUI_NUMBER_SIZE, G.GUI_NUMBER_SIZE, 0xCC00CC);
		//img.centerOO();
		//addGraphic(img);
		//
		//setHitboxTo(img);
		//
		//value = num;
		//if (value == 10) value = 0;
		//var txt:Text = new Text(Std.string(value));
		//txt.centerOO();
		//addGraphic(txt);
		
		//dragObject = cast addBehaviour(new DragObject());
		//dragObject.onDragStart.bindVoid(onDrag);
		//dragObject.onDragStop.bindVoid(onDrop);
	}
	
	//private function onDrag():Void
	//{
		//layer = G.LAYER_GUI_DRAGGING;
	//}
	//
	//private function onDrop():Void
	//{
		//layer = G.LAYER_GUI;
	//}
	
}