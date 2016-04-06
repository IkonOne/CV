using UnityEngine;
using System.Collections;

public class Screenshot : MonoBehaviour {
	public string folder = "/Users/MaskedPixel/Desktop/Screens/";
	public int scale = 1;

	// Use this for initialization
	void Start () {
		DontDestroyOnLoad(gameObject);
	}

	void Update() {
		if(Input.GetKeyDown(KeyCode.A)) {
			Application.CaptureScreenshot(folder + Application.loadedLevelName + "_" + System.DateTime.Now.TimeOfDay.Ticks.ToString() + ".png", scale);
		}
	}
}
