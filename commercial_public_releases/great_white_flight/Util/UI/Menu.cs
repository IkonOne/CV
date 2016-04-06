using UnityEngine;
using System.Collections;

public class Menu : MonoBehaviour {
	public MenuManager manager;

	private Animator _animator;
	private CanvasGroup _canvasGroup;

	void Awake() {
		_animator = GetComponent<Animator>();
		_canvasGroup = GetComponent<CanvasGroup>();

		// Resets the menu to the center of the screen so that we can play with it all we want in the editor.
		var rect = GetComponent<RectTransform>();
		rect.offsetMax = rect.offsetMin = Vector2.zero;
	}

	void Update() {
		bool animatorOpen = _animator.GetCurrentAnimatorStateInfo(0).IsName("Open");
		_canvasGroup.blocksRaycasts = _canvasGroup.interactable = animatorOpen;

	}

	void OnCloseComplete() {
		manager.SendMessage("OnMenuClosed", this);
	}
}
