package com.maskedpixel.mathsushi.entities;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.GS;

/**
 * ...
 * @author Erin M Gunn
 */

class Countdown extends Entity
{
	public var completeCallback:Void -> Void;

	public function new() 
	{
		super();
		
		_messages = ["Su", "Shi", "Sushi!", "Sushi Time!!!"];
		
		layer = G.LAYER_GUI;
		_text = new Text("3", HXP.halfWidth, HXP.halfHeight);
		_text.size = G.getTextScale(64);
		_text.relative = false;
		_text.resizable = true;
		_text.color = 0;
		addGraphic(_text);
		
		_textTween = new VarTween(onTweenComplete);
		addTween(_textTween);
		
		type = G.TYPE_COUNTDOWN;
	}
	
	override public function added():Void 
	{
		_text.text = _messages[0];
		_text.centerOrigin();
		_text.scale = 1.2;
		_text.alpha = 1;
		
		_textTween.tween(_text, "scale", 1, 1, Ease.quadIn);
		
		_textTween.start();
		GS.playSfx(GS.COUNTDOWN);
	}
	
	private function onTweenComplete(e:Dynamic) 
	{
		var idx:Int = Lambda.indexOf(_messages, _text.text) + 1;
		if (idx == _messages.length - 1)
		{
			_textTween.tween(_text, "alpha", 0, 1, Ease.quadIn);
			_text.size = G.getTextScale(128);
			if (completeCallback != null) completeCallback();
		}
		else if (idx == _messages.length)
		{
			scene.remove(this);
			return;
		}
		else
		{
			GS.playSfx(GS.COUNTDOWN);
		}
		_text.text = _messages[idx];
		_text.centerOrigin();
		_text.scale = 1.2;
		
		_textTween.start();
	}
	
	private var _messages:Array<String>;
	private var _alarm:Alarm;
	private var _textTween:VarTween;
	private var _text:Text;
}