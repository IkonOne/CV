
package com.maskedpixel.mathsushi.behaviours;

import com.haxepunk.HXP;
import com.maskedpixel.util.Behaviour;
import com.maskedpixel.util.graphics.IAnimation;

class AnimPlayer extends Behaviour
{
	public var anim(getAnim, setAnim):IAnimation;
	private function getAnim():IAnimation { return _anim; }
	private function setAnim(value:IAnimation):IAnimation
	{
		_anim = value;
		return _anim;
	}

	@:isVar
	public var defaultAnim(default, setDefaultAnim):String;
	private function setDefaultAnim(value:String):String
	{
		if (defaultAnim == value || !_anim.hasAnimation(value)) return defaultAnim;
		defaultAnim = value;
		return defaultAnim;
	}

	public function new(iAnim:IAnimation, autoPlayAnim:String = "")
	{
		super();

		_anim = iAnim;
		defaultAnim = autoPlayAnim;
	}

	public function play(anim:String, loop:Bool = true):Void
	{
		if (!_anim.hasAnimation(anim)) anim = defaultAnim;
		if (!_anim.hasAnimation(anim)) return;
		if (loop) _anim.loop(anim);
		else _anim.play(anim);
	}

	public function pause()
	{
		_anim.stop();
	}

	public function resume()
	{
		play(_anim.getCurrentAnim(), _anim.getIsLooping());
	}

	private var _anim:IAnimation;
}