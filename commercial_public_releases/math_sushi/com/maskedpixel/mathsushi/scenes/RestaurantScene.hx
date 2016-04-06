package com.maskedpixel.mathsushi.scenes;

import com.haxepunk.Engine;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.Scene;
import com.maskedpixel.mathsushi.entities.Bar;
import com.maskedpixel.mathsushi.entities.Countdown;
import com.maskedpixel.mathsushi.entities.Customer;
import com.maskedpixel.mathsushi.entities.CustomerQueue;
import com.maskedpixel.mathsushi.entities.GameHUD;
import com.maskedpixel.mathsushi.entities.MasterQueue;
import com.maskedpixel.mathsushi.entities.menu.GameOverMenuMaster;
import com.maskedpixel.mathsushi.entities.MuteButtons;
import com.maskedpixel.mathsushi.entities.Server;
import com.maskedpixel.mathsushi.entities.ShiftTimer;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.GS;
import com.maskedpixel.util.graphics.MCRenderer;
import flash.events.Event;

/**
 * ...
 * @author Erin M Gunn
 */

class RestaurantScene extends Scene
{
	public function new()
	{
		super();
		
		_gameHud = new GameHUD(new GameOverMenuMaster());
		_shiftTimer = new ShiftTimer();
		_shiftTimer.onShiftOver.bindVoid(onShiftOver);
	}
	
	override public function begin():Void
	{
		var server:Server = cast add(new Server());
		add(new Bar());
		var mq:MasterQueue = cast add(new MasterQueue());
		mq.onGameOver = onShiftOver;
		add(_gameHud);
		add(new MuteButtons());
		
		updateLists();
		
		var cd:Countdown = cast add(new Countdown());
		cd.completeCallback = onCountdownComplete;
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
	
	override public function focusLost():Void
	{
		_gameHud.pauseGame();
	}
	
	private function onCountdownComplete():Void
	{
		G.ResumeGame();
		GS.playSfx(GS.START_GAME);
	}
	
	private function onShiftOver():Void
	{
		_gameHud.gameOver();
	}
	
	private var _gameHud:GameHUD;
	private var _shiftTimer:ShiftTimer;
}