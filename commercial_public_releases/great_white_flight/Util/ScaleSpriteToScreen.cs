using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class ScaleSpriteToScreen : MonoBehaviour {
	public Vector2 Factor = Vector2.one;

	// Update is called once per frame
	void Update() {
		transform.localScale = Vector3.one;
		var spriteWidth = GetComponent<Collider2D>().bounds.size.x;
		var spriteHeight = GetComponent<Collider2D>().bounds.size.y;

		var worldScreenHeight = Camera.main.orthographicSize * 2;
		var worldScreenWidth = worldScreenHeight / Screen.height * Screen.width;

		Vector3 scale = transform.localScale;
		if(Factor.x != 0)
			scale.x = worldScreenWidth / spriteWidth * Factor.x;

		if(Factor.y != 0)
			scale.y = worldScreenHeight / spriteHeight * Factor.y;

		transform.localScale = scale;
	}
}
