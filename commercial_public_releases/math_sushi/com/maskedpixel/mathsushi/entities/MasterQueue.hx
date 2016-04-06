package com.maskedpixel.mathsushi.entities;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.entities.masterstates.MasterLevelFive;
import com.maskedpixel.mathsushi.entities.masterstates.MasterLevelFour;
import com.maskedpixel.mathsushi.entities.masterstates.MasterLevelOne;
import com.maskedpixel.mathsushi.entities.masterstates.MasterLevelSix;
import com.maskedpixel.mathsushi.entities.masterstates.MasterLevelThree;
import com.maskedpixel.mathsushi.entities.masterstates.MasterLevelTwo;
import com.maskedpixel.mathsushi.entities.masterstates.MasterState;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.util.BehaviourEntity;
import com.maskedpixel.util.StateMachine;
import com.maskedpixel.mathsushi.entities.quiz.MathProblem;

/**
 * ...
 * @author Erin M Gunn
 */

class MasterQueue extends BehaviourEntity
{
	public var activeCustomers(default, null):Array<Customer>;
	public var inactiveCustomers(default, null):Array<Customer>;
	
	public var onGameOver:Void -> Void;

	public function new() 
	{
		super();
		
		type = G.TYPE_MASTER_QUEUE;
		_gameOver = false;
		
		activeCustomers = new Array<Customer>();
		inactiveCustomers = new Array<Customer>();
		var c:Customer;
		for (i in 0...G.NUM_SEATS) 
		{
			c = new Customer();
			c.onLeft.bind(onCustomerLeft);
			inactiveCustomers.push(c);
		}
		
		_stateMachine = cast addBehaviour(new StateMachine());
		_stateMachine.addState(new MasterLevelOne(this));
		_stateMachine.addState(new MasterLevelTwo(this));
		_stateMachine.addState(new MasterLevelThree(this));
		_stateMachine.addState(new MasterLevelFour(this));
		_stateMachine.addState(new MasterLevelFive(this));
		_stateMachine.addState(new MasterLevelSix(this));
		_stateMachine.transitionTo(MasterLevelOne.NAME);
	}
	
	public function addCustomer(difficulty:ProblemDifficulty):Void
	{
		if (_gameOver)
		{
			for (c in activeCustomers) 
			{
				c.active = false;
			}
			return;
		}
		var c:Customer = inactiveCustomers[0];
		if (!inactiveCustomers.remove(c)) return;
		activeCustomers.push(c);
		scene.add(c);
		c.problemDef.difficulty = difficulty;
		c.problemDef.operator.init();
		c.problemDef.operator.set(G.PROBLEM_DEF.chooseOperator());
		c.enterImmediately = true;
	}
	
	private function onCustomerLeft(c:Customer):Void
	{
		if (!activeCustomers.remove(c)) return;
		inactiveCustomers.push(c);
		if (!_gameOver && !c.wasServed && onGameOver != null)
		{
			_gameOver = true;
			onGameOver();
		}
		
		cast(_stateMachine.currentState, MasterState).customerLeft(c);
	}
	
	private var _stateMachine:StateMachine;
	private var _gameOver:Bool;
}