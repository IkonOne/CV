package com.maskedpixel.mathsushi;

import nme.net.URLRequest;
import com.haxepunk.Engine;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.RenderMode;
import com.maskedpixel.mathsushi.scenes.MainMenuScene;
import com.maskedpixel.mathsushi.scenes.RestaurantScene;
import com.maskedpixel.mathsushi.scenes.TestAtlas;
import com.maskedpixel.util.SiteLock;
import nme.display.StageScaleMode;
import nme.Lib;

#if mathNook 
import com.mathnook.as3.MNServices;
import com.mathnook.as3.MNConstants;
#end

/**
 * ...
 * @author Erin M Gunn
 */

class Main extends Engine
{
	public static inline var kScreenWidth:Int = 640;
	public static inline var kScreenHeight:Int = 360;
	public static inline var kFrameRate:Int = 30;
	public static inline var kClearColor:Int = 0x336799;
	public static inline var kProjectName:String = "HaxePunk";

	function new()
	{
		super(kScreenWidth, kScreenHeight, kFrameRate, false);
		
#if mathNook
		MNServices.connect("7f100561", this, onError);
#end
	}
	
	override public function init()
	{
#if (mathNook && !debug)
		if (!SiteLock.permitted(["mathnook.com", "edupup.com", "mathangle.com", "mathnookarabia.com"]))
		{
			//Lib.getURL(new URLRequest("http://www.mathnook.com"));
			return;
		}
#end
		//
//#if debug
 	//#if flash
 		//if (flash.system.Capabilities.isDebugger)
 	//#end
 		//{
 			HXP.console.enable();
 		//}
//#end
		//SiteLock.permitted(["flashgamelicense.com"]);
#if !flash
		HXP.renderMode.unset(RenderMode.BUFFER);
		HXP.renderMode.set(RenderMode.HARDWARE);
#end
		G.Configure();
		GS.Initialize();
		HXP.defaultFont = "font/StickRiceTest.ttf";
		HXP.scene = new MainMenuScene();
		
	}
	
	
#if mathNook
	private function onError():Void
	{
		//trace(MNServices.getLastError());
	}
#end

	public static function main()
	{
		var app = new Main();
	}
}