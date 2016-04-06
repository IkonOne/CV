using UnityEngine;
using System.Collections;

[RequireComponent(typeof(AudioSource))]
public class PlayerSound : MonoBehaviour {
	public AudioClip land;
	public AudioClip jump;
	public AudioClip eat;

	void OnTriggerEnter2D(Collider2D other) {
		if(other.gameObject.name == "Ground")
			SoundManager.PlaySFX(land);
	}

	void OnTriggerExit2D(Collider2D other) {
		if(other.gameObject.name == "Ground")
			SoundManager.PlaySFX(jump);
	}

	void OnCollideEdible() {
		SoundManager.PlaySFX(eat);
	}

	void PlaySound(AudioClip clip) {
		GetComponent<AudioSource>().clip = clip;
		GetComponent<AudioSource>().Play();
	}
}
