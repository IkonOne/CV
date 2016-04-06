using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class PlayerTail : MonoBehaviour {
	public GameObject piecePrefab;
	public Transform player;
	public float segmentLength = 5;
	public int numSegments = 10;

	//  Will a list be easier?
	List<GameObject> tailPieces;

	float distTravelled;

	// Use this for initialization
	void Start () {
		distTravelled = 0;

		// +2 because the player position is the head and the last piont is 
		tailPieces = new List<GameObject>();
		for(int i = 0; i < numSegments; i++) {
			GameObject go = (GameObject)Instantiate(piecePrefab);
			go.transform.parent = transform;
			go.transform.position = player.position;
			tailPieces.Add(go);
		}
	}

	void FixedUpdate() {
		distTravelled += Time.fixedDeltaTime * player.GetComponent<Rigidbody2D>().velocity.magnitude;
		if(distTravelled > segmentLength)
		{
			distTravelled = 0;
			GameObject last = tailPieces[tailPieces.Count - 1];
			tailPieces.Remove(last);
			last.transform.position = player.position;
			tailPieces.Insert(0, last);
		}
	}
}
