package com.maskedpixel.util.graphics;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.atlas.TextureAtlas;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.utils.Draw;
import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;
import flash.display.BitmapData;
import nme.Assets;

/**
 * ...
 * @author Erin M Gunn
 */

class GrapeSheet extends Graphiclist, implements IAnimation
{
	public var rate:Float;
	public var scale:Float = 1;
	public var scaleX:Float = 1;
	public var scaleY:Float = 1;
	public var originX:Float = 0;
	public var originY:Float = 0;
	
	public var name(default, null):String;
	public var onComplete(default, null):Signaler<IAnimation>;
	public var swappableParts(default, null):Array<String>;
	
	public var isLooping(getIsLooping, null):Bool;
	public function getIsLooping():Bool { return _anim.loop; }
	
	public var complete(getComplete, never):Bool;
	private function getComplete():Bool { return _anim != null ? _anim.complete : false; }
	
	public var currentAnim(getCurrentAnim, null):String;
	public function getCurrentAnim():String { return _anim != null ? _anim.name : ""; }
	
	public var currentFrame(getCurrentFrame, never):Int;
	private function getCurrentFrame():Int { return _anim.currentFrame; }
	
	public var animations(getAnimations, never):Hash<GrapeAnim>;
	private function getAnimations():Hash<GrapeAnim> { return _animations; }
	
	
	@:isVar
	public var smooth(getSmooth, setSmooth):Bool;
	private function getSmooth():Bool { return smooth; }
	private function setSmooth(value:Bool):Bool
	{
		if (value == smooth) return smooth;
		smooth = value;
		for (part in _parts)
		{
			part.smooth = smooth;
		}
		return smooth;
	}
	
	@:isVar
	public var alpha(getAlpha, setAlpha):Float;
	private function getAlpha():Float { return alpha; }
	private function setAlpha(value:Float):Float
	{
		value = HXP.clamp(value, 0, 1);
		if (value == alpha) return alpha;
		alpha = value;
		for (part in _parts)
		{
			part.alpha = alpha;
		}
		return alpha;
	}

	public function new(sheet:String, animations:String, atlas:TextureAtlas = null)
	{
		super();
		
		active = true;
		rate = 1;
		scale = scaleX = scaleY = 1;
		originX = originY = 0;
		_sheetXml = Xml.parse(Assets.getText(sheet)).firstElement().firstElement();
		_parts = new Hash<Image>();
		onComplete = new DirectSignaler(this);
		swappableParts = new Array<String>();
		_atlas = atlas;
		
		name = _sheetXml.get("name");
		var source:Dynamic;
		var img:Image;
		var images:Array<Image> = new Array<Image>();
		for (texture in _sheetXml)
		{
			if (texture.nodeType != Xml.Element) continue;
			if (_atlas == null) source = Assets.getBitmapData("gfx/" + texture.get("path"), true);
			else source = _atlas.getRegion(texture.get("path"));
			
			img = new Image(source, null, texture.get("name"));
			img.originX = cast Std.parseFloat(texture.get("registrationPointX"));
			img.originY = cast Std.parseFloat(texture.get("registrationPointY"));
			add(img);
			_parts.set(texture.get("name"), img);
		}
		_graphics.reverse();
		
		_animations = new Hash<GrapeAnim>();
		
		var gFrame:GrapeFrame;
		var anim:GrapeAnim;
		var index:Int;
		var partName:String;
		_animXml = Xml.parse(Assets.getText(animations)).firstElement();
		for (animation in _animXml)
		{
			if (animation.nodeType != Xml.Element) continue;
			anim = new GrapeAnim(animation.get("name"), Std.parseInt(animation.get("frameCount")));
			_animations.set(anim.name, anim);
			
			for (part in animation)
			{
				if (part.nodeType != Xml.Element) continue;
				
				partName = part.get("name");
				index = 0;
				
				for (frame in part)
				{
					if (frame.nodeType != Xml.Element) continue;
					
					gFrame = new GrapeFrame();
					while (Std.parseInt(frame.get("index")) != index)
					{
						gFrame.visible = false;
						if (anim.frames.length == index) anim.frames.push(new Hash<GrapeFrame>());
						anim.frames[index].set(partName, gFrame);
						gFrame = new GrapeFrame();
						index++;
					}
					
					gFrame.x = frame.exists("x") ? Std.parseFloat(frame.get("x")) : 0;
					gFrame.y = frame.exists("y") ? Std.parseFloat(frame.get("y")) : 0;
					if (frame.exists("scaleX")) gFrame.scaleX = Std.parseFloat(frame.get("scaleX"));
					if (frame.exists("scaleY")) gFrame.scaleY = Std.parseFloat(frame.get("scaleY"));
					if (frame.exists("rotation")) gFrame.angle = -Std.parseFloat(frame.get("rotation"));
					
					if (anim.frames.length == index) anim.frames.push(new Hash<GrapeFrame>());
					anim.frames[index].set(partName, gFrame);
					index++;
				}
			}
		}
		
		play("default");
	}
	
