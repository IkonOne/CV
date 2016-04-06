package com.maskedpixel.mathsushi.entities.gui;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
import com.maskedpixel.mathsushi.entities.Customer;
import com.maskedpixel.mathsushi.entities.quiz.MathProblem;
import com.maskedpixel.mathsushi.entities.quiz.QuizItem;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.util.graphics.NineSlice;
import haxe.remoting.FlashJsConnection;
import nme.Assets;
import nme.display.BitmapData;
import nme.geom.Rectangle;

/**
 * ...
 * @author Erin M Gunn
 */

class Score extends Entity
{
	public var scoreString(default, null):String;
	public var customersServed(default, null):Int;
	public var totalProblems(default, null):Int;
	public var problemsRight(default, null):Int;
	public var longestStreak(default, null):Int;
	
	public var showParticles(getShowParticles, setShowParticles):Bool;
	private function getShowParticles():Bool { return _scoreParticles.visible; }
	private function setShowParticles(value:Bool):Bool
	{
		_scoreParticles.visible = _multParticles.visible = value;
		return _scoreParticles.visible;
	}
	
	public var gameTime(getGameTime, null):String;
	private function getGameTime():String
	{
		var seconds:Int = cast DateTools.seconds(_elapsed) / 1000;
		var minutes:Int = cast seconds / 60;
		seconds -= minutes * 60;
		
		return Std.string(minutes) + ":" + (seconds < 10 ? "0" + Std.string(seconds) : Std.string(seconds));
	}
	
	public var score(getScore, setScore):Int;
	private function getScore():Int { return _score; }
	private function setScore(value:Int):Int
	{
		_score = value;
		formatScore();
		_scoreLabel.text = scoreString;
		_scoreLabel.centerOrigin();
		
		_scoreLabel.scale = 1.5;
		_scoreTween.tween(_scoreLabel, "scale", 1, 0.5, Ease.bounceOut);
		
		return _score;
	}
	
	public var multiplier(getMultiplier, setMultiplier):Int;
	private function getMultiplier():Int { return _multiplier; }
	private function setMultiplier(value:Int):Int
	{
		_multiplier = value;
		_multLabel.text = "*" + Std.string(_multiplier);
		_multLabel.centerOrigin();
		
		_multLabel.scale = 1.5;
		_multTween.tween(_multLabel, "scale", 1, 0.5, Ease.bounceOut);
		
		return _multiplier;
	}

	public function new(?X:Float = 0, ?Y:Float = 0, ?Width:Int = 1, ?Height:Int = 1) 
	{
		super(X, Y);
		
		name = G.NAME_SCORE;
		layer = G.LAYER_GUI_PARTICLES;
		type = G.TYPE_HUD;
		
		_elapsed = 0;
		_score = 0;
		_multiplier = 1;
		customersServed = 0;
		scoreString = "$0.00";
		
		//_background = Image.createRect(Width, Height);
		var source:Dynamic = G.getSource("gfx/gui/ScoreBackground.png");
		_background = new NineSlice(source, new Rectangle(1, 1, 60, Reflect.field(source, "height") - 1));
		_background.width = Width;
		_background.height = Height;
		addGraphic(_background);
		setHitboxTo(_background);
		
		_scoreLabel = new Text("$0.00", Width / 3, halfHeight);
		_scoreLabel.resizable = true;
		_scoreLabel.size = 32;
		//_scoreLabel.centerOrigin();
		_scoreLabel.relative = false;
		addGraphic(_scoreLabel);
		_scoreTween = new VarTween(null, TweenType.Persist);
		addTween(_scoreTween);
		
		_scoreParticles = new Emitter(G.getSource("gfx/gui/StarParticle.png"));
		_scoreParticles.newType("normal");
		_scoreParticles.setAlpha("normal", 1, 0.1);
		_scoreParticles.setColor("normal", 0x0B486B, 0xCFF09E);
		_scoreParticles.relative = false;
		addGraphic(_scoreParticles);
		
		_multLabel = new Text("*1", Width / 3 * 2, halfHeight);
		_multLabel.resizable = true;
		_multLabel.size = 32;
		_multLabel.centerOrigin();
		_multLabel.relative = false;
		addGraphic(_multLabel);
		_multTween = new VarTween(null, TweenType.Persist);
		addTween(_multTween);
		
		_multParticles = new Emitter(G.getSource("gfx/gui/StarParticle.png"));
		_multParticles.newType("normal");
		_multParticles.setAlpha("normal", 1, 0.1);
		_multParticles.setColor("normal", 0x0B486B, 0xCFF09E);
		_multParticles.relative = false;
		addGraphic(_multParticles);
	}
	
	override public function update():Void 
	{
		_elapsed += HXP.elapsed;
	}
	
	public function problemAnwered(quizItem:QuizItem):Void
	{
		totalProblems++;
		if (quizItem.correctAnswer)
		{
			problemsRight++;
			multiplier++;
			longestStreak = _multiplier > longestStreak ? _multiplier : longestStreak;
			score += (Type.enumIndex(quizItem.problem.operator) + 1) * (Type.enumIndex(quizItem.problem.definition.difficulty) + 1) * multiplier;
			
			emitParticles(quizItem.answer.x, quizItem.answer.y, _scoreLabel.x, _scoreLabel.y, _scoreParticles);
			emitParticles(quizItem.answer.x, quizItem.answer.y, _multLabel.x, _multLabel.y, _multParticles);
		}
		else
		{
			_multiplier = 1;
		}
	}
	
	public function customerBilled(customer:Customer):Void
	{
		customersServed++;
		score += cast customer.satisfaction * _multiplier;
		
		emitParticles(customer.x, customer.y, _scoreLabel.x, _scoreLabel.y, _scoreParticles);
	}
	
	public function emitParticles(x1:Float, y1:Float, x2:Float, y2:Float, emitter:Emitter):Void
	{
		emitter.setMotion("normal", HXP.angle(x1, y1, x2, y2), HXP.distance(x1, y1, x2, y2), 0.5, 0, 0, 0.2, Ease.quadOut);
		for (i in 0...10)
		{
			emitter.emitInCircle("normal", x1, y1, 20);
		}
	}
	
	private function formatScore()
	{
		var dollars:Int = cast _score / 100;
		var cents:Int = _score - (dollars * 100);
		scoreString = "$" + Std.string(dollars) + "." + (cents < 10 ? "0" + Std.string(cents) : Std.string(cents));
	}
	
	//private var _background:Image;
	private var _background:NineSlice;
	private var _scoreLabel:Text;
	private var _multLabel:Text;
	
	private var _scoreTween:VarTween;
	private var _multTween:VarTween;
	
	private var _scoreParticles:Emitter;
	private var _multParticles:Emitter;
	
	private var _score:Int;
	private var _multiplier:Int;
	private var _elapsed:Float;
}