package com.maskedpixel.mathsushi.scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.maskedpixel.mathsushi.entities.Bar;
import com.maskedpixel.mathsushi.entities.Countdown;
import com.maskedpixel.mathsushi.entities.GameHUD;
import com.maskedpixel.mathsushi.entities.menu.GameOverMenuDojo;
import com.maskedpixel.mathsushi.entities.LevelQueue;
import com.maskedpixel.mathsushi.entities.MuteButtons;
import com.maskedpixel.mathsushi.entities.Server;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.GS;
import com.maskedpixel.util.graphics.MCRenderer;

/**
 * ...
 * @author Erin M Gunn
 */

class LevelScene extends Scene
{
	public function new()
	{
		super();
		_gameHud = new GameHUD(new GameOverMenuDojo());
		_levelQueue = new LevelQueue();
		_levelQueue.onGameOver.bindVoid(_gameHud.gameOver);
	}
	
	override public function begin():Void
	{
		var server:Server = cast add(new Server());
		add(new Bar());
		add(_levelQueue);
		add(_gameHud);
		add(new MuteButtons());
		
		updateLists();
		
		var cd:Countdown = cast add(new Countdown());
		cd.completeCallback = onCountDownComplete;
		G.PauseGame(false);
		server.graphic.active = true;
		
		GS.setMusicVolume(0.1, 3);
	}
	
	override public function end():Dynamic 
	{
		removeAll();
#if flash
		MCRenderer.clearClips();
#end
	}
	
	override public function focusLost():Dynamic 
	{
		_gameHud.pauseGame();
	}
	
	private function onCountDownComplete() 
	{
		G.ResumeGame();
		GS.playSfx(GS.START_GAME);
	}
	
	private var _levelQueue:LevelQueue;
	private var _gameHud:GameHUD;
}