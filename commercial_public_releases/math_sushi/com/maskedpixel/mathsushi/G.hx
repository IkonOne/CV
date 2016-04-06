package com.maskedpixel.mathsushi;

import com.haxepunk.Entity;
import com.haxepunk.graphics.atlas.TextureAtlas;
import com.maskedpixel.mathsushi.entities.Customer;
import com.maskedpixel.util.graphics.MCRenderer;
import haxe.EnumFlags;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.entities.quiz.MathProblem;


/**
 * ...
 * @author Erin M Gunn
 */

class G
{
	static public function Configure():Void
	{
		PROBLEM_DEF = new ProblemDef();
		
		LVL.Configure();

		if (_atlas != null) _atlas.destroy();
		_atlas = TextureAtlas.loadTexturePacker("atlas/atlas.xml");
	}
	
	static public function PauseGame(pauseAnims:Bool = true):Void
	{
		var t:Array<Entity> = new Array<Entity>();
		for (s in TYPES_TO_PAUSE)
		{
			HXP.scene.getType(s, t);
			for (e in t)
			{
				e.active = false;
				if (e.graphic != null) e.graphic.active = false;
				if (Std.is(e, Customer)) cast(e, Customer).mcPlayer.pause();
			}
			HXP.clear(t);
		}
#if flash
		if(pauseAnims) MCRenderer.pause();
#end
	}
	
	static public function ResumeGame():Void
	{
		var t:Array<Entity> = new Array<Entity>();
		for (s in G.TYPES_TO_PAUSE)
		{
			HXP.scene.getType(s, t);
			for (e in t)
			{
				e.active = true;
				if (e.graphic != null) e.graphic.active = true;
				if (Std.is(e, Customer)) cast(e, Customer).mcPlayer.resume();
			}
			HXP.clear(t);
		}
#if flash
		MCRenderer.resume();
#end
	}
	
	static public function getSource(source:String):Dynamic
	{
#if flash
		return HXP.getBitmap(source);
#else
		return _atlas.getRegion(source.substr(4));
#end
	}
	
	static private var _atlas:TextureAtlas;
	static public function getAtlas():TextureAtlas { return _atlas; }
	
	// Problem Settings
	static public var PROBLEM_DEF:ProblemDef;
	
	static public inline var RANGE_ADD:Array<Int> = [10, 100, 1000];
	static public inline var RANGE_SUB:Array<Int> = [10, 100, 1000];
	static public inline var RANGE_MUL:Array<Int> = [10, 15, 100];
	static public inline var RANGE_DIV:Array<Int> = [10, 15, 100];
	
	// Quiz Constants
	static public inline var GUI_NUMBER_SIZE(getNumberSize, never):Int;
	static private function getNumberSize():Int
	{
		return cast HXP.height * 0.9 * 0.9 / 5;
	}
	
	
	// Player Constants
	static public inline var PLAYER_SPEED:Float = 400;
	
	static public inline var PLAYER_HEIGHT(getPlayerHeight, null):Int;
	static private function getPlayerHeight():Int
	{
		return cast HXP.height / 3;
	}
	
	
	// Customer Constants
	static public inline var CUSTOMER_SATISFACTION:Float = 30;
	static public inline var CUSTOMER_EAT_TIME:Float = 5;
	
	static public function getScore(satisfaction:Float):Int
	{
		var score:Int = cast(satisfaction * 10, Int) + 1;
		return score;
	}
	
	// Retaurant Constants.
	static public inline var NUM_SEATS:Int = 6;
	static public inline var SHIFT_DURATION:Float = 120;
	
	static public var STATION_WIDTH(getStationWidth, never):Int;
	static private function getStationWidth():Int
	{
		return cast HXP.width / (NUM_SEATS + 1);
	}
	
	static public var STATION_HEIGHT(getStationHeight, never):Int;
	static private function getStationHeight():Int
	{
		return cast HXP.height / 3 * 2;
	}

	static public function getTextScale(size:Int):Int
	{
		return cast size * Math.min(HXP.screen.fullScaleX, HXP.screen.fullScaleY);
	}
	
	// Layers
	static public inline var LAYER_BACKGROUND:Int = 6000;
	static public inline var LAYER_SERVER:Int = 5000;
	static public inline var LAYER_BAR:Int = 4000;
	static public inline var LAYER_SEAT:Int = 3000;
	static public inline var LAYER_CUSTOMER:Int = 2000;
	
	static public inline var LAYER_GUI_BACKGROUND:Int = 1900;
	static public inline var LAYER_GUI_SERVER:Int = 1100;
	static public inline var LAYER_GUI:Int = 1000;
	static public inline var LAYER_GUI_PARTICLES:Int = 900;
	static public inline var LAYER_GUI_DRAGGING:Int = 500;
	static public inline var LAYER_GUI_TOP:Int = 0;
	

	// Names
	static public inline var NAME_BAR:String = "nameBar";
	static public inline var NAME_SERVER:String = "nameServer";
	static public inline var NAME_PREP_STATION:String = "namePrepStation";
	static public inline var NAME_CUSTOMER_QUEUE:String = "nameCustomerQueue";
	static public inline var NAME_SCORE:String = "nameScore";
	static public inline var NAME_PAUSE_MENU:String = "namePauseMenu";
	
	// Types
	static public inline var TYPES_TO_PAUSE:Array<String> = [TYPE_CUSTOMER, TYPE_CUSTOMER_QUEUE, TYPE_LEVEL_QUEUE, TYPE_MASTER_QUEUE, TYPE_SEAT, TYPE_PREP_STATION, TYPE_SERVER, TYPE_QUIZ_ITEM, TYPE_COUNTDOWN, TYPE_HUD, TYPE_PAUSE_BUTTON];
	
	static public inline var TYPE_SERVER:String = "typeServer";
	static public inline var TYPE_CUSTOMER:String = "typeCustomer";
	static public inline var TYPE_CUSTOMER_QUEUE:String = "typeCustomerQueue";
	static public inline var TYPE_MASTER_QUEUE:String = "typeMasterQueue";
	static public inline var TYPE_SEAT:String = "typeSeat";
	static public inline var TYPE_PREP_STATION:String = "typePrepStation";
	static public inline var TYPE_HUD:String = "typeHUD";
	static public inline var TYPE_QUIZ_ITEM:String = "typeQuizItem";
	static public inline var TYPE_LEVEL_QUEUE:String = "typeLevelQueue";
	static public inline var TYPE_COUNTDOWN:String = "typeCountdown";
	static public inline var TYPE_PAUSE_BUTTON:String = "typePauseButton";
}