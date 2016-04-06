package com.maskedpixel.mathsushi.entities.quiz;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.GS;
import com.maskedpixel.mathsushi.ProblemDef;
import com.maskedpixel.mathsushi.entities.gui.Score;
import com.maskedpixel.util.BehaviourEntity;
import com.maskedpixel.util.graphics.GrapeSheet;
import com.maskedpixel.util.graphics.IAnimation;
import com.maskedpixel.util.graphics.MCRenderer;
import flash.geom.Rectangle;
import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;
import nme.Assets;
import com.maskedpixel.mathsushi.entities.quiz.MathProblem;
import com.maskedpixel.mathsushi.entities.Server;
import flash.geom.Point;

/**
 * ...
 * @author Erin M Gunn
 */

class MathQuiz extends BehaviourEntity
{
	public var problemDef:ProblemDef;
	
	public var onComplete(default, null):Signaler<MathQuiz>;
	public var satisfaction(default, null):Int;

	public function new(questions:Int = 1)
	{
		super();
		
		layer = G.LAYER_GUI_BACKGROUND;
		problemDef = new ProblemDef();
		
		x = HXP.halfWidth;
		y = HXP.halfHeight;
		
		if(_fadedBackground == null)
		{
			// _fadedBackground = Image.createRect(cast HXP.width, cast HXP.height, 0x000000);
			_fadedBackground = new Image(HXP.createBitmap(cast HXP.width, cast HXP.height, false, 0x000000));
			_fadedBackground.centerOrigin();
			_fadedBackground.alpha = 0.5;
		}
		setHitboxTo(_fadedBackground);
		centerOrigin();
		
		if (_barWall == null)
		{
			_barWall = new Image(G.getSource("gfx/bar/barWall.png"));
			_barWall.scaleX = (width / 3 * 2 * 0.9) / _barWall.width;
			_barWall.x = x - width / 6;
			_barWall.y = HXP.height * 0.75 - _barWall.height / 1.75;
			_barWall.centerOrigin();
			_barWall.relative = false;
		}
		
		if (_barPanel == null)
		{
			var source:Dynamic = G.getSource("gfx/bar/barPanel.png");
			_barPanel = new Image(source, new Rectangle(0, 0, Reflect.field(source, "width") / 2, 0));
			_barPanel.x = _barWall.x;
			_barPanel.y = _barWall.y;
			_barPanel.centerOrigin();
			_barPanel.relative = false;
		}
		
		if (_server == null)
		{
			_serverCelebrations = ["DoublePumpLoop", "SinglePumpLoop", "Wave"];
			
#if flash
			_server = new MCRenderer("Flashets:Sensei");
#else
			_server = new GrapeSheet("sheets/sensei/sheets.xml", "sheets/sensei/animations.xml", G.getAtlas());
#end
			_server.onComplete.bindVoid(onServerAnimComplete);
			_server.originY = 30;
			_server.scale = 0.8;
			_server.getGraphic().relative = false;
		}
		
		addGraphic(_fadedBackground);
		addGraphic(_barWall);
		addGraphic(_barPanel);
		addGraphic(_server.getGraphic());
		
		onComplete = new DirectSignaler(this);
		_quizItems = new Array<QuizItem>();
		
		_numPad = new NumberPad(x + halfWidth / 3 * 2, y, G.GUI_NUMBER_SIZE * 3, G.GUI_NUMBER_SIZE * 4);
		
		for (i in 0...questions)
		{
			_quizItems.push(new QuizItem(x - width / 6, HXP.height * 0.75, width / 3 * 2 * 0.9, height / 4 * 0.9));
			_quizItems[i].numberPad = _numPad;
			_quizItems[i].onAnswered.bind(onItemAnswered);
		}
	}
	
	override public function added():Void
	{
		
		scene.add(_numPad);
		_numPad.focusedItem = _quizItems[0];
		
		for (qi in _quizItems)
		{
			qi.setDefinition(problemDef);
		}
		_currentQuiz = 0;
		scene.add(_quizItems[_currentQuiz]);
		
		_gameServer = cast scene.getInstance(G.NAME_SERVER);
		
		_server.getGraphic().x = _quizItems[0].x;
		_server.getGraphic().y = _quizItems[0].y;
		_server.loop(_gameServer.currentAnim);
	}
	
	override public function removed():Void
	{
		for (qi in _quizItems)
		{
			_numPad.quizItems.remove(qi);
		}
		
		scene.removeList(cast _quizItems);
		scene.remove(_numPad);
	}
	
	private function onItemAnswered(qi:QuizItem):Void
	{
		var score:Score = cast scene.getInstance(G.NAME_SCORE);
		if (score != null) score.problemAnwered(qi);
		
		if (!qi.correctAnswer)
		{
			GS.playSfx(GS.WRONG_ANSWER, 0.8);
			return;
		}
		
		GS.playSfx(GS.RIGHT_ANSWER, 0.5);
		
		scene.remove(qi);
		_currentQuiz++;
		if (_currentQuiz == _quizItems.length)
		{
			onComplete.dispatch(this);
			return;
		}
		serverCelebrate();
		scene.add(_quizItems[_currentQuiz]);
		_numPad.focusedItem = _quizItems[_currentQuiz];
	}
	
	private function selectUnansweredItem():QuizItem
	{
		for (qi in _quizItems)
		{
			if (!qi.correctAnswer) return qi;
		}
		return null;
	}
	
	private function serverCelebrate():Void
	{
		_celebrationAnim = HXP.choose(_serverCelebrations);
		_server.play(_celebrationAnim);
	}
	
	private function onServerAnimComplete() 
	{
		_server.play(_gameServer.currentAnim);
	}
	
	
	private var _quizItems:Array<QuizItem>;
	private var _numPad:NumberPad;
	private var _currentQuiz:Int = 0;
	private var _gameServer:Server;
	private var _score:Score;
	private var _celebrationAnim:String;
	private static var _fadedBackground:Image;
	private static var _barWall:Image;
	private static var _barPanel:Image;
	private static var _server:IAnimation;
	private static var _serverCelebrations:Array<String>;
}