package com.maskedpixel.util;
import nme.Lib;

/**
 * ...
 * @author Erin M Gunn
 */

class SiteLock 
{

	public static function permitted(allowed:Array<String>):Bool
	{
		#if flash
			var components:URLParser = URLParser.parse(Lib.current.loaderInfo.url);
		
			var domain:String = components.host.toLowerCase();
			if (domain.substr(0, 4) == "www.")
				domain = domain.substr(4);
			
			for (h in allowed)
			{
				if (domain == h)
				{
					return true;
				}
			}
		#end
		
		return false;
	}
}