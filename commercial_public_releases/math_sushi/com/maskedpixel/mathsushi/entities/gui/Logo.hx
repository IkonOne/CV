package com.maskedpixel.mathsushi.entities.gui;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.prototype.Circle;
import com.haxepunk.HXP;
import com.haxepunk.tweens.motion.CircularMotion;
import com.haxepunk.tweens.TweenEvent;
import com.haxepunk.utils.Draw;
import com.maskedpixel.mathsushi.G;
import flash.events.Event;
import com.haxepunk.Tween;
import com.haxepunk.utils.Ease;

/**
 * ...
 * @author Erin M Gunn
 */

class Logo extends Entity
{

	public function new()
	{
		super();
		
		_logo = new Image(G.getSource("gfx/gui/Logo.png"));
		_logo.centerOrigin();
		graphic = _logo;
		
		_bobMotion = new CircularMotion(null, TweenType.Looping);
		_bobMotion.setMotion(HXP.halfWidth, _logo.height / 2 + HXP.height * 0.05, _logo.height * 0.05, 90, true, 1);
		_bobMotion.addEventListener(TweenEvent.UPDATE, onLogoBobUpdate);
		addTween(_bobMotion);
		
		layer = 0;
	}
	
	private function onLogoBobUpdate(e:Event):Void
	{
		x = _bobMotion.x;
		y = _bobMotion.y;
		
		_logo.scale = HXP.scale(Math.abs(Ease.sineInOut(HXP.scale(_bobMotion.angle * HXP.DEG, 0, 360, -90, 270) / 180)), 0, 1, 0.9, 1);
		_logo.angle = HXP.scale(Math.abs(Ease.sineInOut((_bobMotion.angle * HXP.DEG + 180) / 180)), 0, 1, 1, -1);
	}
	
	private var _logo:Image;
	private var _bobMotion:CircularMotion;
}