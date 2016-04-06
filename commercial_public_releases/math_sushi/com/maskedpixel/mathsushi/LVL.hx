package com.maskedpixel.mathsushi;

import com.haxepunk.HXP;
import com.haxepunk.utils.Data;
import nme.Assets;
//import com.maskedpixel.mathsushi.entities.MathProblem.ProblemDifficulty;
import com.maskedpixel.mathsushi.entities.quiz.MathProblem;

/**
 * ...
 * @author Erin M Gunn
 */

class LVL
{
	static public var LEVEL_INFO(getLevelInfo, null):String;
	static private function getLevelInfo():String
	{
		return SETS[_currentSet] + " Level " + Std.string(_currentLevel + 1);
	}
	
	static public var SETS(getSets, null):Array<String>;
	static private function getSets():Array<String>
	{
		return _levels.sets;
	}
	
	static public var LEVELS(getLevels, null):Hash<Array<Xml>>;
	static private function getLevels():Hash<Array<Xml>>
	{
		return _levels.levels;
	}
	
	static public var CURRENT_LEVEL(getCurrentLevel, never):Int;
	static private function getCurrentLevel():Int
	{
		return _currentLevel;
	}
	
	static public var CURRENT_SET(getCurrentGroup, never):Int;
	static private function getCurrentGroup():Int
	{
		return _currentSet;
	}
	
	static public var CURRENT_RATING(getCurrentRating, setCurrentRating):Int;
	static private function getCurrentRating():Int
	{
		return Data.readInt("Set" + Std.string(_currentSet) + "Level" + Std.string(_currentLevel), 0);
	}
	static private function setCurrentRating(value:Int):Int
	{
		value = cast HXP.clamp(value, getCurrentRating(), 3);
		Data.write("Set" + Std.string(_currentSet) + "Level" + Std.string(_currentLevel), value);
		Data.save("com.maskedpixelgames.mathsushi", true);
		
		return value;
	}
	
	static public function Configure():Void
	{
		_levels = new LevelParser(Xml.parse(Assets.getText("xml/Levels.xml")));
		
		_currentLevel = 0;
		_currentSet = 0;
		
		Data.load("com.maskedpixelgames.mathsushi");
	}
	
	static public function GetCurrentLevel():Xml
	{
		return _levels.getLevelXml(_currentSet, _currentLevel);
	}
	
	static public function SetCurrentLevel(set:Int, level:Int):Bool
	{
		if (!_levels.exists(set, level)) return false;
		_currentLevel = level;
		_currentSet = set;
		
		var xml:Xml = _levels.getLevelXml(_currentSet, _currentLevel);
		//G.PROBLEM_DEF.difficulty = Type.createEnum(ProblemDifficulty, xml.get("difficulty"));
		G.PROBLEM_DEF.operator.init();
		var ops:Array<String> = xml.get("type").split(";");
		for (op in ops)
		{
			G.PROBLEM_DEF.operator.set(Type.createEnum(ProblemOp, op));
		}
		
		return true;
	}
	
	static public function GetLevelExists(set:Int, level:Int):Bool
	{
		return _levels.exists(set, level);
	}
	
	static private var _levels:LevelParser;
	static private var _currentLevel:Int;
	static private var _currentSet:Int;
}