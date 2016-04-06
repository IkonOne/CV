using UnityEngine;
using System.Collections;

public class FSM : MonoBehaviour {
	public FSMState initialState;

	FSMState currentState;

	void Start() {
		currentState = initialState;
		currentState.enabled = true;
	}

	public void TransitionToState(FSMState state) {
		if(currentState == state)
			return;

		currentState.enabled = false;
		currentState = state;
		currentState.enabled = true;
	}

}
