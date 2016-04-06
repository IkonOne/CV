package com.maskedpixel.mathsushi.entities;

import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.behaviours.Clicked;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.util.BehaviourEntity;

/**
 * ...
 * @author Erin M Gunn
 */

class Seat extends BehaviourEntity
{
	public var clicked(default, null):Clicked;
	
	public var customer(default, setCustomer):Customer;
	private function setCustomer(value:Customer):Customer
	{
		if (customer == value) return customer;
		if (customer != null && value != null) throw "Only one Customer may occupy a seat at any one time.";
		customer = value;
		return customer;
	}
	
	public function new(x:Float, y:Float)
	{
		super(x, y);
		
		layer = G.LAYER_SEAT;
		type = G.TYPE_SEAT;
		
		var img:Image = new Image(G.getSource("gfx/bar/barSeat.png"));
		img.centerOrigin();
		graphic = img;
		
		setHitbox(G.STATION_WIDTH, cast HXP.height * 0.75);
		setOrigin(cast G.STATION_WIDTH / 2, cast y - HXP.halfHeight + halfHeight);
		
		clicked = cast addBehaviour(new Clicked());
	}
	
	public function customerReserve(c:Customer):Void
	{
		customer = c;
	}
	
	public function customerLeft(c:Customer):Void
	{
		if (c == customer) customer = null;
	}
}