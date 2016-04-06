using UnityEngine;
using System.Collections;

public class PlayerEat : MonoBehaviour {
	PlayerHealth health;
	ScoreManager scoreManager;
	GameObject managers;

	void Awake() {
		health = GetComponent<PlayerHealth>();
		scoreManager = GameObject.FindObjectOfType<ScoreManager>();
		managers = GameObject.Find("Managers");
	}

	void OnCollisionEnter2D(Collision2D collision) {
		CheckEaten(collision.gameObject);
	}

	void OnTriggerEnter2D(Collider2D other) {
		CheckEaten(other.gameObject);
	}

	void CheckEaten(GameObject other) {
		var edible = other.GetComponent<Edible>();
		if(edible != null) {
			health.AddHealth(edible.healthValue);
			scoreManager.AddScore(edible.pointValue);
			scoreManager.AddMultiplier(edible.multiplierValue);

			if(managers != null)
				managers.BroadcastMessage("OnEdibleEaten", edible.edibleType, SendMessageOptions.DontRequireReceiver);
		}
	}
}
