using UnityEngine;
using GooglePlayGames;
using System.Collections;

public class Achievements : MonoBehaviour {
	private const string ACH_PESCETARIAN = "CgkI-fbMrYEUEAIQAw";
	private const string ACH_AVIAN_ACTIVIST = "CgkI-fbMrYEUEAIQBA";
	private const string ACH_GROUND_TO_AIR = "CgkI-fbMrYEUEAIQBQ";
	private const string ACH_PACIFIST = "CgkI-fbMrYEUEAIQBg";
	private const string ACH_BOMB_GORGER = "CgkI-fbMrYEUEAIQBw";

	private int numBirds;
	private int numPlanes;
	private int numFish;
	private int numBombs;

	void Awake() {
		numBirds = 0;
		numPlanes = 0;
		numFish = 0;
		numBombs = 0;
	}

	void OnGameOver() {
		if(numBirds == 0 && numPlanes == 0 && numFish == 0)
			PlayGamesPlatform.Instance.ReportProgress(ACH_PACIFIST, 100.0f, null);
	}

	void OnEdibleEaten(Edible.EdibleType edibleType) {
		switch(edibleType) {
		case Edible.EdibleType.Bird:
			BirdEaten();
			break;

		case Edible.EdibleType.Fish:
			FishEaten();
			break;

		case Edible.EdibleType.Plane:
			PlaneEaten();
			break;

		default:
			break;
		}
	}

	void OnBombHit() {
		numBombs++;

		if(numBombs == 5 && PlayGamesPlatform.Instance.IsAuthenticated())
			PlayGamesPlatform.Instance.ReportProgress(ACH_BOMB_GORGER, 100.0f, null);
	}

	void BirdEaten() {
		if(PlayGamesPlatform.Instance.IsAuthenticated())
			PlayGamesPlatform.Instance.IncrementAchievement(ACH_AVIAN_ACTIVIST, 1, null);

		numBirds++;
	}

	void FishEaten() {
		if(PlayGamesPlatform.Instance.IsAuthenticated())
			PlayGamesPlatform.Instance.IncrementAchievement(ACH_PESCETARIAN, 1, null);

		numFish++;
	}

	void PlaneEaten() {
		if(PlayGamesPlatform.Instance.IsAuthenticated())
			PlayGamesPlatform.Instance.IncrementAchievement(ACH_GROUND_TO_AIR, 1, null);

		numPlanes++;
	}
}
