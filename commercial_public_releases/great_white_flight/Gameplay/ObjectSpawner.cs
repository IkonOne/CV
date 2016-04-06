using UnityEngine;
using System.Collections;

public class ObjectSpawner : MonoBehaviour {
	public GameObject prefab;
	public float delay;
	public float horizBuffer;

	public AnimationCurve objCount;
	public float timeToMax;

	public Bounds bounds;

	float _elapsed;

	GameBounds gameBounds;

	// Use this for initialization
	void Start () {
		_elapsed = 0;
		gameBounds = GameObject.FindObjectOfType<GameBounds>();

		prefab.CreatePool();
	}

	void Update() {
		int count = Mathf.FloorToInt(objCount.Evaluate(_elapsed / timeToMax * 10));

		while(transform.childCount < count) {
			SpawnObject();
		}

		_elapsed += Time.deltaTime;
	}

	void SpawnObject() {
		Vector3 pos = Vector3.zero;
		pos.y = Random.Range(bounds.min.y, bounds.max.y);
		if(Random.value > 0.5f)
			pos.x = gameBounds.right + horizBuffer * gameBounds.width;
		else
			pos.x = gameBounds.left - horizBuffer * gameBounds.width;

		GameObject go = prefab.Spawn(transform, pos, Quaternion.identity);
		go.BroadcastMessage("OnSpawned");

		gameObject.SendMessage("OnSpawned", SendMessageOptions.DontRequireReceiver);
	}

	void OnDrawGizmosSelected() {
		Gizmos.DrawWireCube(bounds.center, bounds.size);
	}
}
