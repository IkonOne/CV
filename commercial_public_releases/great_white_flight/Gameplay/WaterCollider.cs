using UnityEngine;
using System.Collections;

public class WaterCollider : MonoBehaviour {
	ScoreManager scoreManager;

	void Awake() {
		scoreManager = GameObject.FindObjectOfType<ScoreManager>();
	}

	void OnTriggerEnter2D(Collider2D other) {
		if(other.gameObject.layer == LayerMask.NameToLayer("Player"))
			scoreManager.ResetMultiplier();
	}
}
