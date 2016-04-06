package com.maskedpixel.mathsushi.entities;

import com.maskedpixel.mathsushi.behaviours.Clicked;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.util.BehaviourEntity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.maskedpixel.util.graphics.GrapeSheet;

/**
 * ...
 * @author Erin M Gunn
 */

class PrepStation extends BehaviourEntity
{
	public var clicked(default, null):Clicked;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		
		layer = G.LAYER_SEAT;
		name = G.NAME_PREP_STATION;
		type = G.TYPE_PREP_STATION;
		
		clicked = cast addBehaviour(new Clicked());
		
		setHitbox(G.STATION_WIDTH, HXP.height);
		setOrigin(cast G.STATION_WIDTH / 2, cast HXP.height - (HXP.height - y));
		
		_grapeSheet = new GrapeSheet("sheets/movearrowanim/sheets.xml", "sheets/movearrowanim/animations.xml", #if !flash G.getAtlas() #else null #end);
		_grapeSheet.loop("default");
		_grapeSheet.originY = halfHeight / 2;
		graphic = _grapeSheet;
		
		visible = false;
	}
	
	override public function update():Void
	{
		super.update();
		
		if (_server == null) _server = cast scene.getInstance(G.NAME_SERVER);
		if (_server != null) visible = _server.hasFoodToPrep;
	}
	
	private var _grapeSheet:GrapeSheet;
	private var _server:Server;
}