package com.maskedpixel.mathsushi.scenes;

import com.haxepunk.graphics.prototype.Circle;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.maskedpixel.mathsushi.entities.Bar;
import com.maskedpixel.mathsushi.entities.gui.BambooButton;

/**
 * ...
 * @author ...
 */
class TestAtlas extends Scene
{

	public function new() 
	{
		super();
		
	}
	
	override public function begin():Dynamic 
	{
		add(new BambooButton(HXP.halfWidth, HXP.halfHeight, HXP.halfWidth, HXP.halfHeight));
		addGraphic(new Circle(4, 0x00FF00), 0, HXP.halfWidth - 2, HXP.halfHeight - 2);
	}
}