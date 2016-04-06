package com.maskedpixel.mathsushi.entities.gui;
import com.haxepunk.graphics.Graphiclist;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.util.BehaviourEntity;
import com.maskedpixel.util.graphics.NineSlice;
import nme.geom.Rectangle;

import com.maskedpixel.mathsushi.behaviours.Clicked;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;

/**
 * ...
 * @author Erin M Gunn
 */

class CheckBoxGroup extends BehaviourEntity
{
	public var requireOne:Bool = false;
	public var clicked(default, null):Clicked;
	public var options(default, null):Array<String>;
	
	public var selections(default, null):Array<Bool>;
	public var numSelected(default, null):Int;
	
	public var selected(default, setSelected):Int;
	private function setSelected(value:Int):Int
	{
		selected = cast HXP.clamp(value, 0, options.length);
		return selected;
	}

	public function new(X:Float = 0, Y:Float = 0, Width:Float = 1, Height:Float = 1, Options:Array<String>)
	{
		super(X, Y);
		
		if (Options == null) throw "Options must be passed to a CheckBoxGroup in the constructor";
		options = Options;
		_optionSize = Width / options.length;
		selected = 0;
		numSelected = 1;
		//centerOrigin();
		
		var ns:NineSlice = new NineSlice(G.getSource("gfx/gui/Panel.png"), new Rectangle(10, 10, 80, 30));
		ns.width = Width;
		ns.height = Height;
		ns.alpha = 0.8;
		ns.centerOrigin();
		setHitbox(cast Width, cast Height);
		addGraphic(ns);
		centerOrigin();
		
		selections = new Array<Bool>();
		_selectedList = new Graphiclist();
		_unselectedList = new Graphiclist();
		_textList = new Graphiclist();
		var txt:Text;
		//var sel:Image;
		var sel:NineSlice;
		var unsel:NineSlice;
		var op:String;
		for (i in 0...options.length)
		{
			op = options[i];
			selections.push(false);
			
			//sel = Image.createRect(cast _optionSize * 0.9, cast height * 0.8, 0xCCCCCC);
			//sel.centerOrigin();
			//sel.x = cast(i, Float) * _optionSize - halfWidth + _optionSize / 2;
			//sel.visible = selections[i];
			//_selectedList.add(sel);
			
			sel = new NineSlice(G.getSource("gfx/gui/BambooButton.png"), new Rectangle(10, 10, 190, 80));
			sel.width = _optionSize * 0.9;
			sel.height = cast height * 0.8;
			sel.centerOrigin();
			sel.color = 0x00FFFF;
			sel.x = cast(i, Float) * _optionSize - halfWidth + _optionSize / 2;
			sel.visible = selections[i];
			_selectedList.add(sel);
			
			unsel = new NineSlice(G.getSource("gfx/gui/BambooButtonFlipped.png"), new Rectangle(10, 10, 190, 80));
			unsel.width = _optionSize * 0.9;
			unsel.height = cast height * 0.8;
			unsel.centerOrigin();
			unsel.color = 0x00AAAA;
			unsel.x = cast(i, Float) * _optionSize - halfWidth + _optionSize / 2;
			unsel.visible = !selections[i];
			_unselectedList.add(unsel);
			
			txt = new Text(op);
			txt.size = G.getTextScale(24);
			//txt.color = 0;
			txt.centerOrigin();
			txt.x = cast(i, Float) * _optionSize - halfWidth + _optionSize / 2;
			_textList.add(txt);
		}
		
		addGraphic(_unselectedList);
		addGraphic(_selectedList);
		addGraphic(_textList);
		
		clicked = cast addBehaviour(new Clicked());
		clicked.onClicked.bindVoid(onClicked);
	}
	
	public function setSelection(idx:Int, set:Bool):Void
	{
		if (selections[idx] == set) return;
		selections[idx] = set;
		_selectedList.children[idx].visible = set;
	}
	
	private function onClicked():Void
	{
		selected = Math.floor((scene.mouseX - left) / _optionSize);
		
		numSelected += selections[selected] ? -1 : 1;
		if (requireOne && numSelected == 0)
		{
			numSelected++;
			return;
		}
		
		selections[selected] = !selections[selected];
		_selectedList.children[selected].visible = selections[selected];
		_unselectedList.children[selected].visible = !selections[selected];
	}
	
	private var _graphicTarget:Float;
	private var _optionSize:Float;
	private var _textList:Graphiclist;
	private var _selectedList:Graphiclist;
	private var _unselectedList:Graphiclist;
}