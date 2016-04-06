package com.maskedpixel.mathsushi.scenes;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.maskedpixel.mathsushi.entities.gui.SushiRating;
import com.maskedpixel.mathsushi.entities.menu.MenuDojo;
import com.maskedpixel.mathsushi.entities.menu.MenuMain;
import com.maskedpixel.mathsushi.entities.menu.MenuMaster;
import com.maskedpixel.mathsushi.entities.menu.MenuTutorial;
import com.maskedpixel.mathsushi.entities.MuteButtons;
import com.maskedpixel.mathsushi.GS;

/**
 * ...
 * @author Erin M Gunn
 */

class MainMenuScene extends Scene
{
	public function new()
	{
		super();
		
		_main = new MenuMain();
		_main.masterClicked.onClicked.bindVoid(onMasterClicked);
		_main.dojoClicked.onClicked.bindVoid(onDojoClicked);
		_main.tutorialClicked.onClicked.bindVoid(onTutorialClicked);
		
		_master = new MenuMaster();
		_master.backClicked.onClicked.bindVoid(onMainClicked);
		
		_dojo = new MenuDojo();
		_dojo.backClicked.onClicked.bindVoid(onMainClicked);
		
		_tutorial = new MenuTutorial();
		_tutorial.menuClicked.onClicked.bindVoid(onMainClicked);
	}
	
	override public function begin():Void
	{
		changeMenu(_main);
		add(new MuteButtons());
		
		GS.setMusicVolume(0.5, 1);
	}
	
	override public function end():Dynamic 
	{
		removeAll();
	}
	
	override public function update():Void
	{
		super.update();
	}
	
	private function onMainClicked():Void
	{
		changeMenu(_main);
	}
	
	private function changeMenu(next:Entity):Void
	{
		if (_currentMenu != null) remove(_currentMenu);
		_currentMenu = add(next);
	}
	
	private function onDojoClicked():Void
	{
		changeMenu(_dojo);
	}
	
	private function onMasterClicked():Void
	{
		changeMenu(_master);
	}
	
	private function onTutorialClicked():Void
	{
		_main.hideMaster();
		changeMenu(_tutorial);
	}
	
	private var _master:MenuMaster;
	private var _main:MenuMain;
	private var _dojo:MenuDojo;
	private var _tutorial:MenuTutorial;
	
	private var _currentMenu:Entity;
}