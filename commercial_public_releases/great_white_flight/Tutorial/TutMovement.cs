using UnityEngine;
using System.Collections;

public class TutMovement : FSMState {
	public GameObject movementPanel;
	public FSMState nextState;

	bool movedRight;
	bool movedLeft;

	override protected void OnEnable() {
		base.OnEnable();

		movementPanel.SetActive(true);
	}

	void Update() {
		if(movedRight && movedLeft)
			_fsm.TransitionToState(nextState);
	}

	void Finish() {
		movementPanel.SetActive(false);
	}

	public void OnMovedRight() {
		movedRight = true;
	}

	public void OnMovedLeft() {
		movedLeft = true;
	}
}
