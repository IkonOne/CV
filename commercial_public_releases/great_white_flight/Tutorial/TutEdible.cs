using UnityEngine;
using System.Collections;

public class TutEdible : MonoBehaviour {
	public Animator tutorialAnimator;
	public string triggerName;

	void OnHitPlayer() {
		tutorialAnimator.SetTrigger(triggerName);
	}
}
