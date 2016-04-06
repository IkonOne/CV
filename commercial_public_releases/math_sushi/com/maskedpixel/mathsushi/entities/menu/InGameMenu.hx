package com.maskedpixel.mathsushi.entities.menu;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.entities.gui.Logo;
import com.maskedpixel.mathsushi.G;
import com.haxepunk.graphics.Text;


/**
 * ...
 * @author Erin M Gunn
 */

class InGameMenu extends Entity
{

	public function new()
	{
		super();
		
		layer = G.LAYER_GUI;
		
		_fadeBG = new Image(G.getSource("gfx/gui/Panel.png"));
		_fadeBG.scaleX = HXP.width / _fadeBG.width * 2;
		_fadeBG.scaleY = HXP.height / _fadeBG.height * 2;
		_fadeBG.x = HXP.halfWidth - _fadeBG.scaledWidth / 2;
		_fadeBG.y = HXP.halfHeight - _fadeBG.scaledHeight / 2;
		_fadeBG.alpha = 0.8;
		graphic = _fadeBG;
		
		_logo = new Logo();
		
		_levelInfo = new Text("Null", HXP.halfWidth, HXP.height * 0.28);
		_levelInfo.size = 32;
		_levelInfo.resizable = true;
		_levelInfo.relative = false;
		addGraphic(_levelInfo);
	}
	
	override public function added():Void
	{
		var t:Array<Entity> = [];
		for (s in G.TYPES_TO_PAUSE)
		{
			scene.getType(s, t);
			for (e in t)
			{
				e.active = false;
				if (e.graphic != null) e.graphic.active = false;
			}
			HXP.clear(t);
		}
		
		scene.add(_logo);
		
		_levelInfo.text = LVL.LEVEL_INFO;
		_levelInfo.centerOrigin();
		_levelInfo.updateBuffer();
	}
	
	override public function removed():Void
	{
		var t:Array<Entity> = [];
		for (s in G.TYPES_TO_PAUSE)
		{
			scene.getType(s, t);
			for (e in t)
			{
				e.active = true;
				if (e.graphic != null) e.graphic.active = true;
			}
			HXP.clear(t);
		}
		
		scene.remove(_logo);
	}
	
	private var _fadeBG:Image;
	private var _logo:Logo;
	private var _levelInfo:Text;
}