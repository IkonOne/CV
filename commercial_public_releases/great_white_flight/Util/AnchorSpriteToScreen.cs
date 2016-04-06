using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class AnchorSpriteToScreen : MonoBehaviour {
	public Vector2 Anchor = Vector2.one;

	void Update () {
		float y = ScreenBounds.instance.bottom + ScreenBounds.instance.height * Anchor.y;
		float x = ScreenBounds.instance.left + ScreenBounds.instance.width * Anchor.x;

		Vector3 pos = transform.position;
		pos.x = x;
		pos.y = y;
		pos.z = transform.position.z;
		transform.position = pos;
	}
}
