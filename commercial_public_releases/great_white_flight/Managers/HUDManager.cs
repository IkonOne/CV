using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class HUDManager : MonoBehaviour {
	public Text lblMult;
	public Text lblScore;
	public Slider sldrHealth;

	float health;

	void Awake() {
		ScoreManager scoreManager = GameOver.FindObjectOfType<ScoreManager>();
		if(scoreManager != null) {
			scoreManager.scoreChangedEvent.AddListener(OnScoreChanged);
			scoreManager.multiplierChangedEvent.AddListener(OnMultChanged);
		}
	}

	void LateUpdate() {
		sldrHealth.value = health;
	}

	public void OnMultChanged(int mult) {
		lblMult.text = "x" + mult.ToString();
	}

	public void OnScoreChanged(int score) {
		lblScore.text = score.ToString();
	}

	public void OnHealthChanged(float amount) {
		health = amount;
	}
}
