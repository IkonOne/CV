package com.maskedpixel.mathsushi.entities.gui;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.tweens.TweenEvent;
import com.haxepunk.utils.Ease;
import com.maskedpixel.mathsushi.G;
import nme.events.Event;

/**
 * ...
 * @author Erin M Gunn
 */

class SushiRating extends Entity
{
	public var rating(getRating, setRating):Int;
	private function getRating():Int { return _rating; }
	private function setRating(value:Int):Int
	{
		_rating = cast HXP.clamp(value, 0, 3);
		for (i in 0...3) 
		{
			_sushi[i].alpha = i < _rating ? 1 : 0.5;
		}
		return _rating;
	}

	public function new(X:Float = 0, Y:Float = 0, Width:Int = 1, Height:Int = 1, Stars:Int = 0) 
	{
		super(X, Y);
		
		layer = G.LAYER_GUI;
		setHitbox(Width, Height, cast Width / 2, cast Height / 2);
		
		var source:Dynamic;
		
#if flash
		source = "gfx/gui/StarParticle.png";
#else
		source = G.getAtlas().getRegion("gui/StarParticle.png");
#end
		_emitter = new Emitter(source);
		_emitter.newType("normal");
		_emitter.setAlpha("normal", 1, 0.1);
		_emitter.setColor("normal", 0x0B486B, 0xCFF09E);
		_emitter.setGravity("normal", HXP.height * 0.1);
		addGraphic(_emitter);
		
		var bg:Image;
		for (i in 0...3)
		{
#if flash
			source = "gfx/sensei/Sushi1.png";
#else
			source = G.getAtlas().getRegion("sensei/Sushi1.png");
#end
			bg = new Image(source);
			bg.scale = height / bg.height;
			bg.x = (-height * 1.2) + (height * i) + (height * 0.2 * i);
			bg.y = i != 1 ? -height * 0.2 : bg.y;
			bg.centerOrigin();
			bg.color = 0;
			addGraphic(bg);
		}
		
		_sushi = new Array<Image>();
		var sushi:Image;
		for (i in 0...3)
		{
#if flash
			source = "gfx/sensei/Sushi" + Std.string(i + 1) + ".png";
#else
			source = G.getAtlas().getRegion("sensei/Sushi" + Std.string(i + 1) + ".png");
#end
			sushi = new Image(source);
			sushi.scale = height / sushi.height * 0.9;
			sushi.x = (-height * 1.2) + (height * i) + (height * 0.2 * i);
			sushi.y = i != 1 ? -height * 0.2 : sushi.y;
			sushi.alpha = i < _rating ? 1 : 0.1;
			sushi.centerOrigin();
			addGraphic(sushi);
			_sushi.push(sushi);
		}
		
		rating = Stars;
	}
	
	public function emitParticles() 
	{
		_alarm = new Alarm(Math.random() * 0.5 + 0.2, TweenType.Persist);
		_alarm.addEventListener(TweenEvent.FINISH, onEmit);
		addTween(_alarm, true);
	}
	
	private function onEmit(e:Event) 
	{
		var pick:Int = HXP.rand(3);
		var pos:Float = -height + (height * pick) + (height * 0.2 * pick);
		_emitter.setMotion("normal", 0, HXP.halfHeight, 1, 360, 100, 0);
		for (i in 0...20)
		{
			_emitter.emitInCircle("normal", pos, 0, halfHeight);
		}
		_alarm.reset(Math.random() * 0.5 + 0.2);
	}
	
	private var _alarm:Alarm;
	private var _emitter:Emitter;
	private var _rating:Int;
	private var _sushi:Array<Image>;
}