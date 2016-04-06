using UnityEngine;
using UnityEngine.SocialPlatforms;
using UnityEngine.SocialPlatforms.GameCenter;
#if UNITY_ANDROID
using GooglePlayGames;
#endif
using System.Collections;

public class InitiateGameServices : MonoBehaviour {
	void Awake() {
		if(!Social.localUser.authenticated) {
#if UNITY_ANDROID
			PlayGamesPlatform.Activate();
#elif UNITY_IOS
//			GameCenterPlatform.Authenticate();
#endif
			Social.localUser.Authenticate(ProcessAuthentication);
		}
	}

	void ProcessAuthentication(bool success) {
		if(!success)
			Debug.LogWarning("Social Services not initiated");
		else {
			Debug.Log(Social.localUser.userName);
		}
	}
}
