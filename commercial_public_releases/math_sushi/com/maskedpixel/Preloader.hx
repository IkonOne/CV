package com.maskedpixel;

#if doc

#elseif js

// html5 doesn't support drawTiles
class Preloader extends NMEPreloader { }

#else

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Graphics;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.events.Event;
import nme.geom.Point;
import nme.geom.Rectangle;

@:bitmap("assets/gfx/preloader.png")
class PreloaderLogo extends BitmapData { }


class Preloader extends NMEPreloader
{

	public function new()
	{
		super();
		
		scaleIncrement = 0.0002;
		
		logo = new Bitmap(new PreloaderLogo(0, 0));
		logo.x = getWidth() / 2 - (logo.width / 2);
		logo.y = getHeight() / 2 - (logo.height / 2);
		addChild(logo);
		
		//outline.visible = progress.visible = false;
		outline.y = getHeight() * 0.8;
		progress.y = outline.y + outline.height / 2;

		//addEventListener(Event.ENTER_FRAME, onEnterFrame);
		onEnterFrame(null); // initial render
	}

	public function onEnterFrame(e:Event)
	{
		//logo.scaleX += scaleIncrement;
		//logo.scaleY += scaleIncrement;
		if (logo.scaleX >= 1.02 || logo.scaleX <= 1) scaleIncrement = -scaleIncrement;
	}
	
	//public function onRemoved(e:Event)
	//{
		//
	//}

	private var scaleIncrement:Float;
	
	private var logo:Bitmap;

}

#end