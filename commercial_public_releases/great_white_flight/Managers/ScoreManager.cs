using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SocialPlatforms;
using System;
using System.Collections;

[Serializable]
public class ScoreEvent : UnityEvent<int> {}

public class ScoreManager : MonoBehaviour {
#if UNITY_ANDROID
	public const string leaderboardID = "CgkI-fbMrYEUEAIQAQ";
#elif UNITY_IOS
	public const string leaderboardID = "";
#endif

	public ScoreEvent scoreChangedEvent;
	public ScoreEvent multiplierChangedEvent;
	public ScoreEvent highScoreChangedEvent;

	private float _score;
	private int _multiplier = 1;
	private int _highScore;
	private bool _newHighScore;

	public float score {
		get { return _score; }
		private set {
			if(_score == value)
				return;

			_score = value;
			scoreChangedEvent.Invoke(Mathf.FloorToInt(_score));
		}
	}

	public int multiplier {
		get { return _multiplier; }
		private set {
			if(_multiplier == value)
				return;

			_multiplier = value;
			multiplierChangedEvent.Invoke(_multiplier);
		}
	}

	public bool newHighScore {
		get { return _newHighScore; }
	}

	public void AddScore(float value) {
		score += value;
	}

	public void AddMultiplier(int value) {
		multiplier += value;
	}

	public void ResetMultiplier() {
		multiplier = 1;
	}

	void OnGameOver() {
#if UNITY_ANDROID
		if(Social.localUser.authenticated)
			Social.ReportScore((long)score, leaderboardID, null);
#endif
	}
}
