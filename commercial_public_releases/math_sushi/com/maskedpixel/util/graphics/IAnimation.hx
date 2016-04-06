
package com.maskedpixel.util.graphics;

import com.haxepunk.Graphic;
import hsl.haxe.Signaler;

interface IAnimation
{
	var scale:Float;
	var scaleX:Float;
	var scaleY:Float;
	var originX:Float;
	var originY:Float;
	
	var onComplete(default, null):Signaler<IAnimation>;

	function play(anim:String):Dynamic;
	function loop(anim:String):Dynamic;
	function stop():Void;
	function hasAnimation(anim:String):Bool;
	function getCurrentAnim():String;
	function getIsLooping():Bool;
	function getGraphic():Graphic;
}