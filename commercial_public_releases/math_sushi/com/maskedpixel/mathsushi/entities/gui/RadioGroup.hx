package com.maskedpixel.mathsushi.entities.gui;
import com.maskedpixel.mathsushi.G;
import nme.geom.Rectangle;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.maskedpixel.util.BehaviourEntity;
import com.maskedpixel.mathsushi.behaviours.Clicked;
import com.maskedpixel.util.graphics.NineSlice;

/**
 * ...
 * @author Erin M Gunn
 */

class RadioGroup extends BehaviourEntity
{
	public var clicked(default, null):Clicked;
	public var options(default, null):Array<String>;
	
	public var selectedString(get_selectedString, never):String;
	private function get_selectedString():String { return options[selected]; }
	
	public var selected(default, setSelected):Int;
	private function setSelected(value:Int):Int
	{
		value = cast HXP.clamp(value, 0, options.length);
		selected = value;
		_graphicTarget = cast(selected, Float) * _optionSize - halfWidth + _optionSize / 2;
		return selected;
	}

	public function new(X:Float = 0, Y:Float = 0, Width:Float = 1, Height:Float = 1, Options:Array<String>)
	{
		super(X, Y);
		
		if (Options == null) throw "Options must be passed to a RadioGroup in the constructor";
		options = Options;
		_optionSize = Width / options.length;
		selected = 0;
		
		//var img:Image = new Image(HXP.createBitmap(cast Width, cast Height));
		//img.centerOrigin();
		//setHitboxTo(img);
		//centerOrigin();
		
		var bg:NineSlice = new NineSlice(G.getSource("gfx/gui/BambooButton.png"), new Rectangle(10, 10, 190, 80));
		bg.width = Math.floor(Width);
		bg.height = Math.floor(Height);
		bg.color = 0x00DDDD;
		bg.centerOrigin();
		setHitboxTo(bg);
		centerOrigin();
		
		// _selectedGraphic = Image.createRect(cast _optionSize * 0.9, cast height * 0.8, 0xCCCCCC);
		_selectedGraphic = new NineSlice(G.getSource("gfx/gui/Panel.png"), new Rectangle(10, 10, 80, 30));
		_selectedGraphic.width = Math.floor(_optionSize * 0.9);
		_selectedGraphic.height = Math.floor(height * 0.8);
		_selectedGraphic.alpha = 0.5;
		_selectedGraphic.centerOrigin();
		_selectedGraphic.x = _graphicTarget;
		
		_gList = new Graphiclist([bg, _selectedGraphic]);
		var txt:Text;
		for (op in options)
		{
			txt = new Text(op);
			txt.size = G.getTextScale(24);
			txt.centerOrigin();
			txt.x = cast(Lambda.indexOf(options, op), Float) * _optionSize - halfWidth + _optionSize / 2;
			_gList.add(txt);
		}
		graphic = _gList;
		
		clicked = cast addBehaviour(new Clicked());
		clicked.onClicked.bindVoid(onClicked);
	}
	
	override public function added():Void
	{
		selected = 0;
		_selectedGraphic.x = _graphicTarget;
	}
	
	override public function update():Void
	{
		super.update();
		
		if (_selectedGraphic.x != _graphicTarget)
			_selectedGraphic.x = HXP.lerp(_selectedGraphic.x, _graphicTarget, HXP.elapsed * 15);
	}
	
	private function onClicked():Void
	{
		selected = Math.floor((scene.mouseX - left) / _optionSize);
	}
	
	private var _selectedGraphic:NineSlice;
	private var _graphicTarget:Float;
	private var _optionSize:Float;
	private var _gList:Graphiclist;
}