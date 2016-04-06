package com.maskedpixel.mathsushi.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.masks.Hitbox;
import com.haxepunk.Sfx;
import com.maskedpixel.mathsushi.behaviours.KeyboardTarget;
import com.maskedpixel.mathsushi.behaviours.MoveToTarget;
import com.maskedpixel.mathsushi.entities.serverstates.ServerBilling;
import com.maskedpixel.mathsushi.entities.serverstates.ServerMove;
import com.maskedpixel.mathsushi.entities.serverstates.ServerPrepFood;
import com.maskedpixel.mathsushi.entities.serverstates.ServerTakeOrder;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.entities.gui.Score;
import com.maskedpixel.mathsushi.GS;
import com.maskedpixel.util.BehaviourEntity;
import com.maskedpixel.util.graphics.GrapeSheet;
import com.maskedpixel.util.graphics.IAnimation;
import com.maskedpixel.util.graphics.MCRenderer;
import com.maskedpixel.util.StateMachine;
import com.maskedpixel.mathsushi.behaviours.Clicked;
import com.maskedpixel.mathsushi.entities.Customer;
import com.maskedpixel.mathsushi.entities.quiz.MathQuiz;
import hsl.haxe.DirectSignaler;
import nme.Assets;

/**
 * ...
 * @author Erin M Gunn
 */

enum ServerState
{
	Move;
	TakeOrder;
	Billing;
	PrepFood;
}

class Server extends BehaviourEntity
{
	public var currentQuiz(default, null):MathQuiz; 
	
	public var hasFoodToPrep(getFoodToPrep, never):Bool;
	private function getFoodToPrep():Bool { return _prepList.length > 0; }
	
	public var currentCustomer(getCurrentCustomer, never):Customer;
	private function getCurrentCustomer():Customer
	{
		return _currCustomer;
	}
	
	public var moveState(getMoveState, never):ServerMove;
	private function getMoveState():ServerMove { return _moveState; }
	
	public var currentAnim(getCurrentAnim, never):String;
	private function getCurrentAnim():String { return _currentAnim; }
	
	public var stateMachine(get_stateMachine, never):StateMachine;
	private function get_stateMachine():StateMachine { return _stateMachine; }
	
	public function new()
	{
		super();
		
		_customers = new Array<Customer>();
		_food = new Array<Customer>();
		_prepList = new Array<Customer>();
		_mouseMoved = false;
		
		addBehaviour(new KeyboardTarget(this));
		_stateMachine = cast addBehaviour(new StateMachine());
		_stateMachine.onStateChanged.bindVoid(onStateChanged);
		_moveState = cast _stateMachine.addState(new ServerMove(this));
		_moveState.onComplete.bindVoid(onMoveComplete);
		_takeOrder = cast _stateMachine.addState(new ServerTakeOrder(this));
		_takeOrder.onComplete.bindVoid(onOrderComplete);
		_prepFood = cast _stateMachine.addState(new ServerPrepFood(this));
		_prepFood.onComplete.bindVoid(onPrepComplete);
		_billing = cast _stateMachine.addState(new ServerBilling(this));
		_billing.onComplete.bindVoid(onBillingComplete);
		_stateMachine.transitionTo(Std.string(ServerState.Move));
	}
	
	override public function added():Void
	{
		layer = G.LAYER_SERVER;
		type = G.TYPE_SERVER;
		name = G.NAME_SERVER;
		
		_celebrations = ["DoublePumpLoop", "SinglePumpLoop", "Wave"];
		
		//_grapeSheet = new GrapeSheet("sheets/sensei/sheets.xml", "sheets/sensei/animations.xml");
		//_grapeSheet.swappableParts.push("HandLeft");
		//_grapeSheet.swappableParts.push("HandRight");
		//graphic = _grapeSheet;
		//_grapeSheet.onComplete.bindVoid(onAnimComplete);
		//_grapeSheet.play("WalkLoop").loop = true;
		//_grapeSheet.originY = -HXP.halfHeight * 0.8;
		//_grapeSheet.smooth = true;
		//_grapeSheet.scale = 0.7;
		//_grapeSheet.updateBuffer();
		
		#if flash
			_anim = new MCRenderer("Flashets:Sensei");
		#else
			_anim = new GrapeSheet("sheets/sensei/sheets.xml", "sheets/sensei/animations.xml", G.getAtlas());
		#end
		graphic = _anim.getGraphic();
		_anim.onComplete.bindVoid(onAnimComplete);
		_anim.loop("WalkLoop");
		_anim.originY = -HXP.halfHeight * 0.8;
		_anim.scale = 0.7;
		
		x = HXP.halfWidth;
		y = G.PLAYER_HEIGHT;
		//tips = 0;
		
		currentQuiz = new MathQuiz();
		
		_foodSounds = new Array<Sfx>();
		_foodSounds.push(GS.MMM_SUSHI1);
		//_foodSounds.push(GS.SUSHI1);
	}
	
