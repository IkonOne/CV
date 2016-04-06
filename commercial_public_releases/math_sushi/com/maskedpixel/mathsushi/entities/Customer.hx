package com.maskedpixel.mathsushi.entities;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.Alarm;
import com.maskedpixel.mathsushi.behaviours.GrapeSheetPlayer;
import com.maskedpixel.mathsushi.behaviours.AnimPlayer;
import com.maskedpixel.mathsushi.entities.customerstates.CustomerEating;
import com.maskedpixel.mathsushi.entities.customerstates.CustomerEnter;
import com.maskedpixel.mathsushi.entities.customerstates.CustomerLeave;
import com.maskedpixel.mathsushi.entities.quiz.MathProblem;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.graphics.SatisfactionBar;
import com.maskedpixel.util.BehaviourEntity;
import com.maskedpixel.util.graphics.GrapeSheet;
import com.maskedpixel.util.graphics.MCRenderer;
import com.maskedpixel.util.graphics.IAnimation;
import com.maskedpixel.util.State;
import com.maskedpixel.util.StateMachine;
import com.maskedpixel.mathsushi.behaviours.MoveToTarget;
import com.maskedpixel.mathsushi.behaviours.Clicked;
import com.maskedpixel.mathsushi.ProblemDef;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;


/**
 * ...
 * @author Erin M Gunn
 */

enum CustomerState
{
	Entering;
	WaitToOrder;
	Ordering;
	WaitForFood;
	Eating;
	WaitForBill;
	Leaving;
}

class Customer extends BehaviourEntity
{
	public var problemDef:ProblemDef;
	public var enterImmediately:Bool;
	
	public var onLeft(default, null):Signaler<Customer>;
	public var onBilled(default, null):Signaler<Customer>;
	public var move(default, null):MoveToTarget;
	public var wasServed(default, null):Bool;
	
	public var eatTime(get_eatTime, set_eatTime):Float;
	private inline function get_eatTime():Float { return _eating.eatTime; }
	private inline function set_eatTime(value:Float):Float
	{
		_eating.eatTime = value;
		return value;
	}
	
	public var mcPlayer(getMcGraphic, never):AnimPlayer;
	private function getMcGraphic():AnimPlayer { return _animPlayer; }
	
	public var satisfaction(default, setSatisfaction):Float;
	private function setSatisfaction(value:Float):Float
	{
		value = HXP.clamp(value, 0, G.CUSTOMER_SATISFACTION);
		if (value == satisfaction) return satisfaction;
		satisfaction = value;
		
		// Leave the seat if not served.
		if (_stateMachine.currentState != null)
		{
			if (satisfaction == 0 && (_stateMachine.currentState.name == Std.string(CustomerState.WaitToOrder) || _stateMachine.currentState.name == Std.string(CustomerState.WaitForBill)))
			{
				_stateMachine.transitionTo(Std.string(CustomerState.Leaving));
				wasServed = false;
			}
		}
		
		// Update the Satisfaction bar.
		_satisfactionBar.percentage = HXP.clamp(satisfaction / G.CUSTOMER_SATISFACTION, 0.01, 1);
		if (_satisfactionBar.percentage > 0.5)
			_satisfactionBar.fgColor = HXP.colorLerp(0xFFFF00, 0x00FF00, (_satisfactionBar.percentage - 0.5) * 2);
		else
			_satisfactionBar.fgColor = HXP.colorLerp(0xFF0000, 0xFFFF00, _satisfactionBar.percentage * 2);
		
		return satisfaction;
	}
	
	public var seat(default, setSeat):Seat;
	private function setSeat(s:Seat):Seat
	{
		if (s == seat) return seat;
		if(seat != null) seat.customer = null;
		seat = s;
		if(seat != null) seat.customer = this;
		return seat;
	}
	
	public var currentState(getState, never):CustomerState;
	private function getState():CustomerState
	{
		if (_stateMachine.currentState == null) return null;
		return Type.createEnum(CustomerState, _stateMachine.currentState.name);
	}
	
	public var stateMachine(get_stateMachine, never):StateMachine;
	private inline function get_stateMachine():StateMachine { return _stateMachine; }
	
	public function new()
	{
		super();
		
		onLeft = new DirectSignaler(this);
		onBilled = new DirectSignaler(this);
		move = cast addBehaviour(new MoveToTarget());
		move.speed = 300;
		
		problemDef = new ProblemDef();
		
		_stateMachine = cast addBehaviour(new StateMachine());
		_stateMachine.onStateChanged.bindVoid(onStateChanged);
		_stateMachine.addState(new CustomerEnter(this));
		_stateMachine.addState(new State(Std.string(CustomerState.WaitToOrder)));
		_stateMachine.addState(new State(Std.string(CustomerState.Ordering)));
		_stateMachine.addState(new State(Std.string(CustomerState.WaitForFood)));
		_eating = cast _stateMachine.addState(new CustomerEating(this));
		_eating.eatTime = G.CUSTOMER_EAT_TIME;
		_eating.onComplete.bindVoid(onEatingComplete);
		_stateMachine.addState(new State(Std.string(CustomerState.WaitForBill)));
		_leaving = cast _stateMachine.addState(new CustomerLeave(this));
		_leaving.onComplete.bindVoid(onLeaveComplete);
		
#if flash
		_animEasy = new MCRenderer("Flashets:CustomerEasy");
		_animMedium = new MCRenderer("Flashets:CustomerMedium");
		_animHard = new MCRenderer("Flashets:CustomerHard");
#else
		_animEasy = new GrapeSheet("sheets/customereasy/sheets.xml", "sheets/customereasy/animations.xml", G.getAtlas());
		_animMedium = new GrapeSheet("sheets/customermedium/sheets.xml", "sheets/customermedium/animations.xml", G.getAtlas());
		_animHard = new GrapeSheet("sheets/customerhard/sheets.xml", "sheets/customerhard/animations.xml", G.getAtlas());
#end
		_animEasy.scale = _animMedium.scale = _animHard.scale = 0.6;
		_animEasy.originY = _animMedium.originY = _animHard.originY = 40;
		_currentAnim = _animEasy.getGraphic();
		_gList =  new Graphiclist([_currentAnim]);
		addGraphic(_gList);
		_animPlayer = cast addBehaviour(new AnimPlayer(_animEasy, "CustomerEnter"));
		
		
		setHitbox(cast G.PLAYER_HEIGHT / 2, cast G.PLAYER_HEIGHT / 2, 0, 0);
		centerOrigin();
		
		_satisfactionBar = new SatisfactionBar();
		_satisfactionBar.bgColor = 0;
		_satisfactionBar.fgColor = 0x00FF00;
		_satisfactionBar.width = width;
		_satisfactionBar.height = cast height / 4;
		_satisfactionBar.borderSize = 3;
		_satisfactionBar.centerOO();
		_satisfactionBar.y = halfHeight;
		addGraphic(_satisfactionBar);
		
		_stateLabel = new Text("Entering");
		_stateLabel.centerOrigin();
		_stateLabel.resizable = true;
		_stateLabel.color = 0;
		
		_enterAlarm = new Alarm(1, onEnterAlarm, TweenType.Persist);
		addTween(_enterAlarm);
	}
	
