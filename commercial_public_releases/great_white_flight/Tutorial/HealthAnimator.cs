using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class HealthAnimator : StateMachineBehaviour {
	public string healthSliderName = "HealthSlider";

	Slider healthSlider;
	PlayerHealth playerHealth;

	public override void OnStateEnter (Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
	{
		base.OnStateEnter (animator, stateInfo, layerIndex);

		if(healthSlider == null)
			healthSlider = GameObject.Find(healthSliderName).GetComponent<Slider>();
		if(playerHealth == null)
			playerHealth = GameObject.FindObjectOfType<PlayerHealth>();
	}

	public override void OnStateExit (Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
	{
		base.OnStateExit (animator, stateInfo, layerIndex);

		playerHealth.SendMessage("Reset");
	}

	public override void OnStateUpdate (Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
	{
		base.OnStateUpdate (animator, stateInfo, layerIndex);

		if(healthSlider.value <= healthSlider.minValue)
			animator.SetTrigger("HealthDepleted");
	}
}
