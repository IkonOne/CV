using UnityEngine;
using System.Collections;

public class TutSpawner : MonoBehaviour {
	public Animator tutorialAnimator;
	public string triggerName;

	void OnSpawned() {
		foreach(Transform child in transform) {
			if(child.GetComponent<TutEdible>() != null)
				continue;

			var edible = child.gameObject.AddComponent<TutEdible>();
			edible.tutorialAnimator = tutorialAnimator;
			edible.triggerName = triggerName;
		}
	}
}
