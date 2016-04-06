package com.maskedpixel.mathsushi.entities.menu;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Stamp;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.maskedpixel.mathsushi.entities.gui.BambooButton;
import com.maskedpixel.mathsushi.entities.gui.Score;
import com.maskedpixel.mathsushi.entities.gui.SushiRating;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.LVL;
import com.maskedpixel.mathsushi.scenes.LevelScene;
import com.maskedpixel.mathsushi.scenes.MainMenuScene;
import com.maskedpixel.mathsushi.scenes.RestaurantScene;
import com.maskedpixel.mathsushi.entities.gui.Button;
import com.maskedpixel.util.graphics.MCRenderer;
import nme.Lib;
import nme.net.URLRequest;

/**
 * ...
 * @author Erin M Gunn
 */

class GameOverMenu extends InGameMenu
{
	public function new()
	{
		super();
		
		_nextButton = new BambooButton(HXP.width / 6 * 5, HXP.height / 8 * 7, HXP.width / 3 * 0.8, HXP.height / 5 * 0.8, "Next");
		_nextButton.clicked.onClicked.bindVoid(onNext);
		
		_retryButton = new BambooButton(HXP.halfWidth, HXP.height / 8 * 7, HXP.width / 3 * 0.8, HXP.height / 5 * 0.8, "Retry");
		_retryButton.clicked.onClicked.bindVoid(onRetry);
		
		_menuButton = new BambooButton(HXP.width / 6, HXP.height / 8 * 7, HXP.width / 3 * 0.8, HXP.height / 5 * 0.8, "Menu");
		_menuButton.clicked.onClicked.bindVoid(onMenu);
		
		_tipsLabel = new Text("Tips Earned: ", HXP.width / 4, HXP.height / 3);
		_tipsLabel.color = 0xFFFFFF;
		_tipsLabel.size = 32;
		_tipsLabel.resizable = true;
		_tipsLabel.centerOrigin();
		_tipsLabel.originX = 0;
		_tipsLabel.updateBuffer();
		addGraphic(_tipsLabel);
		_tipsScoreLabel = new Text("$0.00", HXP.width / 4 * 3, _tipsLabel.y);
		_tipsScoreLabel.color = _tipsLabel.color;
		_tipsScoreLabel.size = 32;
		_tipsScoreLabel.resizable = true;
		_tipsScoreLabel.updateBuffer();
		_tipsScoreLabel.centerOrigin();
		_tipsScoreLabel.originX = _tipsScoreLabel.width;
		addGraphic(_tipsScoreLabel);
		
		_percentageLabel = new Text("Percentage Right: ", HXP.width / 4, HXP.height / 3 + _tipsLabel.height);
		_percentageLabel.color = 0xFFFFFF;
		_percentageLabel.size = 32;
		_percentageLabel.resizable = true;
		_percentageLabel.centerOrigin();
		_percentageLabel.originX = 0;
		_percentageLabel.updateBuffer();
		addGraphic(_percentageLabel);
		_percentageScoreLabel = new Text("00%", HXP.width / 4 * 3, _percentageLabel.y);
		_percentageScoreLabel.color = _percentageLabel.color;
		_percentageScoreLabel.size = _percentageLabel.size;
		_percentageScoreLabel.resizable = true;
		_percentageScoreLabel.centerOrigin();
		addGraphic(_percentageScoreLabel);
		
		_streakLabel = new Text("Longest Streak: ", HXP.width / 4, HXP.height / 3 + _tipsLabel.height * 2);
		_streakLabel.color = 0xFFFFFF;
		_streakLabel.size = 32;
		_streakLabel.resizable = true;
		_streakLabel.centerOrigin();
		_streakLabel.originX = 0;
		_streakLabel.updateBuffer();
		addGraphic(_streakLabel);
		_streakScoreLabel = new Text("100", HXP.width / 4 * 3, _streakLabel.y);
		_streakScoreLabel.color = _streakLabel.color;
		_streakScoreLabel.size = _streakLabel.size;
		_streakScoreLabel.resizable = true;
		_streakScoreLabel.centerOrigin();
		addGraphic(_streakScoreLabel);
		
		_sushiRating = new SushiRating(HXP.halfWidth, ((_streakLabel.y + _streakLabel.height / 2) + _menuButton.top) / 2, cast HXP.width / 3, cast HXP.height / 8, 0);
		
#if mathNook
		_sponsorLogo = new Stamp("logo.png");
		_sponsorLogoEntity = new Entity(5, HXP.halfHeight * 0.5, _sponsorLogo);
		
		_moreGamesButton = new BambooButton(HXP.width / 6 * 5, HXP.height / 8 * 5.5, HXP.width / 3 * 0.8, HXP.height / 4 * 0.8, "More Games");
		_moreGamesButton.clicked.onClicked.bindVoid(function() {
			Lib.getURL(new URLRequest("http://www.mathnook.com"));
		});
#end
	}
	
