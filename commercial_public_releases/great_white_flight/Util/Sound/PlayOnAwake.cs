using UnityEngine;
using System.Collections;

public class PlayOnAwake : MonoBehaviour {
	public AudioClip clip;
	public float delay = 0f;
	public float volume = 1f;
	public float pitch = 1f;
	public Transform target;

	void Awake() {
		SoundManager.PlaySFX(clip, false, delay, volume, pitch);
	}
}
