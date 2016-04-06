using UnityEngine;
using System.Collections;

public class MenuClose : StateMachineBehaviour {

	// Update is called once per frame
	override public void OnStateUpdate(Animator animator, AnimatorStateInfo animatorStateInfo, int layerIndex) {
		if(animatorStateInfo.normalizedTime >= 1.0f)
			animator.SendMessage("OnCloseComplete");
	}
}