	// public function play(animation:String = "default", reset:Bool = false, frame:Int = 0, loop:Bool = false, tweenTime:Float = 0):GrapeAnim
	// {
	// 	if (!_animations.exists(animation)) return null;
	// 	if (!reset && animation == currentAnim) return _animations.get(currentAnim);
		
	// 	if (tweenTime != 0)
	// 	{
	// 		_tweenElapsed = 0;
	// 		_tweenTime = tweenTime;
	// 		_tweenAnim = _anim;
	// 	}
		
	// 	_anim = _animations.get(animation);
	// 	_anim.currentFrame = cast HXP.clamp(frame, 0, _anim.frameCount);
	// 	_anim.complete = false;
	// 	_anim.timer = 0;
		
	// 	return _anim;
	// }

	public function play(anim:String):GrapeAnim
	{
		if (!_animations.exists(anim)) return null;
		if (anim == currentAnim) return _animations.get(currentAnim);

		//_tweenTime = 0;
		//_tweenElapsed = 0;
		//_tweenAnim = _anim;

		_anim = _animations.get(anim);
		_anim.currentFrame = 0;
		_anim.complete = false;
		_anim.timer = 0;
		
		updateBuffer();
		
		return _anim;
	}

	public function loop(anim:String):GrapeAnim
	{
		play(anim).loop = true;
		return _anim;
	}

	public function stop():Void
	{
		//throw "Not yet implemented";
		//trace("stop animation: " + _anim.name);
	}
	
	public function getPart(name:String):Image
	{
		return _parts.get(name);
	}

	public function hasAnimation(anim:String):Bool
	{
		return _animations.exists(anim);
	}

	public function getGraphic():Graphic
	{
		return this;
	}
	
	override public function update():Void
	{
		var rebuff:Bool = false;
		
		if (_tweenAnim != null && !_tweenAnim.complete && _tweenTime > _tweenElapsed)
		{
			_tweenElapsed += (HXP.fixed ? 1 : HXP.elapsed) * rate;
			rebuff = updateAnim(_tweenAnim, false);
			if (_tweenTime < _tweenElapsed) _tweenAnim = null;
		}
		
		if (_anim != null && !_anim.complete)
		{
			rebuff = rebuff || updateAnim(_anim);
		}
		
		if (rebuff) updateBuffer();
		
		super.update();
	}
	
