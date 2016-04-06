using UnityEngine;
using System.Collections;

public class Plane : MonoBehaviour {
	public GameObject bombPrefab;
	public GameObject explosionPrefab;

	public float minWait;
	public float maxWait;

	Rigidbody2D rb2D;

	void Awake() {
		rb2D = GetComponent<Rigidbody2D>();
	}
	void OnEnable() {
		float waitTime = Random.Range(minWait, maxWait);
		Invoke("OnDropBomb", waitTime);
		rb2D.gravityScale = 0;
		rb2D.angularVelocity = 0;
	}

	void OnDisable() {
		CancelInvoke();
	}

	void OnDropBomb() {
		GameObject bomb = (GameObject)Instantiate(bombPrefab);
		bomb.transform.position = transform.position;
		bomb.GetComponent<Rigidbody2D>().velocity = GetComponent<Rigidbody2D>().velocity;

		float waitTime = Random.Range(minWait, maxWait);
		Invoke("OnDropBomb", waitTime);
	}

	void OnCollisionEnter2D(Collision2D col) {
		if(col.gameObject.name == "Player")
			GetComponent<Rigidbody2D>().gravityScale = 1;
	}

	void OnTriggerEnter2D(Collider2D other) {
		switch(other.gameObject.name)
		{
			case "Ground":
				GameObject go = (GameObject)Instantiate(explosionPrefab);
				go.transform.position = transform.position;
				gameObject.Recycle();
				break;

			case "Player":
				rb2D.gravityScale = 1;
				break;
		}
	}
}
