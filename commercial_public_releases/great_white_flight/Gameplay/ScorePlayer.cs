using UnityEngine;
using System.Collections;

public class ScorePlayer : MonoBehaviour {
	public LayerMask waterLayer;
	public float pointsPerSecond = 10f;

	ScoreManager scoreManager;
	bool inWater;
	float scoreTicker;

	void Awake() {
		scoreManager = GameObject.FindObjectOfType<ScoreManager>();
	}

	void Update () {
		if(!inWater)
			scoreTicker += Time.deltaTime * pointsPerSecond;

		while(scoreTicker > 1) {
			scoreManager.AddScore(1);
			scoreTicker -= 1;
		}
	}

	void OnTriggerEnter2D(Collider2D other) {
		if(1 << other.gameObject.layer == waterLayer)
			inWater = true;
	}

	void OnTriggerExit2D(Collider2D other) {
		if(1 << other.gameObject.layer == waterLayer.value)
			inWater = false;
	}
}
