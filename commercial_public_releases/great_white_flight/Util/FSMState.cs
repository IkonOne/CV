using UnityEngine;
using System.Collections;

public class FSMState : MonoBehaviour {
	protected FSM _fsm;

	protected virtual void OnEnable() {
		_fsm = GetComponent<FSM>();
	}
}
