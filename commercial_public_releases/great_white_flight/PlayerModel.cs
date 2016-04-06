using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Rigidbody2D))]
public class PlayerModel : MonoBehaviour {
    public Transform playerModel;
	public float rightAngle = 270f;
	public float leftAngle = 90f;

	public float speed = 180;

	Rigidbody2D rigidbody2D;

	void Awake() {
		rigidbody2D = GetComponent<Rigidbody2D>();
	}

	void Update () {
		Vector3 rotation = playerModel.localRotation.eulerAngles;
		rotation.y = Mathf.Lerp(rotation.y, (rigidbody2D.velocity.x > 0 ? rightAngle : leftAngle), Time.deltaTime * speed);
		playerModel.localRotation = Quaternion.Euler(rotation);
	}
}
