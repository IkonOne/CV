using UnityEngine;
using System.Collections;

public class GameManager : MonoBehaviour {
	public GameObject PauseMenu;

	private bool _gameOver;
	public bool gameOver {
		get { return _gameOver; }
		internal set { _gameOver = value; }
	}

	void OnDestroy() {
		Time.timeScale = 1;
	}

	void OnGameOver() {
		if(_gameOver)
			return;

		Application.LoadLevelAdditive("GameOverScene");
		Time.timeScale = 0;
		_gameOver = true;
	}

	void OnGamePaused() {
		PauseMenu.SetActive(true);
		Time.timeScale = 0;
	}

	void OnGameResumed() {
		PauseMenu.SetActive(false);
		Time.timeScale = 1;
	}
}
