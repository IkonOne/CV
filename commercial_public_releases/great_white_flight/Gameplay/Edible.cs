using UnityEngine;
using System.Collections;

public class Edible : MonoBehaviour {
	public enum EdibleType {
		Plane,
		Fish,
		Bird
	}

	public EdibleType edibleType;
	public float healthValue = 10;
	public float pointValue;
	public int multiplierValue;

	public HitGraphics.Graphic hitType;

	HitGraphics hitGraphics;

	void Awake() {
		hitGraphics = GameObject.FindObjectOfType<HitGraphics>();
	}

	void OnTriggerEnter2D(Collider2D other) {
		CheckIfEaten(other.gameObject);
	}

	void OnCollisionEnter2D(Collision2D other) {
		CheckIfEaten(other.gameObject);
	}

	void CheckIfEaten(GameObject other) {
		if(other.layer == LayerMask.NameToLayer("Player")) {
			gameObject.BroadcastMessage("OnHitPlayer", SendMessageOptions.DontRequireReceiver);
			gameObject.Recycle();
			hitGraphics.SpawnGraphic(hitType, other.transform.position);
		}
	}
}
