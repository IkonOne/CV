package com.maskedpixel.mathsushi.entities;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.entities.gui.BambooButton;
import com.maskedpixel.mathsushi.entities.gui.Score;
import com.maskedpixel.mathsushi.entities.menu.GameOverMenu;
import com.maskedpixel.mathsushi.entities.menu.PauseMenu;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.util.BehaviourEntity;

/**
 * ...
 * @author Erin M Gunn
 */

class GameHUD extends Entity
{
	public var isGameOver(default, null):Bool;

	public function new(gameOverMenu:GameOverMenu)
	{
		super();
		
		_score = new Score(0, 0, cast HXP.width / 3, cast HXP.height / 10);
		
		isGameOver = false;
		_pauseMenu = new PauseMenu();
		
		_gameOverMenu = gameOverMenu;
		_gameOverMenu.setScore(_score);
	}
	
	override public function added():Void
	{
		isGameOver = false;
		scene.add(_score);
	}
	
	override public function removed():Void
	{
		scene.remove(_score);
	}
	
	public function gameOver():Void
	{
		scene.add(_gameOverMenu);
		isGameOver = true;
	}
	
	public function pauseGame():Void
	{
		if(!isGameOver && scene.getInstance(G.NAME_PAUSE_MENU) == null) scene.add(_pauseMenu);
	}
	
	private var _pauseMenu:PauseMenu;
	private var _gameOverMenu:GameOverMenu;
	
	private var _score:Score;
}