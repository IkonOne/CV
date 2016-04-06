package com.maskedpixel.preloaders;
#if doc

#elseif js

// html5 doesn't support drawTiles
class MathNook extends NMEPreloader { }

#else

import com.haxepunk.graphics.atlas.TextureAtlas;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Graphics;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Lib;
import nme.net.URLRequest;

@:bitmap("FGL/thall88/mathnook640X360.jpg")
class MathNookLogo extends BitmapData {}

class MathNook extends NMEPreloader
{

	public function new()
	{
		tileData = [
			  0,   0, 0 // powered by
		];

		tiles = new Tilesheet(new MathNookLogo(0, 0));
		tiles.addTileRect(new Rectangle(0, 0, 640, 360));
		
		var width = 640;
		var height = 360;

		// update bar position
		var color = 0xCB6325;
		var padding = 5;

		super();
		
		outline.x = outline.y = 0;

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		onEnterFrame(null); // initial render
		
		removeChild(outline);
		removeChild(progress);
		
	}
	
	override public function onInit():Dynamic 
	{
		super.onInit();
		stage.addEventListener(MouseEvent.CLICK, onMouseClicked);
	}
	
	private function onMouseClicked(e:MouseEvent):Void 
	{
		Lib.getURL(new URLRequest("http://www.mathnook.com"));
	}
	
	override public function onLoaded():Dynamic 
	{
		stage.removeEventListener(MouseEvent.CLICK, onMouseClicked);
		super.onLoaded();
	}

	public function onEnterFrame(e:Event)
	{
		outline.graphics.clear();
		progress.graphics.clear();
		tiles.drawTiles(this.graphics, tileData, true);
	}

	private var scaleIncrement:Float;

	private var tiles:Tilesheet;
	private var tileData:Array<Float>;

}

#end