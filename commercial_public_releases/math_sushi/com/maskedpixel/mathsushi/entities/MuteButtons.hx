package com.maskedpixel.mathsushi.entities;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.maskedpixel.mathsushi.behaviours.Clicked;
import com.maskedpixel.mathsushi.entities.menu.PauseMenu;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.GS;
import com.maskedpixel.mathsushi.scenes.LevelScene;
import com.maskedpixel.mathsushi.scenes.RestaurantScene;
import com.maskedpixel.util.BehaviourEntity;

/**
 * ...
 * @author Erin M Gunn
 */

class MuteButtons extends Entity
{

	public function new() 
	{
		super();
		
		var clicked:Clicked;
		var img:Image;
		
		_sfxToggle = new BehaviourEntity(HXP.width * 0.95, HXP.height * 0.05);
		clicked = cast _sfxToggle.addBehaviour(new Clicked());
		clicked.onClicked.bindVoid(onSfxToggled);
		img = new Image(G.getSource("gfx/gui/MuteSfx.png"));
		img.centerOrigin();
		img.scale = (HXP.height * 0.05) / img.height;
		_sfxToggle.addGraphic(img);
		_sfxToggle.setHitbox(cast img.scaledWidth * 1.2, cast img.scaledHeight * 1.2);
		_sfxToggle.centerOrigin();
		
		img = new Image(G.getSource("gfx/gui/MuteX.png"));
		img.centerOrigin();
		img.scale = (HXP.height * 0.05) / img.height;
		_sfxToggle.addGraphic(img);
		_sfxX = img;
		
		_musicToggle = new BehaviourEntity(HXP.width * 0.9, HXP.height * 0.05);
		clicked = cast _musicToggle.addBehaviour(new Clicked());
		clicked.onClicked.bindVoid(onMusicToggled);
		img = new Image(G.getSource("gfx/gui/MuteMusic.png"));
		img.centerOrigin();
		img.scale = (HXP.height * 0.05) / img.height;
		_musicToggle.addGraphic(img);
		_musicToggle.setHitbox(cast img.scaledWidth * 1.2, cast img.scaledHeight * 1.2);
		_musicToggle.centerOrigin();
		img = new Image(G.getSource("gfx/gui/MuteX.png"));
		img.centerOrigin();
		img.scale = (HXP.height * 0.05) / img.height;
		_musicToggle.addGraphic(img);
		_musicX = img;
		
		_pauseButton = new BehaviourEntity(HXP.width * 0.85, HXP.height * 0.05);
		clicked = cast _pauseButton.addBehaviour(new Clicked());
		clicked.onClicked.bindVoid(onPauseClicked);
		img = new Image(G.getSource("gfx/gui/PauseButton.png"));
		img.centerOrigin();
		img.scale = (HXP.height * 0.05) / img.height;
		_pauseButton.addGraphic(img);
		_pauseButton.setHitbox(cast img.scaledWidth * 1.2, cast img.scaledHeight * 1.2);
		_pauseButton.centerOrigin();
		_pauseButton.type = G.TYPE_PAUSE_BUTTON;
		
		_pauseMenu = new PauseMenu();
	}
	
	private function onPauseClicked():Void
	{
		if(scene.getInstance(G.NAME_PAUSE_MENU) == null) scene.add(_pauseMenu);
	}
	
	override public function added():Void 
	{
		scene.add(_sfxToggle);
		_sfxX.visible = !GS.SFX_VOLUME;
		
		scene.add(_musicToggle);
		_musicX.visible = !GS.MUSIC_VOLUME;
		
		if (Std.is(HXP.scene, LevelScene) || Std.is(HXP.scene, RestaurantScene)) scene.add(_pauseButton);
	}
	
	override public function removed():Void 
	{
		scene.remove(_sfxToggle);
		scene.remove(_musicToggle);
		scene.remove(_pauseButton);
	}
	
	private function onSfxToggled():Void
	{
		GS.SFX_VOLUME = !GS.SFX_VOLUME;
		_sfxX.visible = !GS.SFX_VOLUME;
	}
	
	private function onMusicToggled():Void
	{
		GS.MUSIC_VOLUME = !GS.MUSIC_VOLUME;
		_musicX.visible = !GS.MUSIC_VOLUME;
		GS.setMusicVolume(GS.MUSIC_MAX_VOLUME);
	}
	
	private var _sfxToggle:BehaviourEntity;
	private var _sfxX:Image;
	
	private var _musicToggle:BehaviourEntity;
	private var _musicX:Image;
	
	private var _pauseButton:BehaviourEntity;
	private var _pauseMenu:PauseMenu;
}