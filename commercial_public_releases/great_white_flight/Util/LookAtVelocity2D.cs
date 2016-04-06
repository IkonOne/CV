using UnityEngine;
using System.Collections;

public class LookAtVelocity2D : MonoBehaviour {
	public Rigidbody2D lookBody;
	public float angleOffset = -90;

	void FixedUpdate() {
		Vector2 vel = lookBody.velocity;
		float angle = Mathf.Atan2(vel.y, vel.x) * Mathf.Rad2Deg + angleOffset;
		transform.rotation = Quaternion.AngleAxis(angle, Vector3.forward);
	}
}