	override public function added():Void
	{
		super.added();
		
		if (LVL.GetLevelExists(LVL.CURRENT_SET, LVL.CURRENT_LEVEL + 1)) scene.add(_nextButton);
		scene.add(_retryButton);
		scene.add(_menuButton);
		scene.add(_sushiRating);
		if (_moreGamesButton != null) scene.add(_moreGamesButton);
		if (_sponsorLogoEntity != null) scene.add(_sponsorLogoEntity);
		
		_tipsScoreLabel.text = _score.scoreString;
		_tipsScoreLabel.originX = _tipsScoreLabel.width;
		
		var percentage:Float = _score.problemsRight / _score.totalProblems;
		_percentageScoreLabel.text = Std.string(Math.round(percentage * 100)) + "%";
		_percentageScoreLabel.originX = _percentageScoreLabel.width;
		
		_streakScoreLabel.text = Std.string(_score.longestStreak);
		_streakScoreLabel.originX = _streakScoreLabel.width;
		
		var rating:Int = 0;
		if (percentage > 0.7) rating++;
		if (percentage > 0.85) rating++;
		if (percentage >= 1) rating++;
		LVL.CURRENT_RATING = rating;
		_sushiRating.rating = rating;
		_sushiRating.emitParticles();
		
		_score.showParticles = false;
		
		GS.playSfx(GS.YOU_KNOW_MATH_SUSHI);
		
		#if flash
		MCRenderer.pause();
		#end
	}
	
	override public function removed():Void
	{
		super.removed();
		
		scene.remove(_nextButton);
		scene.remove(_retryButton);
		scene.remove(_menuButton);
		if (_moreGamesButton != null) scene.remove(_moreGamesButton);
		if (_sponsorLogoEntity != null) scene.remove(_sponsorLogoEntity);
	}
	
	public function setScore(score:Score):Void
	{
		_score = score;
	}
	
	private function onNext():Void
	{
		if (!LVL.SetCurrentLevel(LVL.CURRENT_SET, LVL.CURRENT_LEVEL + 1)) return;
		HXP.scene = new LevelScene();
	}
	
	private function onRetry():Void
	{
		HXP.scene = new LevelScene();
	}
	
	private function onMenu():Void
	{
		HXP.scene = new MainMenuScene();
	}
	
	private var _nextButton:Button;
	private var _menuButton:Button;
	private var _retryButton:Button;
	
	private var _sponsorLogo:Stamp;
	private var _sponsorLogoEntity:Entity;
	private var _moreGamesButton:BambooButton;
	
	private var _sushiRating:SushiRating;
	private var _score:Score;
	
	private var _tipsLabel:Text;
	private var _tipsScoreLabel:Text;
	private var _percentageLabel:Text;
	private var _percentageScoreLabel:Text;
	private var _streakLabel:Text;
	private var _streakScoreLabel:Text;
	
}