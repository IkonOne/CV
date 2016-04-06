using UnityEngine;
using System.Collections;

public class PlayOnCollisionEnter2D : MonoBehaviour {
	public LayerMask[] collisionLayers;
	public AudioClip clip;
	public bool playOnce;

	void OnCollisionEnter2D(Collision2D collision) {
		foreach (var layer in collisionLayers) {
			if(1 << collision.gameObject.layer == layer) {
				SoundManager.PlaySFX(clip);
				if(playOnce)
					this.enabled = false;
				break;
			}
		}
	}
}
