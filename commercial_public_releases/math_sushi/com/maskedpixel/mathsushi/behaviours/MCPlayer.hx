package com.maskedpixel.mathsushi.behaviours;
import com.haxepunk.HXP;
import com.maskedpixel.util.Behaviour;
import com.maskedpixel.util.graphics.MCRenderer;

/**
 * ...
 * @author Erin M Gunn
 */

class MCPlayer extends Behaviour
{
	public var movieClip(getMC, setMC):MCRenderer;
	private function getMC():MCRenderer { return _mc; }
	private function setMC(value:MCRenderer):MCRenderer
	{
		_mc = value;
		return _mc;
	}
	
	@:isVar
	public var defaultAnim(default, setDefaultAnim):String;
	private function setDefaultAnim(value:String):String
	{
		if (defaultAnim == value || !_mc.hasAnimation(value)) return defaultAnim;
		defaultAnim = value;
		return defaultAnim;
	}

	public function new(mcRenderer:MCRenderer, autoPlayAnim:String = "") 
	{
		super();
		
		_mc = mcRenderer;
		defaultAnim = autoPlayAnim;
	}
	
	public function play(anim:String, loop:Bool = true):Void
	{
		if (!_mc.hasAnimation(anim)) anim = defaultAnim;
		if (!_mc.hasAnimation(anim)) return;
		if (loop) _mc.loop(anim);
		else _mc.play(anim);
	}
	
	public function pause()
	{
		_mc.stop();
	}
	
	public function resume()
	{
		play(_mc.currentAnim, _mc.isLooping);
	}
	
	private var _mc:MCRenderer;
}