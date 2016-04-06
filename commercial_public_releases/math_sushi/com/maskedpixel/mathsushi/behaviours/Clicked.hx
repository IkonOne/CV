package com.maskedpixel.mathsushi.behaviours;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.maskedpixel.util.Behaviour;
import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;
import nme.geom.Point;

/**
 * ...
 * @author Erin M Gunn
 */

class Clicked extends Behaviour
{
	public var hotKeys(default, null):Array<Int>;
	
	public var onPressed(default, null):Signaler<Clicked>;
	public var onReleased(default, null):Signaler<Clicked>;
	public var onClicked(default, null):Signaler<Clicked>;
	public var onEnter(default, null):Signaler<Clicked>;
	public var onLeave(default, null):Signaler<Clicked>;

	public function new()
	{
		super();
		
		hotKeys = new Array<Int>();
		
		onPressed = new DirectSignaler(this);
		onReleased = new DirectSignaler(this);
		onClicked = new DirectSignaler(this);
		onEnter = new DirectSignaler(this);
		onLeave = new DirectSignaler(this);
		
		_mousePos = new Point();
	}
	
	override public function update():Void
	{
		_mousePos.x = parent.scene.mouseX;
		_mousePos.y = parent.scene.mouseY;
		if (_isInside != parent.collidePoint(parent.x, parent.y, parent.scene.mouseX, parent.scene.mouseY))
		{
			if (_isInside)
			{
				onLeave.dispatch(this);
			}
			else
			{
				onEnter.dispatch(this);
			}
			
			_isInside = !_isInside;
		}
		
		if (Input.mousePressed)
		{
			if (_isInside)
			{
				_onPressedInside = true;
				onPressed.dispatch(this);
			}
		}
		
		if (Input.mouseReleased)
		{
			if (_isInside && _onPressedInside)
			{
				_onPressedInside = false;
				onClicked.dispatch(this);
				onReleased.dispatch(this);
			}
		}
		
		if (hotKeys.length > 0)
		{
			var key:Int;
			var pressed:Bool = false;
			var release:Bool = false;
			for (key in hotKeys)
			{
				pressed = pressed || Input.pressed(key);
				release = release || Input.released(key);
				
				if (pressed && release) break;
			}
			
			if (pressed) onPressed.dispatch(this);
			if (release)
			{
				onClicked.dispatch(this);
				onReleased.dispatch(this);
				if (!_isInside) onLeave.dispatch(this);
			}
		}
	}
	
	private var _isInside:Bool;
	private var _onPressedInside:Bool;
	private var _mousePos:Point;
}