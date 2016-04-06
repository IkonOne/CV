using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class ScreenBounds : MonoBehaviour {
	private static ScreenBounds _instance = null;
	public static ScreenBounds instance {
		get {
			if(_instance != null)
				return _instance;

			_instance = Camera.main.gameObject.GetComponent<ScreenBounds>();
			if(_instance != null)
				return _instance;

			_instance = Camera.main.gameObject.AddComponent<ScreenBounds>();

			return _instance;
		}
	}

	Camera gameCam;

	void Awake() {
		gameCam = GetComponent<Camera>();
	}

	public float top {
		get {
			return gameCam.ScreenToWorldPoint(Vector3.up * Screen.height).y;
		}
	}

	public float bottom {
		get {
			return gameCam.ScreenToWorldPoint(Vector3.zero).y;
		}
	}

	public float right {
		get {
			return gameCam.ScreenToWorldPoint(Vector3.right * Screen.width).x;
		}
	}

	public float left {
		get {
			return gameCam.ScreenToWorldPoint(Vector3.zero).x;
		}
	}

	public float width {
		get {
			return gameCam.orthographicSize * 2 / Screen.height * Screen.width;
		}
	}

	public float height {
		get {
			return gameCam.orthographicSize * 2;
		}
	}
}
