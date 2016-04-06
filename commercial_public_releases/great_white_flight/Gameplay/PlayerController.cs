using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Rigidbody2D))]
public class PlayerController : MonoBehaviour {
	public LayerMask waterLayer;
	public float rotSpeed = 360;
	public float groundSpeed = 100;

	float moveAngle;
	bool left = false;
	bool right = false;
	bool inGround = false;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		PollInput();
	}

	void FixedUpdate() {
		HandleInput();
	}

	void PollInput() {
		left = Input.GetKey(KeyCode.LeftArrow) || Input.GetKey(KeyCode.A);
		right = Input.GetKey(KeyCode.RightArrow) || Input.GetKey(KeyCode.D);

#if UNITY_ANDROID
		if(Input.touchCount > 0)
		{
			left = Input.GetTouch(0).position.x < Screen.width / 2;
			right = Input.GetTouch(0).position.x > Screen.width / 2;
		}
#endif
	}

	void HandleInput() {
		if(inGround)
		{
			Vector2 vel = GetComponent<Rigidbody2D>().velocity;

			if(left)
				moveAngle += rotSpeed * Time.fixedDeltaTime;
			if(right)
				moveAngle -= rotSpeed * Time.fixedDeltaTime;

			if(left || right)
			{
				vel.Set(Mathf.Cos(moveAngle * Mathf.Deg2Rad), Mathf.Sin(moveAngle * Mathf.Deg2Rad));
				GetComponent<Rigidbody2D>().velocity = vel;
			}
			vel.Normalize();
			vel.x *= groundSpeed;
			vel.y *= groundSpeed;
			GetComponent<Rigidbody2D>().velocity = vel;
		}
	}

	void OnCollisionEnter2D(Collision2D collision) {
		if(collision.gameObject.tag == "ScreenBounds")
			moveAngle = Mathf.Atan2(GetComponent<Rigidbody2D>().velocity.y, GetComponent<Rigidbody2D>().velocity.x) * Mathf.Rad2Deg;
	}

	void OnTriggerEnter2D(Collider2D other) {
		if(1 << other.gameObject.layer == waterLayer.value)
		{
			inGround = true;

			GetComponent<Rigidbody2D>().gravityScale = 0;
			moveAngle = Mathf.Atan2(GetComponent<Rigidbody2D>().velocity.y, GetComponent<Rigidbody2D>().velocity.x) * Mathf.Rad2Deg;
		}
	}

	void OnTriggerExit2D(Collider2D other) {
		if(1 << other.gameObject.layer == waterLayer.value)
		{
			inGround = false;
			GetComponent<Rigidbody2D>().gravityScale = 1;
		}
	}
}
