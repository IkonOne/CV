using UnityEngine;
using System.Collections;

public class PlayOnTrigger2D : MonoBehaviour {
	public LayerMask[] triggerLayers;
	public AudioClip clip;
	public bool playOnce;

	void OnTriggerEnter2D(Collider2D other) {
		foreach (var layer in triggerLayers) {
			if(1 << other.gameObject.layer == layer) {
				SoundManager.PlaySFX(clip);
				if(playOnce)
					this.enabled = false;
				break;
			}
		}
	}
}
