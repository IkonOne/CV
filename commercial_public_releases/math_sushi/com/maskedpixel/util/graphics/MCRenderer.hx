package com.maskedpixel.util.graphics;

import com.haxepunk.HXP;
import nme.Assets;
import format.display.MovieClip;
import nme.geom.Point;
import com.haxepunk.Graphic;
import nme.display.BitmapData;
import nme.display.BlendMode;
import nme.geom.ColorTransform;
import nme.geom.Matrix;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

/**
 * ...
 * @author Erin M Gunn
 */

class MCRenderer extends Graphic, implements IAnimation
{
	private static var _playing:Array<MovieClip> = new Array<MovieClip>();
	
	public static function pause():Void
	{
		for (clip in _playing) 
		{
			clip.stop();
		}
	}
	
	public static function resume():Void
	{
		for (clip in _playing) 
		{
			clip.gotoAndPlay(clip.currentFrame);
		}
	}
	
	public static function clearClips():Void
	{
		HXP.clear(_playing);
	}
	
	/**
	 * Rotation of the image, in degrees.
	 */
	public var angle:Float;

	/**
	 * Scale of the image, effects both x and y scale.
	 */
	public var scale:Float;

	/**
	 * X scale of the image.
	 */
	public var scaleX:Float;

	/**
	 * Y scale of the image.
	 */
	public var scaleY:Float;

	/**
	 * X origin of the image, determines transformation point.
	 */
	public var originX:Float;

	/**
	 * Y origin of the image, determines transformation point.
	 */
	public var originY:Float;

	/**
	 * Optional blend mode to use when drawing this image.
	 * Use constants from the flash.display.BlendMode class.
	 */
	public var blend:BlendMode;

	/**
	 * If the image should be drawn transformed with pixel smoothing.
	 * This will affect drawing performance, but look less pixelly.
	 */
	public var smooth:Bool;
	
	public var onComplete(default, null):Signaler<IAnimation>;

	public var currentAnim(getCurrentAnim, null):String;
	public function getCurrentAnim():String { return _currentAnim != null ? _currentAnim.name : ""; }

	public var isLooping(getIsLooping, null):Bool;
	public function getIsLooping():Bool { return _isLooping; }
	
	public var movieClip(getMovieClip, never):MovieClip;
	private function getMovieClip():MovieClip { return _mc; }

	public function new(movieClip:Dynamic)
	{
		super();
		
		if (Std.is(movieClip, String))
		{
			_mc = Assets.getMovieClip(movieClip);
		}
		else if (Std.is(movieClip, MovieClip))
		{
			_mc = movieClip;
		}
		
		if (_mc == null) throw "Could not convert to movieClip: " + Std.string(movieClip);
		
		_mc.stop();
		
		angle = 0;
		scale = scaleX = scaleY = 1;
		originX = originY = 0;
		_matrix = HXP.matrix;
		_colorTransform = new ColorTransform();
		active = true;
		onComplete = new DirectSignaler(this);
		_wasPlaying = false;
		_isLooping = false;
		
		_anims = new Hash<MCAnim>();
		var anim:MCAnim;
		var anims = new Array<MCAnim>();
		for (label in _mc.currentLabels) 
		{
			anim = new MCAnim(label.name, label.frame, _mc.totalFrames - 1);
			_anims.set(anim.name, anim);
			anims.push(anim);
		}
		anims.sort(function(a:MCAnim, b:MCAnim):Int { return HXP.sign(a.startFrame - b.startFrame); } );
		
		for (i in 0...anims.length - 1)
		{
			anims[i].endFrame = anims[i + 1].startFrame - 1;
		}
	}
	
	public function play(anim:String):Dynamic
	{
		if (!_anims.exists(anim)) throw "Animation does not exist: " + anim;
		_currentAnim = _anims.get(anim);
		_mc.gotoAndPlay(_currentAnim.startFrame);
		_isLooping = false;
		
		if (Lambda.indexOf(_playing, _mc) == -1) _playing.push(_mc);

		return _currentAnim;
	}
	
	public function loop(anim:String):Dynamic
	{
		if (!_anims.exists(anim)) throw "Animation does not exist: " + anim;
		_currentAnim = _anims.get(anim);
		_mc.gotoAndPlay(_currentAnim.startFrame);
		_isLooping = true;
		
		if (Lambda.indexOf(_playing, _mc) == -1) _playing.push(_mc);

		return _currentAnim;
	}
	
	override public function update():Dynamic 
	{
		if (_currentAnim != null)
		{
			if (_mc.currentFrame >= _currentAnim.endFrame)
			{
				if (_isLooping) loop(_currentAnim.name);
				else
				{
					_mc.gotoAndStop(_currentAnim.endFrame);
					onComplete.dispatch(this);
				}
			}
		}
	}
	
	override public function render(target:BitmapData, point:Point, camera:Point)
	{
		if (!active && !_wasPlaying)
		{
			_wasPlaying = true;
			_mc.stop();
		}
		else if (active && _wasPlaying)
		{
			_mc.play();
			_wasPlaying = false;
		}
		
		// determine drawing location
		_point.x = point.x + x - originX - camera.x * scrollX;
		_point.y = point.y + y - originY - camera.y * scrollY;
		
		_matrix.b = _matrix.c = 0;
		_matrix.a = scaleX * scale;
		_matrix.d = scaleY * scale;
		_matrix.tx = -originX * _matrix.a;
		_matrix.ty = -originY * _matrix.d;
		if (angle != 0) _matrix.rotate(angle * HXP.RAD);
		_matrix.tx += originX + _point.x;
		_matrix.ty += originY + _point.y;
		target.draw(_mc, _matrix, _colorTransform, blend, null, smooth);
	}
	
	public function stop():Void
	{
		_mc.stop();
		
		_playing.remove(_mc);
	}
	
	public function hasAnimation(anim:String):Bool
	{
		return _anims.exists(anim);
	}

	public function getGraphic():Graphic
	{
		return this;
	}
	
	private var _mc:MovieClip;
	private var _anims:Hash<MCAnim>;
	private var _matrix:Matrix;
	private var _colorTransform:ColorTransform;
	private var _wasPlaying:Bool;
	private var _isLooping:Bool;
	private var _currentAnim:MCAnim;
}

class MCAnim
{
	public var name:String;
	public var startFrame:Int;
	public var endFrame:Int;
	
	public function new(name:String, startFrame:Int, endFrame:Int)
	{
		this.name = name;
		this.startFrame = startFrame;
		this.endFrame = endFrame;
	}
}