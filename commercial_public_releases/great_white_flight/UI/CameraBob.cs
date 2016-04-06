using UnityEngine;
using System.Collections;

public class CameraBob : MonoBehaviour {
	public float speed = 1;
	public float size = 0.5f;

	float currAngle = 0;
	Vector3 initialPos;

	// Use this for initialization
	void Start () {
		initialPos = transform.position;
	}
	
	// Update is called once per frame
	void Update () {
		currAngle += Time.deltaTime * speed;
		Vector3 pos = initialPos;
		pos.y += Mathf.Sin(currAngle) * size;
		transform.position = pos;
	}
}
