using UnityEngine;
using System.Collections;

public class PlayAgain : MonoBehaviour {

	void Update () {
		if(Input.anyKeyDown)
		{
			Application.LoadLevel("PlayScene");
			Time.timeScale = 1;
		}
	}
}
