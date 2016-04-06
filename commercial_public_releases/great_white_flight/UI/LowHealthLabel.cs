using UnityEngine;
using UnityEngine.UI;
using System;
using System.Collections;

[ExecuteInEditMode, RequireComponent(typeof(Text))]
public class LowHealthLabel : MonoBehaviour {
	public Slider slider;
	public float colorLerp = 5;
	public HealthRange[] healthRanges;

	Text label;

	void Start() {
		label = GetComponent<Text>();
	}

	void LateUpdate() {
		foreach (var range in healthRanges) {
			if(slider.value >= range.minValue && slider.value < range.maxValue) {
				label.color = Color.Lerp(label.color, range.color, Time.deltaTime * colorLerp);
				break;
			}
		}
	}
}

[Serializable]
public class HealthRange {
	[Range(0, 1)]
	public float minValue = 0;

	[Range(0, 1)]
	public float maxValue = 1;

	public Color color;
}