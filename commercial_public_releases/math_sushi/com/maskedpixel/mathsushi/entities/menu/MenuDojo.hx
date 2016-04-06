package com.maskedpixel.mathsushi.entities.menu;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.maskedpixel.mathsushi.behaviours.Clicked;
import com.maskedpixel.mathsushi.entities.gui.Button;
import com.maskedpixel.mathsushi.entities.gui.RadioGroup;
import com.maskedpixel.mathsushi.entities.gui.SushiRating;
import com.maskedpixel.mathsushi.entities.quiz.MathProblem;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.LevelParser;
import com.maskedpixel.mathsushi.LVL;
import com.maskedpixel.mathsushi.scenes.LevelScene;
import com.maskedpixel.mathsushi.entities.gui.BambooButton;
import com.maskedpixel.util.graphics.NineSlice;
import nme.geom.Rectangle;

/**
 * ...
 * @author Erin M Gunn
 */

class MenuDojo extends Entity
{
	public var buttonsWide:Int = 5;
	public var buttonsTall:Int = 3;
	public var totalButtons(default, null):Int;
	
	public var backClicked(getBackClicked, null):Clicked;
	private function getBackClicked():Clicked
	{
		return _backButton.clicked;
	}

	public function new()
	{
		super();
		
		x = HXP.width / 8;
		y = HXP.height / 10;
		width = cast HXP.width / 8 * 6;
		height = cast HXP.height / 10 * 6;
		
		var ns:NineSlice = new NineSlice(G.getSource("gfx/gui/Panel.png"), new Rectangle(10, 10, 80, 30));
		ns.alpha = 0.8;
		ns.x = HXP.halfWidth;
		ns.y = HXP.halfHeight + HXP.halfHeight * 0.1;
		ns.width = HXP.width * 0.98;
		ns.height = HXP.height * 0.85;
		ns.centerOrigin();
		ns.relative = false;
		addGraphic(ns);
		
		totalButtons = buttonsWide * buttonsTall;
		
		_backButton = new BambooButton(HXP.width * 0.15, HXP.height * 0.85, HXP.width * 0.25, y * 2, "Main Menu");
		
		_diffRadio = new RadioGroup(HXP.width * 0.65, HXP.height * 0.85, HXP.width * 0.6, y * 2, ["Easy", "Medium", "Hard"]);
		_diffRadio.clicked.onClicked.bindVoid(onDifficultyClicked);
		
		_prevButton = new BambooButton(x / 1.75, y + halfHeight, x * 0.7, height * 0.8, "<");
		_prevButton.clicked.onClicked.bind(onChangeLevelSet);
		_nextButton = new BambooButton(x + width + x / 2.5, y + halfHeight, x * 0.7, height * 0.8, ">");
		_nextButton.clicked.onClicked.bind(onChangeLevelSet);
		
		_focusSet = new Array<BambooButton>();
		_ratingSet = new Array<SushiRating>();
		var tx:Float, ty:Float;
		var b:BambooButton;
		var r:SushiRating;
		for (i in 0...totalButtons)
		{
			tx = x + (i - Math.floor(i / buttonsWide) * buttonsWide) * width / buttonsWide + halfWidth / buttonsWide;
			ty = y + Math.floor(i / buttonsWide) * (height / buttonsTall) + halfHeight / buttonsTall;
			b = new BambooButton(tx, ty, width / 6, height / 5, Std.string(i + 1));
			b.clicked.onClicked.bind(levelButtonClicked);
			_focusSet.push(b);
			
			r = new SushiRating(tx, ty + b.halfHeight * 1.3, b.width, cast b.halfHeight, 0);
			r.layer = G.LAYER_GUI_TOP;
			_ratingSet.push(r);
		}
		
		_levelSet = 0;
		_setName = new Text(LVL.SETS[_levelSet], HXP.halfWidth, HXP.halfHeight * 0.125);
		_setName.relative = false;
		_setName.resizable = true;
		_setName.size = G.getTextScale(32);
		_setName.centerOrigin();
		
		_setPanel = new NineSlice(G.getSource("gfx/gui/Panel.png"), new Rectangle(10, 10, 80, 30));
		_setPanel.alpha = 0.8;
		_setPanel.width = HXP.halfWidth * 0.7;
		_setPanel.height = y * 0.9;
		_setPanel.x = HXP.halfWidth;
		_setPanel.y = Math.floor(HXP.halfHeight * 0.125);
		_setPanel.relative = false;
		_setPanel.centerOrigin();
		
		addGraphic(_setPanel);
		addGraphic(_setName);
	}
	
	override public function added():Void
	{
		scene.add(_backButton);
		scene.add(_nextButton);
		scene.add(_prevButton);
		scene.addList(_focusSet);
		scene.addList(_ratingSet);
		scene.add(_diffRadio);
		updateRatings();
	}
	
	override public function removed():Void
	{
		scene.remove(_backButton);
		scene.remove(_nextButton);
		scene.remove(_prevButton);
		scene.remove(_diffRadio);
		scene.removeList(_focusSet);
		scene.removeList(_ratingSet);
	}
	
	private function onDifficultyClicked():Void
	{
		G.PROBLEM_DEF.difficulty = Type.createEnum(ProblemDifficulty, _diffRadio.selectedString);
	}
	
	private function levelButtonClicked(c:Clicked):Void
	{
		var idx:Int = Lambda.indexOf(_focusSet, cast c.parent);
		
		if (LVL.SetCurrentLevel(_levelSet, idx))
		{
			HXP.scene = new LevelScene();
		}
	}
	
	private function onChangeLevelSet(c:Clicked):Void
	{
		if (c.parent == _prevButton) _levelSet--;
		if (c.parent == _nextButton) _levelSet++;
		_levelSet = cast HXP.clamp(_levelSet, 0, LVL.SETS.length - 1);
		
		_setName.text = LVL.SETS[_levelSet];
		_setName.centerOrigin();
		_setName.updateBuffer();
		updateRatings();
	}
	
	private function updateRatings():Void
	{
		for (i in 0..._ratingSet.length) 
		{
			LVL.SetCurrentLevel(_levelSet, i);
			_ratingSet[i].rating = LVL.CURRENT_RATING;
		}
	}
	
	private var _backButton:BambooButton;
	private var _nextButton:BambooButton;
	private var _prevButton:BambooButton;
	private var _focusSet:Array<BambooButton>;
	private var _setName:Text;
	private var _setPanel:NineSlice;
	private var _ratingSet:Array<SushiRating>;
	private var _diffRadio:RadioGroup;
	
	private var _levelSet:Int;
}