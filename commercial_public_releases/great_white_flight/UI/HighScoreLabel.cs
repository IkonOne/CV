using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class HighScoreLabel : MonoBehaviour {
	void OnEnable() {
		var txt = GetComponent<Text>();
		ScoreManager sm = GameObject.FindObjectOfType<ScoreManager>();
		if(sm == null)
			txt.enabled = false;
		else if(!sm.newHighScore)
			txt.enabled = false;
	}
}
