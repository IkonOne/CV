using UnityEngine;
using System.Collections;

public class GoldenRatio : MonoBehaviour {
	public bool randomizeOnAwake;
	public int colorIndex;
	public SpriteRenderer sprite;

	void Awake() {
		if(colors == null || randomizeOnAwake)
			GeneratePallette();

		if(sprite != null)
			sprite.color = GetColor(colorIndex);
	}

	static HSBColor[] colors;

	static public void SetSeed(int seed) {
		Random.seed = seed;
	}

	static public void RandomizeSeed() {
		SetSeed(Random.Range(int.MinValue, int.MaxValue));
	}

	static public void GeneratePallette(int numColors = 10, float saturation = 1.0f, float brightness = 1.0f) {
		colors = new HSBColor[numColors];
		float hue = Random.value;
		for (int i = 0; i < numColors; i++) {
			HSBColor color = new HSBColor(hue, saturation, brightness);
			colors[i] = color;

			hue += 0.61803398875f;
			while(hue > 1.0f)
				hue -= 1;
		}
	}

	static public Color GetColor(int index = 0) {
		return HSBColor.ToColor(colors[index]);
	}
}
