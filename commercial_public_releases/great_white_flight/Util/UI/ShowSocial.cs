using UnityEngine;
using UnityEngine.SocialPlatforms;
using System.Collections;

public class ShowSocial : MonoBehaviour {
	public void OnShowLeaderboards() {
		if(Social.localUser.authenticated)
			Social.ShowLeaderboardUI();
	}

	public void OnShowAchievements() {
		if(Social.localUser.authenticated)
			Social.ShowAchievementsUI();
	}
}
