using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class GameBounds : MonoBehaviour {
	public Bounds bounds;

	public float left {
		get { return this.bounds.min.x; }
	}

	public float right {
		get { return this.bounds.max.x; }
	}

	public float top {
		get { return this.bounds.max.y; }
	}

	public float bottom {
		get { return this.bounds.min.y; }
	}

	public float width {
		get { return this.bounds.size.x; }
	}

	public float height {
		get { return this.bounds.size.y; }
	}

	void Update() {
		this.bounds.center = transform.position;
	}

	void OnDrawGizmos() {
		Gizmos.color = Color.red;
		Gizmos.DrawWireCube(bounds.center, bounds.size);
	}
}
