using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Rigidbody2D))]
public class MovingObject : MonoBehaviour {
	public float minWakeDelay;
	public float maxWakeDelay;
	public float minSpeed;
	public float maxSpeed;

	Rigidbody2D rb2D;

	void OnSpawned() {
		Invoke ("StartMoving", Random.Range(minWakeDelay, maxWakeDelay));
	}

	void StartMoving() {
		float moveDir = 0;
		moveDir = (transform.position.x < ScreenBounds.instance.left) ? 1 : -1;

		Vector3 scale = transform.localScale;
		scale.x = moveDir * Mathf.Abs(scale.x);
		transform.localScale = scale;

		Vector2 vel = Vector2.zero;
		vel.x = Random.Range(minSpeed, maxSpeed) * moveDir;
		GetComponent<Rigidbody2D>().velocity = vel;
	}

	void OnTriggerExit2D(Collider2D other) {
		if(other.gameObject.tag == "ExitTriggers") {
			gameObject.Recycle();
		}
	}
}
