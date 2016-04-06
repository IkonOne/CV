package com.maskedpixel.util.graphics;
import com.haxepunk.graphics.atlas.AtlasRegion;
import com.maskedpixel.mathsushi.behaviours.Clicked;
import flash.geom.Point;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import flash.display.BitmapData;
import flash.geom.Rectangle;

/**
 * ...
 * @author Erin M Gunn
 */

class NineSlice extends Graphic
{
	public var originX:Int;
	public var originY:Int;
	
	public var scaleX(default, null):Float;
	public var scaleY(default, null):Float;
	
	public var color(getColor, setColor):Int;
	private function getColor():Int { return _color; }
	private function setColor(value:Int):Int
	{
		if (value == _color) return _color;
		_color = value;
		_isDirty = true;
		return _color;
	}
	
	public var angle(getAngle, setAngle):Float;
	private function getAngle():Float { return _angle; }
	private function setAngle(value:Float):Float
	{
		if (value == _angle) return _angle;
		_angle = value;
		_isDirty = true;
		return _angle;
	}
	
	public var width(getWidth, setWidth):Float;
	private function getWidth():Float { return _width; }
	private function setWidth(value:Float):Float
	{
		if (value == _width) return _width;
		_width = value;
		_isDirty = true;
		return _width;
	}
	
	public var height(getHeight, setHeight):Float;
	private function getHeight():Float { return _height; }
	private function setHeight(value:Float):Float
	{
		if (value == _height) return _height;
		_height = value;
		_isDirty = true;
		return _height;
	}
	
	public var alpha(getAlpha, setAlpha):Float;
	private function getAlpha():Float { return _alpha; }
	private function setAlpha(value:Float):Float
	{
		if (value == _alpha) return _alpha;
		_alpha = value;
		_isDirty = true;
		return _alpha;
	}

	public function new(source:Dynamic, ?clipRect:Rectangle)
	{
		super();
		
		if (Std.is(source, BitmapData) || Std.is(source, AtlasRegion)) _source = source;
		else if (Std.is(source, String)) _source = HXP.getBitmap(source);
		_sourceWidth = Reflect.getProperty(_source, "width");
		_sourceHeight = Reflect.getProperty(_source, "height");
		_width = HXP.clamp(_sourceWidth, 3, Math.POSITIVE_INFINITY);
		_height = HXP.clamp(_sourceHeight, 3, Math.POSITIVE_INFINITY);
		_angle = 0;
		_color = 0xFFFFFF;
		_alpha = 1;
		
		if (clipRect == null) clipRect = new Rectangle(1, 1, _sourceWidth - 2, _sourceHeight - 2);
		_clipRect = clipRect;
		
		_topLeft      = new Image(_source, new Rectangle(0				, 0					, _clipRect.left			, _clipRect.top));
		_topCenter    = new Image(_source, new Rectangle(_clipRect.left	, 0					, _clipRect.width			, _clipRect.top));
		_topRight     = new Image(_source, new Rectangle(_clipRect.right, 0					, _sourceWidth - _clipRect.right	, _clipRect.top));
		_centerLeft   = new Image(_source, new Rectangle(0				, _clipRect.top		, _clipRect.left			, _clipRect.height));
		_centerCenter = new Image(_source, new Rectangle(_clipRect.left	, _clipRect.top		, clipRect.width			, clipRect.height));
		_centerRight  = new Image(_source, new Rectangle(_clipRect.right, _clipRect.top		, _sourceWidth - _clipRect.right	, _clipRect.height));
		_bottomLeft   = new Image(_source, new Rectangle(0				, _clipRect.bottom	, _clipRect.x				, _sourceHeight - _clipRect.bottom));
		_bottomCenter = new Image(_source, new Rectangle(_clipRect.left	, _clipRect.bottom	, _clipRect.width			, _sourceHeight - _clipRect.bottom));
		_bottomRight  = new Image(_source, new Rectangle(_clipRect.right, _clipRect.bottom	, _sourceWidth - _clipRect.right	, _sourceHeight - _clipRect.bottom));
		
		_topLeft.x = 0; _topLeft.y = 0;
		_topCenter.x = _clipRect.left; _topCenter.y = 0;
		_topRight.x = _clipRect.right; _topRight.y = 0;
		_centerLeft.x = 0; _centerLeft.y = _clipRect.top;
		_centerCenter.x = _clipRect.left; _centerCenter.y = _clipRect.top;
		_centerRight.x = _clipRect.right; _centerRight.y = _clipRect.top;
		_bottomLeft.x = 0; _bottomLeft.y = _clipRect.bottom;
		_bottomCenter.x = _clipRect.left; _bottomCenter.y = _clipRect.bottom;
		_bottomRight.x = _clipRect.right; _bottomRight.y = _clipRect.bottom;
		
		_isDirty = true;
	}
	
	override public function render(target:BitmapData, point:Point, camera:Point):Void
	{
		if (_isDirty) calculateRendering();
		doRender(target, point, camera);
	}
	
