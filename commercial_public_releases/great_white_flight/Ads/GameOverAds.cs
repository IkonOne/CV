using UnityEngine;
using UnityEngine.Advertisements;
using System.Collections;

public class GameOverAds : MonoBehaviour {
	private GameOverAds _instance;

	public string androidID;
	public string iosID;
	public float adDelay = 180;

	float lastAd;

	void Awake() {
		if(_instance != null) {
			DestroyImmediate(gameObject);
			return;
		}
		_instance = this;
		DontDestroyOnLoad(gameObject);

		if (Advertisement.isSupported) {
			Advertisement.allowPrecache = true;
#if UNITY_ANDROID
			Advertisement.Initialize (androidID);
#elif UNITY_IOS
			Advertisement.Initialize (iosID);
#endif
		} else {
			Debug.Log("Platform not supported");
		}
	}

	void OnLevelWasLoaded() {
		CheckAds();
	}

	void CheckAds() {
		if(Time.time - lastAd > adDelay) {
			lastAd = Time.time;
			PlayerPrefs.SetFloat("LastAd", lastAd);
			PlayerPrefs.Save();
			// Show Ad
			Advertisement.Show(null, new ShowOptions {
				pause = true,
				resultCallback = result => {
					Debug.Log(result.ToString());
				}
			});
		}
	}
}
