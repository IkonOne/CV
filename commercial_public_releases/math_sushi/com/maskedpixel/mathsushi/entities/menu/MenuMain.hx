package com.maskedpixel.mathsushi.entities.menu;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Stamp;
import com.haxepunk.HXP;
import com.haxepunk.Tween;
import com.haxepunk.tweens.motion.CircularMotion;
import com.haxepunk.tweens.TweenEvent;
import com.haxepunk.utils.Ease;
import com.maskedpixel.mathsushi.behaviours.Clicked;
import com.maskedpixel.mathsushi.entities.Bar;
import com.maskedpixel.mathsushi.entities.gui.Logo;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.entities.gui.BambooButton;
import com.maskedpixel.mathsushi.GS;
import com.maskedpixel.mathsushi.scenes.RestaurantScene;
import com.maskedpixel.util.graphics.GrapeSheet;
import com.maskedpixel.util.graphics.IAnimation;
import com.maskedpixel.util.graphics.MCRenderer;
import com.maskedpixel.util.graphics.NineSlice;
import flash.events.Event;
import nme.geom.Rectangle;
import nme.Lib;
import nme.net.URLRequest;

/**
 * ...
 * @author Erin M Gunn
 */

class MenuMain extends Entity
{
	public var masterClicked(getMasterClicked, null):Clicked;
	private function getMasterClicked():Clicked
	{
		return _masterButton.clicked;
	}
	
	public var dojoClicked(getDojoClicked, null):Clicked;
	private function getDojoClicked():Clicked
	{
		return _dojoButton.clicked;
	}
	
	public var tutorialClicked(get_tutorialClicked, null):Clicked;
	private function get_tutorialClicked():Clicked { return _tutorialButton.clicked; }

	public function new()
	{
		super();
		
		var ns:NineSlice = new NineSlice(G.getSource("gfx/gui/Panel.png"), new Rectangle(10, 10, 80, 30));
		ns.alpha = 0.8;
		ns.x = HXP.halfWidth;
		ns.y = HXP.height * 0.85;
		ns.height = HXP.height * 0.25;
		ns.width = Math.floor(HXP.width * 0.9);
		ns.centerOrigin();
		addGraphic(ns);
		
		_masterButton = new BambooButton(HXP.width * 0.2, HXP.height * 0.85, HXP.width * 0.25, 80, "Master");
		_dojoButton = new BambooButton(HXP.width * 0.5, HXP.height * 0.85, HXP.width * 0.25, 80, "Dojo");
		_moreGamesButton = new BambooButton(HXP.width * 0.8, HXP.height * 0.85, HXP.width * 0.25, 80, "More Games");
		_tutorialButton = new BambooButton(HXP.width * 0.8, HXP.height * 0.85, HXP.width * 0.25, 80, "Tutorial");
		
#if flash
		_masterAnimation = new MCRenderer("Flashets:Sensei");
#else
		_masterAnimation = new GrapeSheet("sheets/sensei/sheets.xml", "sheets/sensei/animations.xml", G.getAtlas());
#end
		_masterEntity = new Entity(HXP.halfWidth, G.PLAYER_HEIGHT, _masterAnimation.getGraphic());
		_masterEntity.layer = G.LAYER_SERVER;
		_masterAnimation.loop("Wave");
		_masterAnimation.scale = 0.7;
		_masterAnimation.originY = -HXP.halfHeight * 0.8;
		
		_logo = new Logo();
		_bar = new Bar();
		for (seat in _bar.seats)
		{
			seat.collidable = false;
		}
		
#if mathNook
		_sponsorLogo = new Stamp("logo.png");
		_sponsorLogoEntity = new Entity(HXP.width * 0.75, HXP.halfHeight * 0.5, _sponsorLogo);
		_moreGamesButton.clicked.onClicked.bindVoid(function() {
			Lib.getURL(new URLRequest("http://www.mathnook.com"));
		});
#end
	}
	
	override public function added():Void
	{
		scene.add(_masterButton);
		scene.add(_dojoButton);
		scene.add(#if flash _moreGamesButton #else _tutorialButton #end);
		if(_sponsorLogoEntity != null) scene.add(_sponsorLogoEntity);
		scene.add(_bar);
		scene.add(_logo);
		scene.add(_masterEntity);
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
	override public function removed():Void
	{
		scene.remove(_masterButton);
		scene.remove(_dojoButton);
		scene.remove(#if flash _moreGamesButton #else _tutorialButton #end);
		if(_sponsorLogoEntity != null) scene.remove(_sponsorLogoEntity);
		scene.remove(_logo);
	}
	
	public function hideMaster():Void
	{
		scene.remove(_masterEntity);
	}
	
	private var _bar:Bar;
	
	private var _logo:Logo;
	
	private var _masterButton:BambooButton;
	private var _dojoButton:BambooButton;
	private var _moreGamesButton:BambooButton;
	private var _tutorialButton:BambooButton;
	
	private var _sponsorLogo:Stamp;
	private var _sponsorLogoEntity:Entity;
	
	private var _masterAnimation:IAnimation;
	private var _masterEntity:Entity;
}