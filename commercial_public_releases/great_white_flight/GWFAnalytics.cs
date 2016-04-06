using UnityEngine;
using UnityEngine.Analytics;
using System.Collections;
using System.Collections.Generic;

public class GWFAnalytics : MonoBehaviour {

	int numBirds;
	int numFish;
	int numPlanes;
	int numBombs;

	float timeAlive;

	void Update() {
		timeAlive += Time.deltaTime;
	}

	void OnGameOver() {
		var data = 
		new Dictionary<string, object>{
			{"birds", numBirds},
			{"fish", numFish},
			{"planes", numPlanes},
			{"bombs", numBombs},
			{"timeAlive", timeAlive}
		};

		Debug.Log(data);

		Analytics.CustomEvent("GameOver", data);
	}

	void OnEdibleEaten(Edible.EdibleType edibleType) {
		switch(edibleType) {
		case Edible.EdibleType.Bird:
			numBirds++;
			break;
			
		case Edible.EdibleType.Fish:
			numFish++;
			break;
			
		case Edible.EdibleType.Plane:
			numPlanes++;
			break;
			
		default:
			break;
		}
	}

	void OnHitBomb() {
		numBombs++;
	}
}
