package com.maskedpixel.mathsushi.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.util.BehaviourEntity;

/**
 * ...
 * @author Erin M Gunn
 */

class Bar extends BehaviourEntity
{
	public var seats(default, null):Array<Seat>;

	public function new()
	{
		super();
		
		seats = new Array<Seat>();
	}
	
	override public function added():Void
	{
		layer = G.LAYER_BAR;
		name = G.NAME_BAR;
		
		var img:Image;
		// Bar Background.
		var bg:Entity = new Entity();
		bg.layer = G.LAYER_BACKGROUND;
		img = new Image(G.getSource("gfx/bar/barWall.png"));
		img.scaleX = HXP.width / img.width;
		img.scaleY = HXP.height / img.height;
		bg.addGraphic(img);
		
		img = new Image(G.getSource("gfx/bar/barPanel.png"));
		img.centerOrigin();
		img.relative = false;
		img.x = HXP.halfWidth;
		img.y = HXP.height * 0.3;
		bg.addGraphic(img);
		scene.add(bg);
		
		img = new Image(G.getSource("gfx/bar/theBar.png"));
		img.centerOrigin();
		img.scaleX = HXP.width / img.width;
		img.scaleY = (HXP.halfHeight * 0.9) / img.height;
		img.y = HXP.halfHeight / 2 / 0.9;
		graphic = img;
		var barImg:Image = img;
		
		setHitbox(cast barImg.scaledWidth, cast barImg.scaledHeight, cast barImg.scaledWidth / 2);
		
		x = HXP.halfWidth;
		y = HXP.halfHeight;
		
		// Add the Seats.
		var n:Int;
		seats = [];
		for (i in 0...G.NUM_SEATS + 1)
		{
			if (i == G.NUM_SEATS / 2)
			{
				// Add the prep station.
				scene.add(new PrepStation(G.STATION_WIDTH * i + G.STATION_WIDTH / 2, y + HXP.halfHeight * 0.1));
				
				continue;
			}
			seats.push(cast scene.add(new Seat(G.STATION_WIDTH * i + G.STATION_WIDTH / 2, cast bottom - G.STATION_WIDTH / 2 + HXP.halfHeight * 0.1)));
			
			// create a window.
			img = new Image(G.getSource("gfx/bar/barWindow.png"));
			img.centerOrigin();
			img.y = barImg.y - barImg.scaledHeight * 0.5 - img.height * 0.25;
			img.x = G.STATION_WIDTH * i + G.STATION_WIDTH / 2 - HXP.halfWidth;
			addGraphic(img);
		}
	}
	
}