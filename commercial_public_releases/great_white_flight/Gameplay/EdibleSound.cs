using UnityEngine;
using System.Collections;

[RequireComponent(typeof(AudioSource))]
public class EdibleSound : MonoBehaviour {

	void OnTriggerEnter2D(Collider2D other) {
		if(other.gameObject.name == "Player")
			GetComponent<AudioSource>().Play();
	}
}