	override public function added():Void
	{
		layer = G.LAYER_CUSTOMER;
		type = G.TYPE_CUSTOMER;
		
		move.active = false;
		visible = false;
		
		if (enterImmediately) _enterAlarm.reset(0.1);
		else _enterAlarm.reset(HXP.rand(10) + 2);
		enterImmediately = false;
		
		y = HXP.height + height;
		
		satisfaction = G.CUSTOMER_SATISFACTION;
		_satisfactionBar.fgColor = 0x00FF00;
		wasServed = false;
		
		switch(problemDef.difficulty)
		{
			case ProblemDifficulty.Easy:
				// _currentAnim = _animEasy.getGraphic();
				setAnim(_animEasy);
			
			case ProblemDifficulty.Medium:
				// _currentAnim = _animMedium.getGraphic();
				setAnim(_animMedium);
				
			case ProblemDifficulty.Hard:
				// _currentAnim = _animHard.getGraphic();
				setAnim(_animHard);
		}
		
		// _gList.children[0] = _currentAnim;
		// _animPlayer.movieClip = _currentAnim;
		_animPlayer.play("CustomerEnter");
	}
	
	override public function removed():Void
	{
		if(_enterAlarm.active) removeTween(_enterAlarm);
		onLeft.dispatch(this);
	}
	
	override public function update():Void
	{
		super.update();
		
		if (_stateMachine.currentState == null) return;
		if (_stateMachine.currentState != _eating && _stateMachine.currentState.name != Std.string(CustomerState.Ordering))
		{
			satisfaction -= HXP.elapsed;
		}
	}
	
	public function takingOrder():Void
	{
		this.satisfaction = G.CUSTOMER_SATISFACTION;
		_stateMachine.transitionTo(Std.string(CustomerState.Ordering));
		wasServed = true;
	}
	
	public function orderTaken():Void
	{
		_stateMachine.transitionTo(Std.string(CustomerState.WaitForFood));
	}
	
	public function foodDelivered():Void
	{
		this.satisfaction = G.CUSTOMER_SATISFACTION;
		_stateMachine.transitionTo(Std.string(CustomerState.Eating));
	}
	
	public function billed():Void
	{
		_stateMachine.transitionTo(Std.string(CustomerState.Leaving));
		onBilled.dispatch(this);
	}
	
	public function foodIsRead():Void
	{
		_animPlayer.play("FoodIsReady");
	}
	
	private function onEnterAlarm(e:Dynamic):Void
	{
		visible = true;
		_stateMachine.transitionTo(Std.string(CustomerState.Entering));
		satisfaction = G.CUSTOMER_SATISFACTION;
	}
	
	private function onEatingComplete():Void
	{
		_stateMachine.transitionTo(Std.string(CustomerState.WaitForBill));
	}
	
	private function onLeaveComplete():Void
	{
		seat.customerLeft(this);
		seat = null;
		scene.remove(this);
		scene.updateLists();
	}
	
	private function onStateChanged():Void
	{
		_stateLabel.text = _stateMachine.currentState.name;
		_stateLabel.centerOrigin();
		_animPlayer.play(_stateMachine.currentState.name);
	}

	private function setAnim(iAnim:IAnimation):Void
	{
		_currentAnim = iAnim.getGraphic();
		_animPlayer.anim = iAnim;
		_gList.children[0] = _currentAnim;
		_currentAnim.setEntity(this);
	}
	
	private var _stateMachine:StateMachine;
	private var _eating:CustomerEating;
	private var _leaving:CustomerLeave;
	private var _enterAlarm:Alarm;
	private var _stateLabel:Text;
	private var _satisfactionBar:SatisfactionBar;
	private var _gList:Graphiclist;
	private var _grapeSheet:GrapeSheet;
	private var _grapeSheetEasy:GrapeSheet;
	private var _grapeSheetMedium:GrapeSheet;
	private var _grapeSheetHard:GrapeSheet;
	private var _grapePlayer:GrapeSheetPlayer;
	private var _currentAnim:Graphic;
	private var _animEasy:IAnimation;
	private var _animMedium:IAnimation;
	private var _animHard:IAnimation;
	private var _animPlayer:AnimPlayer;
}