	public function centerOrigin():Void
	{
		_isDirty = _isCentered = true;
		calculateRendering();
	}
	
	private function calculateRendering():Void
	{
		_isDirty = false;
		
		_topLeft.color = _topCenter.color = _topRight.color = _centerLeft.color = _centerCenter.color = _centerRight.color = _bottomLeft.color = _bottomCenter.color = _bottomRight.color = _color;
		_topLeft.alpha = _topCenter.alpha = _topRight.alpha = _centerLeft.alpha = _centerCenter.alpha = _centerRight.alpha = _bottomLeft.alpha = _bottomCenter.alpha = _bottomRight.alpha = _alpha;
		
		scaleX = (_width - (_clipRect.left + (_sourceWidth - _clipRect.right))) / _clipRect.width;
		scaleY = (_height - (_clipRect.top + (_sourceHeight - _clipRect.bottom))) / _clipRect.height;
		
		if (_isCentered)
		{
			_isCentered = false;
			originX = Std.int(width / 2);
			originY = Std.int(height / 2);
		}
		
		_topCenter.scaleX = scaleX;
		_centerLeft.scaleY = scaleY;
		_centerCenter.scaleX = scaleX;
		_centerCenter.scaleY = scaleY;
		_centerRight.scaleY = scaleY;
		_bottomCenter.scaleX = scaleX;
		
		// half
		var hw:Int = Math.floor(_clipRect.left);
		var hh:Int = Math.floor(_clipRect.top);
		// half-scaled
		var hsw:Int = Math.floor(_clipRect.left + _clipRect.width * scaleX);
		var hsh:Int = Math.floor(_clipRect.top + _clipRect.height * scaleY);
		
		_topLeft.x 		= 0; 	_topLeft.y = 0;
		_topCenter.x 	= hw; 	_topCenter.y = 0;
		_topRight.x 	= hsw; 	_topRight.y = 0;
		_centerLeft.x 	= 0; 	_centerLeft.y = hh;
		_centerCenter.x = hw; 	_centerCenter.y = hh;
		_centerRight.x 	= hsw;	_centerRight.y = hh;
		_bottomLeft.x 	= 0;	_bottomLeft.y = hsh;
		_bottomCenter.x = hw;	_bottomCenter.y = hsh;
		_bottomRight.x 	= hsw;	_bottomRight.y = hsh;
		
		if (angle != 0)
		{
			HXP.point.x = originX;
			HXP.point.y = originY;
			
			HXP.rotateAround(_topLeft, HXP.point, angle);
			HXP.rotateAround(_topCenter, HXP.point, angle);
			HXP.rotateAround(_topRight, HXP.point, angle);
			HXP.rotateAround(_centerLeft, HXP.point, angle);
			HXP.rotateAround(_centerCenter, HXP.point, angle);
			HXP.rotateAround(_centerRight, HXP.point, angle);
			HXP.rotateAround(_bottomLeft, HXP.point, angle);
			HXP.rotateAround(_bottomCenter, HXP.point, angle);
			HXP.rotateAround(_bottomRight, HXP.point, angle);
			
			_topLeft.angle = _topCenter.angle = _topRight.angle = _centerLeft.angle = _centerCenter.angle = _centerRight.angle = _bottomLeft.angle = _bottomCenter.angle = _bottomRight.angle = angle;
		}
	}
	
	private function doRender(target:BitmapData, point:Point, camera:Point)
	{
		point.x = Math.floor(point.x);
		point.y = Math.floor(point.y);
		this.x = Math.floor(this.x);
		this.y = Math.floor(this.y);
		_point.x = point.x + this.x - originX;
		_point.y = point.y + this.y - originY;
		
		
		if (_topLeft.visible) _topLeft.render(target, _point, camera);
		if (_topCenter.visible) _topCenter.render(target, _point, camera);
		if (_topRight.visible) _topRight.render(target, _point, camera);
		if (_centerLeft.visible) _centerLeft.render(target, _point, camera);
		if (_centerCenter.visible) _centerCenter.render(target, _point, camera);
		if (_centerRight.visible) _centerRight.render(target, _point, camera);
		if (_bottomLeft.visible) _bottomLeft.render(target, _point, camera);
		if (_bottomCenter.visible) _bottomCenter.render(target, _point, camera);
		if (_bottomRight.visible) _bottomRight.render(target, _point, camera);
	}
	
	private var _topLeft:Image;
	private var _topCenter:Image;
	private var _topRight:Image;
	private var _centerLeft:Image;
	private var _centerCenter:Image;
	private var _centerRight:Image;
	private var _bottomLeft:Image;
	private var _bottomCenter:Image;
	private var _bottomRight:Image;
	
	private var _source:Dynamic;
	private var _sourceWidth:Float;
	private var _sourceHeight:Float;
	private var _clipRect:Rectangle;
	private var _width:Float;
	private var _height:Float;
	private var _isCentered:Bool;
	private var _isDirty:Bool;
	private var _angle:Float;
	private var _color:Int;
	private var _alpha:Float;
}