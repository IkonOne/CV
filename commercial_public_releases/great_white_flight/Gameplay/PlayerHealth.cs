using UnityEngine;
using System.Collections;

public class PlayerHealth : MonoBehaviour {
	public float startHealth = 1000;
	public float decayTime = 60;

	ScoreManager scoreManager;
	HUDManager hudManager;

	float _health;

	public float health {
		get { return _health; }
		internal set {
			_health = Mathf.Clamp(value, -1, startHealth);
			if(hudManager)
				hudManager.BroadcastMessage("OnHealthChanged", _health / startHealth);

			if(_health <= 0)
			{
				GameObject go = GameObject.Find("Managers");
				if(go)
					go.BroadcastMessage("OnGameOver");

				enabled = false;
			}
		}
	}

	// Use this for initialization
	void Start () {
		scoreManager = GameObject.FindObjectOfType<ScoreManager>();
		hudManager = GameObject.FindObjectOfType<HUDManager>();

		health = startHealth;
	}

	// Update is called once per frame
	void Update () {
		health -= Time.deltaTime * (startHealth / decayTime);
	}

	void Reset() {
		_health = startHealth;
	}

	public void AddHealth(float amount) {
		health += amount * scoreManager.multiplier;
	}

	public void RemoveHealth(float amount) {
		health -= amount;
	}

	void OnTriggerEnter2D(Collider2D other) {
		Edible edible = other.GetComponent<Edible>();
		if(edible != null)
			health += edible.healthValue * scoreManager.multiplier;
	}
}
