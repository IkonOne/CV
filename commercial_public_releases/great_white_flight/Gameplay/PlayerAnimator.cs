using UnityEngine;
using System.Collections;

public class PlayerAnimator : MonoBehaviour {
	[SerializeField]
	private Animator animator;

	[SerializeField]
	private LayerMask waterLayer;


	void OnTriggerEnter2D(Collider2D other) {
		if(1 << other.gameObject.layer == waterLayer)
			animator.SetBool("Swimming", true);
	}

	void OnTriggerExit2D(Collider2D other) {
		if(1 << other.gameObject.layer == waterLayer)
			animator.SetBool("Swimming", false);
	}
}
