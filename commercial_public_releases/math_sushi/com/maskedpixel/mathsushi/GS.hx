package com.maskedpixel.mathsushi;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.tweens.misc.MultiVarTween;

/**
 * ...
 * @author ...
 */

class GS 
{

	public static function Initialize():Void
	{
		MUSIC = new Sfx("music/135_full_pure-china_0115.mp3");
#if !noSound
		MUSIC.loop(0.5);
#end
		
		WRONG_ANSWER = new Sfx("sfx/gui/WrongAnswer.mp3");
		RIGHT_ANSWER = new Sfx("sfx/gui/RightAnswer.mp3");
		START_GAME = new Sfx("sfx/gui/GameStart.mp3");
		GAME_OVER = new Sfx("sfx/sensei/youKnowMathSushi.mp3");
		TAKE_ORDER = new Sfx("sfx/sensei/sushiTime1.mp3");
		CHOP_CHOP = new Sfx("sfx/sensei/chopChop1.mp3");
		MMM_SUSHI1 = new Sfx("sfx/sensei/mmmSushi1.mp3");
		//SUSHI1 = new Sfx("sfx/sensei/sushi1.mp3");
		CHA_CHING = new Sfx("sfx/sensei/CashRegister.mp3");
		YOU_KNOW_MATH_SUSHI = new Sfx("sfx/sensei/youKnowMathSushi.mp3");
		COUNTDOWN = new Sfx("sfx/gui/Countdown.mp3");
	}
	
	public static function playMusic(?volume:Float = 1):Void
	{
#if noSound
		//trace("no Music");
#else
		MUSIC.loop(volume * (MUSIC_VOLUME ? 1 : 0));
#end
	}
	
	public static function playSfx(sfx:Sfx, ?volume:Float = 1):Void
	{
#if noSound
		//trace("no Sound");
#else
		sfx.play(volume * (SFX_VOLUME ? 1 : 0));
#end
	}
	
	static public function setMusicVolume(vol:Float, ?time:Float = 0):Void
	{
		GS.MUSIC_MAX_VOLUME = vol;
		var v:Float = vol * (MUSIC_VOLUME ? 1 : 0);
		if (v == 0 && MUSIC_TWEEN != null) MUSIC_TWEEN.cancel();
		if (time == 0) MUSIC.volume = v;
		else
		{
			MUSIC_TWEEN = HXP.tween(MUSIC, { volume:v }, time);
		}
	}
	
	public static var MUSIC:Sfx;
	
	public static var WRONG_ANSWER:Sfx;
	public static var RIGHT_ANSWER:Sfx;
	public static var START_GAME:Sfx;
	public static var GAME_OVER:Sfx;
	public static var TAKE_ORDER:Sfx;
	public static var CHOP_CHOP:Sfx;
	public static var MMM_SUSHI1:Sfx;
	//public static var SUSHI1:Sfx;
	public static var CHA_CHING:Sfx;
	public static var YOU_KNOW_MATH_SUSHI:Sfx;
	public static var COUNTDOWN:Sfx;
	
	public static var SFX_VOLUME:Bool = true;
	public static var MUSIC_VOLUME:Bool = true;
	public static var MUSIC_MAX_VOLUME:Float = 0.5;
	private static var MUSIC_TWEEN:MultiVarTween;
}