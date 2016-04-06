package com.maskedpixel.mathsushi.entities.masterstates;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.entities.Customer;
import com.maskedpixel.mathsushi.entities.MasterQueue;
import com.maskedpixel.util.State;

/**
 * ...
 * @author Erin M Gunn
 */

class MasterState extends State
{

	public function new(masterQueue:MasterQueue, name:String="MasterState") 
	{
		super(name);
		_masterQueue = masterQueue;
		_elapsed = 0;
	}
	
	public function customerLeft(c:Customer):Void
	{
		
	}
	
	override public function update():Void 
	{
		_elapsed += HXP.elapsed;
	}
	
	private var _elapsed:Float;
	private var _masterQueue:MasterQueue;
}