	public function updateBuffer():Void
	{
		var frames:Hash<GrapeFrame> = _anim.frames[_anim.currentFrame];
		var frame:GrapeFrame;
		var part:Image;
		
		//var tweenFrames:Hash<GrapeFrame> = _tweenAnim != null ? _tweenAnim.frames[_tweenAnim.currentFrame] : null;
		var tweenFrame:GrapeFrame;
		
		if (_tweenAnim != null)
		{
			for (key in _parts.keys())
			{
				part = _parts.get(key);
				frame = frames.get(key);
				tweenFrame = findPart(_tweenAnim, key);
				
				if (frame != null) part.visible = frame.visible;
				else part.visible = false;
				if (!part.visible) continue;
				
				if (tweenFrame != null)
				{
					var t:Float = _tweenTime > 0 ? _tweenElapsed / _tweenTime : 0;
					part.x = (HXP.lerp(tweenFrame.x, frame.x, t) - originX) * scale * scaleX;
					part.y = (HXP.lerp(tweenFrame.y, frame.y, t) - originY) * scale * scaleY;
					part.scaleX = HXP.lerp(tweenFrame.scaleX, frame.scaleX, t) * scale * scaleX;
					part.scaleY = HXP.lerp(tweenFrame.scaleY, frame.scaleY, t) * scale * scaleY;
					part.angle = HXP.lerp(tweenFrame.angle, tweenFrame.angle + HXP.angleDifference(tweenFrame.angle, frame.angle), t);
				}
				else
				{
					part.x = (frame.x - originX) * scale * scaleX;
					part.y = (frame.y - originY) * scale * scaleY;
					part.scaleX = frame.scaleX * scale * scaleX;
					part.scaleY = frame.scaleY * scale * scaleY;
					part.angle = frame.angle;
				}
			}
		}
		else
		{
			for (key in _parts.keys())
			{
				part = _parts.get(key);
				frame = frames.get(key);
				
				if (frame != null) part.visible = frame.visible;
				else part.visible = false;
				if (!part.visible) continue;
				
				part.x = (frame.x - originX) * scale * scaleX;
				part.y = (frame.y - originY) * scale * scaleY;
				part.scaleX = frame.scaleX * scale * scaleX;
				part.scaleY = frame.scaleY * scale * scaleY;
				part.angle = frame.angle;
			}
		}
	}
	
	public function findPart(anim:GrapeAnim, partName:String):GrapeFrame
	{
		if (anim.frames[anim.currentFrame].exists(partName)) return anim.frames[anim.currentFrame].get(partName);
		
		for (key in swappableParts)
		{
			if (key == partName.substr(0, key.length))
			{
				for (part in anim.frames[anim.currentFrame].keys())
				{
					if (part.substr(0, key.length) == key) return anim.frames[anim.currentFrame].get(part);
				}
			}
		}
		
		return null;
	}
	
	private function updateAnim(anim:GrapeAnim, dispatch:Bool = true):Bool
	{
		if (anim != null)
		{
			anim.timer += (HXP.fixed ? anim.frameRate : anim.frameRate * HXP.elapsed) * rate;
			if (anim.timer >= 1)
			{
				while (anim.timer >= 1)
				{
					anim.timer--;
					anim.currentFrame++;
					if (anim.currentFrame == anim.frameCount)
					{
						if (anim.loop)
						{
							anim.currentFrame = 0;
						}
						else
						{
							anim.currentFrame = anim.frameCount - 1;
							anim.complete = true;
							if (dispatch) onComplete.dispatch(this);
							break;
						}
					}
				}
				return true;
			}
		}
		
		return false;
	}
	
	// sheet
	private var _parts:Hash<Image>;
	private var _sheetXml:Xml;
	private var _atlas:TextureAtlas;
	
	// Animation
	private var _animXml:Xml;
	private var _animations:Hash<GrapeAnim>;
	private var _anim:GrapeAnim;
	private var _tweenAnim:GrapeAnim;
	private var _tweenTime:Float;
	private var _tweenElapsed:Float;
}

class GrapeAnim
{
	public var name(default, null):String;
	public var frameCount(default, null):Int;
	public var frames(default, null):Array<Hash<GrapeFrame>>;
	public var loop:Bool;
	public var frameRate:Float;
	public var currentFrame:Int;
	public var timer:Float;
	public var complete:Bool;
	
	public function new(name:String, frameCount:Int, ?frameRate:Float = 30)
	{
		loop = false;
		
		this.name = name;
		this.frameCount = frameCount;
		this.frameRate = frameRate;
		frames = new Array<Hash<GrapeFrame>>();
	}
}

class GrapeFrame
{
	public var x:Float;
	public var y:Float;
	public var scaleX:Float;
	public var scaleY:Float;
	public var angle:Float;
	public var visible:Bool;
	
	public function new()
	{
		x = 0;
		y = 0;
		scaleX = 1;
		scaleY = 1;
		angle = 0;
		visible = true;
	}
}