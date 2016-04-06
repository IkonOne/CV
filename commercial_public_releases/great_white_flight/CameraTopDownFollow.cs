using UnityEngine;
using System.Collections;

public class CameraTopDownFollow : MonoBehaviour {
	public Camera followCam;
	public Transform target;

	public float height = -10;
	public float damping = 5.0f;

	public Vector3 topRot;
	public Vector3 bottomRot;

	public bool freezeX = false;
	public bool freezeY = false;

	public Bounds viewBounds;
	Bounds cameraBounds;

	void Start() {
		UnityEngine.Plane worldPlane = new UnityEngine.Plane();
		worldPlane.SetNormalAndPosition(Vector3.back, Vector3.zero);

		Ray ray;
		float distance;

		ray = followCam.ViewportPointToRay(Vector3.zero);
		worldPlane.Raycast(ray, out distance);
		Vector3 viewMin = ray.GetPoint(distance);

		ray = followCam.ViewportPointToRay(Vector3.one);
		worldPlane.Raycast(ray, out distance);
		Vector3 viewMax = ray.GetPoint(distance);

		cameraBounds.min = viewBounds.min - viewMin;
		cameraBounds.max = viewBounds.max - viewMax;
	}

	void FixedUpdate () {
		Vector3 wantedPos = target.position;
		wantedPos.z = height;

		if(freezeX)
			wantedPos.x = followCam.transform.position.x;
		if(freezeY)
			wantedPos.y = followCam.transform.position.y;

		wantedPos.x = Mathf.Clamp(wantedPos.x, cameraBounds.min.x, cameraBounds.max.x);
		wantedPos.y = Mathf.Clamp(wantedPos.y, cameraBounds.min.y, cameraBounds.max.y);


		followCam.transform.position = Vector3.Lerp (followCam.transform.position, wantedPos, Time.fixedDeltaTime * damping);

		float heightRatio = (followCam.transform.position.y - cameraBounds.min.y) / cameraBounds.size.y;
		Vector3 wantedRot = Vector3.Lerp(bottomRot, topRot, heightRatio);
		followCam.transform.rotation = Quaternion.Euler(wantedRot);
	}

	void OnDrawGizmosSelected() {
		Gizmos.color = Color.blue;
		Gizmos.DrawWireCube(viewBounds.center, viewBounds.size);
	}
}
