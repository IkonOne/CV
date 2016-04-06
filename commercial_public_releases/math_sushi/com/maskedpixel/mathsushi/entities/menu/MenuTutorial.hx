package com.maskedpixel.mathsushi.entities.menu;

import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.maskedpixel.mathsushi.behaviours.Clicked;
import com.maskedpixel.mathsushi.entities.Bar;
import com.maskedpixel.mathsushi.entities.Customer;
import com.maskedpixel.mathsushi.entities.gui.BambooButton;
import com.maskedpixel.mathsushi.entities.Server;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.util.graphics.NineSlice;
import nme.geom.Rectangle;

/**
 * ...
 * @author Erin M Gunn
 */
class MenuTutorial extends Entity
{
	public var menuClicked(get_menuClicked, never):Clicked;
	private inline function get_menuClicked():Clicked { return _menuButton.clicked; }

	public function new() 
	{
		super();
		
		x = HXP.halfWidth;
		y = HXP.height * 0.9;
		
		_messagePanel = new NineSlice(G.getSource("gfx/gui/Panel.png"), new Rectangle(10, 10, 80, 30));
		_messagePanel.alpha = 0.8;
		_messagePanel.width = HXP.width * 0.9;
		_messagePanel.height = HXP.height * 0.2;
		_messagePanel.centerOrigin();
		addGraphic(_messagePanel);
		
		_message = new Text("Tutorial Text");
		_message.size = G.getTextScale(32);
		_message.centerOrigin();
		addGraphic(_message);
		
		_customer = new Customer();
		_customer.enterImmediately = true;
		_customer.eatTime = 2;
		
		_menuButton = new BambooButton(HXP.width * 0.8, y, HXP.width * 0.15, HXP.height * 0.15, "Menu");
	}
	
	override public function added():Dynamic 
	{
		_server = new Server();
		scene.add(_server);
		_bar = cast scene.getInstance(G.NAME_BAR);
		
		scene.updateLists();
		
		stepOne();
	}
	
	override public function removed():Void
	{
		scene.remove(_server);
	}
	
	private function changeMessage(msg:String):Void
	{
		_message.text = msg;
		_message.centerOrigin();
	}
	
	private function stepOne():Void
	{
		changeMessage("Touch anywhere to move.");
		
		_server.moveState.onComplete.bindVoid(stepTwo);
	}
	
	private function stepTwo():Void
	{
		scene.add(_customer);
		_customer.seat = _bar.seats[3];
		
		_server.moveState.onComplete.unbindVoid(stepTwo);
		_customer.stateMachine.onStateChanged.bindVoid(stepThree);
	}
	
	private function stepThree():Void
	{
		if (_customer.currentState != CustomerState.WaitToOrder) return;
		_customer.stateMachine.onStateChanged.unbindVoid(stepThree);
		
		changeMessage("Move to the Customer to take their order.");
		
		_server.moveState.onComplete.bindVoid(stepFour);
	}
	
	private function stepFour():Void
	{
		if (_server.currentCustomer == null) return;
		
		changeMessage("Answer the math problem to take the Customer order.");
		
		_server.moveState.onComplete.unbindVoid(stepFour);
		_customer.stateMachine.onStateChanged.bindVoid(stepFive);
	}
	
	private function stepFive():Void
	{
		if (_customer.currentState != CustomerState.WaitForFood) return;
		
		changeMessage("Move to the Sushi Prep Station to prepare Customer orders.");
		
		_customer.stateMachine.onStateChanged.unbindVoid(stepFive);
		_server.stateMachine.onStateChanged.bindVoid(stepSix);
	}
	
	private function stepSix():Void
	{
		if (_server.stateMachine.currentState.name != Std.string(ServerState.PrepFood)) return;
		
		changeMessage("Answer the math problem to prepare the order.");
		
		_server.stateMachine.onStateChanged.unbindVoid(stepSix);
		_server.stateMachine.onStateChanged.bindVoid(stepSeven);
	}
	
	private function stepSeven():Void
	{
		changeMessage("Take the order to the Customer.");
		
		_server.stateMachine.onStateChanged.unbindVoid(stepSeven);
		_server.moveState.onComplete.bindVoid(stepEight);
	}
	
	private function stepEight():Void
	{
		if (_server.currentCustomer == null) return;
		
		changeMessage("Wait for the Customer to finish eating.");
		
		_server.moveState.onComplete.unbindVoid(stepEight);
		_customer.stateMachine.onStateChanged.bindVoid(stepNine);
	}
	
	private function stepNine():Void
	{
		changeMessage("Bill the Customer and collect your tip.");
		
		_customer.stateMachine.onStateChanged.unbindVoid(stepNine);
		_customer.stateMachine.onStateChanged.bindVoid(stepTen);
	}
	
	private function stepTen():Void
	{
		changeMessage("Now you are ready to master your Math Sushi skills!");
		
		scene.add(_menuButton);
		scene.updateLists();
	}
	
	private var _bar:Bar;
	private var _server:Server;
	private var _customer:Customer;
	private var _messagePanel:NineSlice;
	private var _message:Text;
	private var _menuButton:BambooButton;
}