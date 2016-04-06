using UnityEngine;
using FullInspector;
using System.Collections;
using System.Collections.Generic;

public class HitGraphics : BaseBehavior {
	public enum Graphic {
		Yum,
		Boom,
		Chomp
	}

	public Dictionary<HitGraphics.Graphic, GameObject> prefabs;

	// Use this for initialization
	void Start () {
		foreach (var key in prefabs.Keys) {
			prefabs[key].CreatePool();
		}
	}

	public void SpawnGraphic(Graphic type, Vector3 position) {
		if(!prefabs.ContainsKey(type)) {
			Debug.LogWarning(type.ToString() + " is not assigned as a hit graphic.");
			return;
		}
		prefabs[type].Spawn(position);
	}
}