	private function onMoveComplete() 
	{
		if (_mouseMoved)
		{
			updateAction();
			if (currentAction != null) currentAction();
		}
	}
	
	public function moveToTarget(t:Entity, clicked:Bool = false):Void
	{
		//_grapeSheet.play("WalkLoop").loop = true;
		_anim.loop("WalkLoop");
		currentAction = null;
		_moveState.moveToTarget(t);
		_mouseMoved = clicked;
	}
	
	public function performAction():Void
	{
		updateAction();
		if (currentAction != null) currentAction();
	}
	
	public function updateAction():Void
	{
		currentAction = null;
		if (_moveState.target == null) return;
		if (Math.floor(_moveState.target.x) != Math.floor(x)) return;
		
		if (_moveState.target.type == G.TYPE_SEAT)
		{
			var seat:Seat = cast _moveState.target;
			if (seat.customer == null) return;
			_currCustomer = seat.customer;
			switch(_currCustomer.currentState)
			{
				case CustomerState.WaitToOrder:
					currentAction = orderAction;
				
				case CustomerState.WaitForFood:
					deliverFood();
					
				case CustomerState.WaitForBill:
					currentAction = billAction;
					
				case CustomerState.Eating:
					currentAction = billAction;
				
				default:
					currentAction = null;
			}
		}
		else if (_moveState.target.type == G.TYPE_PREP_STATION)
		{
			currentAction = prepAction;
		}
	}
	
	private function onAnimComplete():Void
	{
		//_grapeSheet.play(_currentAnim).loop = true;
		_anim.loop(_currentAnim);
	}
	
	private function onStateChanged():Void
	{
		switch(_stateMachine.currentState.name)
		{
			case "Move":
				_currentAnim = "WalkLoop";
			
			case Std.string(ServerState.TakeOrder):
				_currentAnim = "TakingOrderLoop";
				
			case Std.string(ServerState.PrepFood):
				_currentAnim = "JugglingLoop";
			
			case Std.string(ServerState.Billing):
				GS.playSfx(GS.CHA_CHING);
			default:
		}
		//if(_currentAnim != "") _grapeSheet.play(_currentAnim, false, 0, false, 0.25).loop = true;
		if (_currentAnim != "") _anim.loop(_currentAnim);
	}
	
	private function deliverFood():Void
	{
		if (Lambda.has(_food, _currCustomer))
		{
			_currCustomer.foodDelivered();
			_food.remove(_currCustomer);
			
			GS.playSfx(HXP.choose(_foodSounds));
		}
	}
	
	private function orderAction():Void
	{
		_currCustomer.takingOrder();
		_stateMachine.transitionTo(Std.string(ServerState.TakeOrder));
		currentAction = null;
	}
	
	private function billAction():Void
	{
		if (_currCustomer.currentState != CustomerState.WaitForBill) return;
		_stateMachine.transitionTo(Std.string(ServerState.Billing));
		currentAction = null;
	}
	
	private function prepAction():Void
	{
		var prep:PrepStation = cast _moveState.target;
		
		if (_prepList.length == 0) return;
		_currCustomer = _prepList[0];
		_stateMachine.transitionTo(Std.string(ServerState.PrepFood));
	}
	
	private function onOrderComplete():Void
	{
		_stateMachine.transitionTo(Std.string(ServerState.Move));
		_currCustomer.orderTaken();
		_prepList.push(_currCustomer);
	}
	
	private function onPrepComplete():Void
	{
		_prepList.remove(_currCustomer);
		_food.push(_currCustomer);
		_currCustomer.foodIsRead();
		_stateMachine.transitionTo(Std.string(ServerState.Move));
	}
	
	private function onBillingComplete():Void
	{
		_stateMachine.transitionTo(Std.string(ServerState.Move));
		_currCustomer.billed();
		_food.remove(_currCustomer);
		
		var score:Score = cast scene.getInstance(G.NAME_SCORE);
		if (score != null) score.customerBilled(_currCustomer);
	}
	
	private var _stateMachine:StateMachine;
	private var _moveState:ServerMove;
	private var _takeOrder:ServerTakeOrder;
	private var _prepFood:ServerPrepFood;
	private var _billing:ServerBilling;
	private var _currCustomer:Customer;
	private var _customers:Array<Customer>;
	private var _prepList:Array<Customer>;
	private var _food:Array<Customer>;
	private var _foodSounds:Array<Sfx>;
	private var currentAction:Void->Void;
	//private var _grapeSheet:GrapeSheet;
	private var _anim:IAnimation;
	private var _celebrations:Array<String>;
	private var _currentAnim:String;
	private var _celebrationAnim:String;
	private var _mouseMoved:Bool;
}