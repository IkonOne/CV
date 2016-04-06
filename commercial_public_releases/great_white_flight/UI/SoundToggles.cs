using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class SoundToggles : MonoBehaviour {
	public Toggle sfxToggle;
	public Toggle musicToggle;

	void Start() {
		sfxToggle.isOn = !SoundManager.Instance.mutedSFX;
		musicToggle.isOn = SoundManager.Instance.mutedMusic;
	}

	public void OnSfxToggled() {
		SoundManager.Instance.mutedSFX = !sfxToggle.isOn;
	}

	public void OnMusicToggled() {
		SoundManager.Instance.mutedMusic = musicToggle.isOn;
	}
}
