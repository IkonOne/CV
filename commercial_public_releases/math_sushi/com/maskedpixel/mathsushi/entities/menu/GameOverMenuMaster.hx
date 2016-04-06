package com.maskedpixel.mathsushi.entities.menu;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
import com.maskedpixel.mathsushi.entities.gui.Score;
import com.maskedpixel.mathsushi.G;
import com.maskedpixel.mathsushi.GS;
import com.maskedpixel.mathsushi.HighScoresManager;
import com.maskedpixel.mathsushi.scenes.RestaurantScene;
import com.maskedpixel.mathsushi.entities.gui.Button;
import nme.events.Event;

#if mathNook
import com.mathnook.as3.MNServices;
import com.mathnook.as3.MNConstants;
#end

/**
 * ...
 * @author Erin M Gunn
 */

class GameOverMenuMaster extends GameOverMenu
{

	public function new()
	{
		super();
		
		_highScoreAlert = new Text("New Personal High Score!", HXP.halfWidth, HXP.height * 0.68);
		_highScoreAlert.color = 0xFFCC00;
		_highScoreAlert.size = 48;
		_highScoreAlert.resizable = true;
		_highScoreAlert.relative = false;
		_highScoreAlert.updateBuffer();
		_highScoreAlert.centerOrigin();
		
		_highScoreTween = new VarTween(onHighScoreTween, TweenType.Persist);
		_highScoreTween.tween(_highScoreAlert, "scale", 1.1, 0.5, Ease.sineInOut);
		addTween(_highScoreTween);
	}
	
	override public function added():Void 
	{
		super.added();
		
		scene.updateLists();
		_levelInfo.resizable = true;
		_levelInfo.text = "Master Mode";
		_levelInfo.updateBuffer();
		scene.remove(_sushiRating);
		if (HighScoresManager.checkHighScore(_levelInfo.text, _score.score))
		{
			addGraphic(_highScoreAlert);
			_highScoreTween.start;
			HighScoresManager.setHighScore(_levelInfo.text, _score.score);
		}
		
		_nextButton.text.text = "Submit Score";
		_nextButton.text.centerOrigin();
	}
	

#if mathNook
	override private function onNext():Void 
	{
		if (MNServices.isConnected())
		{
			MNServices.showSubmitScore(_score.score, onScoreSubmitted);
		}
	}
	
	function onScoreSubmitted() 
	{
		switch (MNServices.getLastErrorNumber()) 
		{
			case MNConstants.ERRORNO_NOPLAYER:
				MNServices.showSubmitScore(_score.score, onScoreSubmitted);
				trace("Please enter your name");
				
			case MNConstants.ERRORNO_NONE:
				_nextButton.active = false; // Submit score button.
				MNServices.showEmailChallenge(onEmailChallenge);
				
			default:
				trace(MNServices.getLastError());
		}
	}
	
	function onEmailChallenge()
	{
		MNServices.showTopScores();
	}
#end
	
	override private function onRetry():Void 
	{
		HXP.scene = new RestaurantScene();
	}
	
	private function onHighScoreTween(e:Event):Void
	{
		var t:Float = _highScoreAlert.scale == 1 ? 1.1 : 1;
		_highScoreTween.tween(_highScoreAlert, "scale", t, 0.5, Ease.sineInOut);
		_highScoreTween.start();
	}
	
	private var _highScoreAlert:Text;
	private var _highScoreTween:VarTween;
}