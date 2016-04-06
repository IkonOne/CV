using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Sprite))]
public class Bomb : MonoBehaviour {
	public LayerMask waterLayer;
	public GameObject explosionPrefab;

	GameObject managers;

	void Awake() {
		managers = GameObject.Find("Managers");
	}

	void Explode() {
		GameObject go = (GameObject)Instantiate(explosionPrefab);
		go.transform.position = transform.position;

		Destroy(gameObject);
	}

	void OnCollisionEnter2D(Collision2D col) {
		if(col.gameObject.name == "Player") {
			Explode();

			if(managers != null)
				managers.BroadcastMessage("OnBombHit", SendMessageOptions.DontRequireReceiver);
		}
	}

	void OnTriggerEnter2D(Collider2D other) {
		if(1 << other.gameObject.layer == waterLayer.value)
			Explode();

		if(other.gameObject.name == "ExitTrigger")
			Destroy(gameObject);
	}
}
