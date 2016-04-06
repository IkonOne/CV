using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class OpenUrlOnClick : MonoBehaviour {
	public string URL;

	void Awake() {
		var button = GetComponent<Button>();
		button.onClick.AddListener(() => {
			if(!string.IsNullOrEmpty(URL))
				Application.OpenURL(URL);
		});
	}
}
