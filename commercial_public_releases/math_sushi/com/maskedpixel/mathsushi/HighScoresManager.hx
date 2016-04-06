package com.maskedpixel.mathsushi;
import com.haxepunk.HXP;
import com.haxepunk.utils.Data;

/**
 * ...
 * @author Erin M Gunn
 */

class HighScoresManager 
{
	
	static public function checkHighScore(mode:String, score:Int):Bool
	{
		return Data.readInt(mode) < score;
	}
	
	static public function getHighScore(mode:String):Int
	{
		return Data.readInt(mode);
	}
	
	static public function getHighScoreString(mode:String):String
	{
		var score:Int = Data.readInt(mode);
		var s:String = "$" + Std.string(score / 100);
		return s;
	}
	
	static public function setHighScore(mode:String, score:Int):Bool
	{
		if (!checkHighScore(mode, score)) return false;
		
		Data.write(mode, score);
		Data.save("com.maskedpixelgames.mathsushi");
		
		return true;
	}
}