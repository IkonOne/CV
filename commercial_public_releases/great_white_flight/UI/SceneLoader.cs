using UnityEngine;
using System.Collections;

public class SceneLoader : MonoBehaviour {
	public string scene;

	public void LoadScene() {
		Application.LoadLevel(scene);
	}
}
