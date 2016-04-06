using UnityEngine;
using System.Collections;

[RequireComponent(typeof(CircleCollider2D))]
public class Explosion : MonoBehaviour {
	public float force = 10;
	public float damage = 100;
	public float decayTime = 0.25f;

	CircleCollider2D circle;
	SpriteRenderer sprite;
	float originalAlpha;

	// Use this for initialization
	void Awake () {
		Invoke("OnRemove", 2f);

		circle = GetComponent<CircleCollider2D>();
		sprite = GetComponent<SpriteRenderer>();
		originalAlpha = sprite.color.a;
	}

	void OnEnable() {
		circle.enabled = true;
		sprite.enabled = true;
		StartCoroutine(FadeOut(decayTime, originalAlpha));
	}

	IEnumerator FadeOut(float duration, float initialAlpha) {
		for (float timer = 0; timer < duration; timer += Time.deltaTime) {
			Color color = sprite.color;
			color.a = initialAlpha * (duration / timer);
			sprite.color = color;
			yield return 0;
		}

		circle.enabled = false;
		sprite.enabled = false;
	}

	void OnTriggerEnter2D(Collider2D other) {
		if(other.gameObject.name == "Player")
		{
			float dist = Vector2.Distance(other.transform.position, transform.position);
			float pct = 1 - Mathf.Clamp01(dist / (circle.radius * transform.localScale.x));
			Vector2 force = (transform.position - other.transform.position).normalized * pct;
			other.GetComponent<Rigidbody2D>().AddForce(force, ForceMode2D.Impulse);

			other.GetComponent<PlayerHealth>().RemoveHealth(damage * pct);
		}
	}

	void OnRemove() {
		gameObject.Recycle();
	}
}
