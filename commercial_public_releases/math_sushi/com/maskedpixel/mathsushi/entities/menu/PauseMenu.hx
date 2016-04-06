package com.maskedpixel.mathsushi.entities.menu;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.entities.gui.Button;
import com.maskedpixel.mathsushi.entities.gui.BambooButton;
import com.maskedpixel.mathsushi.entities.gui.Logo;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.LVL;
import com.maskedpixel.mathsushi.scenes.MainMenuScene;

/**
 * ...
 * @author Erin M Gunn
 */

class PauseMenu extends InGameMenu
{
	public function new()
	{
		super();
		
		_resumeButton = new BambooButton(HXP.halfWidth, HXP.halfHeight, HXP.width / 3 * 0.8, HXP.height / 6 * 0.8, "Resume");
		_resumeButton.clicked.onClicked.bindVoid(onResume);
		
		_menuButton = new BambooButton(HXP.halfWidth, HXP.halfHeight + HXP.halfHeight / 3, HXP.width / 3 * 0.8, HXP.height / 6 * 0.8, "Main Menu");
		_menuButton.clicked.onClicked.bindVoid(onMainMenu);
		
		name = G.NAME_PAUSE_MENU;
	}
	
	override public function added():Void
	{
		super.added();
		
		scene.add(_resumeButton);
		scene.add(_menuButton);
		
		G.PauseGame();
	}
	
	override public function removed():Void
	{
		super.removed();
		
		scene.remove(_resumeButton);
		scene.remove(_menuButton);
		
		G.ResumeGame();
	}
	
	private function onResume():Void
	{
		scene.remove(this);
	}
	
	private function onMainMenu():Void
	{
		HXP.scene = new MainMenuScene();
	}
	
	private var _toggleMusic:Button;
	private var _toggleSound:Button;
	private var _resumeButton:BambooButton;
	private var _menuButton:BambooButton;
}