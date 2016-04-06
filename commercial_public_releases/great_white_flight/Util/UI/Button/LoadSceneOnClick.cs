using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class LoadSceneOnClick : MonoBehaviour {
	public string sceneName;
	public int sceneNumber = -1;

	void Awake() {
		var button = GetComponent<Button>();
		button.onClick.AddListener(() => {
			if(!string.IsNullOrEmpty(sceneName))
				Application.LoadLevel(sceneName);
			else if(sceneNumber >= 0)
				Application.LoadLevel(sceneNumber);
		});
	}
}
