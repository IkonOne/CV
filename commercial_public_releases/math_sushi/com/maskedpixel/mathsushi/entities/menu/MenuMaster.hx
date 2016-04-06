package com.maskedpixel.mathsushi.entities.menu;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.behaviours.Clicked;
import com.maskedpixel.mathsushi.entities.gui.BambooButton;
import com.maskedpixel.mathsushi.entities.gui.CheckBoxGroup;
import com.maskedpixel.mathsushi.entities.quiz.MathProblem;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.scenes.RestaurantScene;
import com.maskedpixel.util.graphics.NineSlice;
import nme.geom.Rectangle;

/**
 * ...
 * @author Erin M Gunn
 */

class MenuMaster extends Entity
{
	public var backClicked(getBackClicked, null):Clicked;
	private function getBackClicked():Clicked
	{
		return _backButton.clicked;
	}

	public function new()
	{
		super();
		
		var ns:NineSlice = new NineSlice(G.getSource("gfx/gui/Panel.png"), new Rectangle(10, 10, 80, 30));
		ns.alpha = 0.8;
		ns.x = HXP.halfWidth;
		ns.y = Math.floor(HXP.halfHeight + HXP.halfHeight * 0.475);
		ns.width = HXP.width * 0.95;
		ns.height = HXP.halfHeight;
		ns.centerOrigin();
		ns.relative = false;
		addGraphic(ns);
		
		var t:Text = new Text("Choose Operations to Master.");
		t.resizable = true;
		t.size = G.getTextScale(32);
		t.centerOrigin();
		t.x = HXP.halfWidth;
		t.y = HXP.halfHeight * 0.2;
		t.relative = false;
		
		ns = new NineSlice(G.getSource("gfx/gui/Panel.png"), new Rectangle(10, 10, 80, 30));
		ns.alpha = 0.8;
		ns.x = t.x;
		ns.y = t.y;
		ns.width = t.width * 1.1;
		ns.height = t.height * 1.15;
		ns.centerOrigin();
		addGraphic(ns);
		addGraphic(t);
		
		_startButton = new BambooButton(HXP.width - HXP.halfWidth / 2, HXP.height * 0.85, HXP.halfWidth * 0.8, 80, "Start");
		_startButton.clicked.onClicked.bindVoid(startGame);
		
		_backButton = new BambooButton(HXP.halfWidth / 2, HXP.height * 0.85, HXP.halfWidth * 0.8, 80, "Main Menu");
		
		_opsBox = new CheckBoxGroup(HXP.halfWidth, HXP.height * 0.6, HXP.width * 0.8, HXP.height * 0.2, Type.getEnumConstructs(ProblemOp));
		_opsBox.clicked.onClicked.bindVoid(onOperatorSelected);
		_opsBox.requireOne = true;
		
		var ops:Array<String> = Type.getEnumConstructs(ProblemOp);
		var op:String;
		for (i in 0...ops.length)
		{
			_opsBox.setSelection(i, G.PROBLEM_DEF.operator.has(Type.createEnumIndex(ProblemOp, i)));
		}
	}
	
	override public function added():Void
	{
		scene.add(_startButton);
		scene.add(_backButton);
		scene.add(_opsBox);
		
		var ops:Array<String> = Type.getEnumConstructs(ProblemOp);
		var op:String;
		for (i in 0...ops.length)
		{
			_opsBox.setSelection(i, G.PROBLEM_DEF.operator.has(Type.createEnumIndex(ProblemOp, i)));
		}
	}
	
	override public function removed():Void
	{
		scene.remove(_startButton);
		scene.remove(_backButton);
		scene.remove(_opsBox);
	}
	
	private function onOperatorSelected():Void
	{
		var op:ProblemOp = Type.createEnum(ProblemOp, _opsBox.options[_opsBox.selected]);
		if (G.PROBLEM_DEF.operator.has(op))
			G.PROBLEM_DEF.operator.unset(op);
		else
			G.PROBLEM_DEF.operator.set(op);
	}
	
	private function startGame():Void
	{
		if (G.PROBLEM_DEF.operator.toInt() == 0) G.PROBLEM_DEF.operator.set(ProblemOp.Addition);
		
		HXP.scene = new RestaurantScene();
	}
	
	private var _opsBox:CheckBoxGroup;
	private var _startButton:BambooButton;
	private var _backButton:BambooButton;
}