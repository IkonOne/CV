using UnityEngine;
using System.Collections;

[RequireComponent(typeof(CircleCollider2D))]
public class PlayerMouth : MonoBehaviour {
	[SerializeField]
	private SkinnedMeshRenderer skinnedMesh;

	[SerializeField]
	private Transform backOfMouth;

	[SerializeField]
	private float distance;

	[SerializeField]
	private LayerMask biteLayer;

	private CircleCollider2D circleCollider;
	private bool isBiting;
	private float rayDistance;

	void Awake() {
		circleCollider = GetComponent<CircleCollider2D>();
		circleCollider.enabled = false;
		rayDistance = (transform.position - backOfMouth.position).magnitude + circleCollider.radius;
	}

	void Update() {
		RaycastHit2D hit = Physics2D.CircleCast(backOfMouth.position, circleCollider.radius, (transform.position - backOfMouth.position).normalized, rayDistance, 1 << LayerMask.NameToLayer("Enemy"));
		float biteRatio = 1;
		if(hit.distance > 0)
			biteRatio = Mathf.Clamp01(hit.distance / rayDistance);

		skinnedMesh.SetBlendShapeWeight(1, (1 - biteRatio) * 100);
	}
}
