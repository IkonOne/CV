package com.maskedpixel.mathsushi.entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.World;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.Tween;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.LVL;
import com.maskedpixel.mathsushi.ProblemDef;
import com.maskedpixel.mathsushi.entities.quiz.MathProblem;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

/**
 * ...
 * @author Erin M Gunn
 */

class LevelQueue extends Entity
{
	public var onGameOver(default, null):Signaler<LevelQueue>;
	private var pauseTween:Bool;

	public function new()
	{
		super();
		_xml = LVL.GetCurrentLevel();
		_problemDefs = new Array<ProblemDef>();
		type = G.TYPE_LEVEL_QUEUE;
		
		onGameOver = new DirectSignaler(this);
		_activeCustomers = new Array<Customer>();
		_customers = new Array<Customer>();
		var c:Customer;
		for (i in 0...G.NUM_SEATS)
		{
			c = new Customer();
			c.enterImmediately = true;
			c.onLeft.bind(oncustomerLeft);
			_customers.push(c);
		}
	}
	
	override public function added():Void
	{
		pauseTween = false;
		_currCustomer = 0;
		_totalCustomers = 0;
		
		var c:Xml;
		var customer:Customer;
		var time:Float;
		var def:ProblemDef;
		for (c in _xml.firstElement().iterator())
		{
			if (c.nodeType != Xml.Element) continue;
			_totalCustomers++;
			def = ProblemDef.fromXml(c);
			_problemDefs.push(def);
			time = Std.parseFloat(c.get("time"));
			if (time > 0)
				addTween(new Alarm(time, onCustomerAlarm, TweenType.OneShot), true);
			else
				onCustomerAlarm(null);
			
		}
	}
	
	override public function updateTweens():Void
	{
		if (pauseTween)
		{
			addCustomer();
			return;
		}
		
		super.updateTweens();
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
	public function onCustomerAlarm(e:Dynamic):Void
	{
		addCustomer();
	}
	
	private function addCustomer():Void
	{
		if (_activeCustomers.length == G.NUM_SEATS)
		{
			pauseTween = true;
			return;
		}
		pauseTween = false;
		
		var c:Customer;
		for (c in _customers)
		{
			if (Lambda.has(_activeCustomers, c)) continue;
			scene.add(c);
			_activeCustomers.push(c);
			c.problemDef = _problemDefs[_currCustomer];
			_currCustomer++;
			break;
		}
	}
	
	private function oncustomerLeft(c:Customer):Void
	{
		//if (!_activeCustomers.remove(c)) return;
		_activeCustomers.remove(c);
		if (_activeCustomers.length == 0 && _currCustomer == _totalCustomers) onGameOver.dispatch(this);
	}
	
	private var _xml:Xml;
	private var _customers:Array<Customer>;
	private var _activeCustomers:Array<Customer>;
	private var _problemDefs:Array<ProblemDef>;
	
	private var _currCustomer:Int;
	private var _totalCustomers:Int;
}