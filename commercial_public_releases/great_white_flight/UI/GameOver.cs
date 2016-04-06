using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class GameOver : MonoBehaviour {
	public Text lblScore;

	void Start () {
		ScoreManager score = GameObject.FindObjectOfType<ScoreManager>();
		if(score)
			lblScore.text = Mathf.FloorToInt(score.score).ToString();
	}
}
