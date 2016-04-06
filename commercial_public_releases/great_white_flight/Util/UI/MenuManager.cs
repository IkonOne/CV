using UnityEngine;
using System.Collections;

public class MenuManager : MonoBehaviour {
	public Menu currentMenu;

	private Menu _nextMenu;

	void Start() {
		ShowMenu(currentMenu);
	}

	public void ShowMenu(Menu menu) {
		if(currentMenu == menu) {
			currentMenu.GetComponent<Animator>().SetTrigger("Open");
			return;
		}

		if(currentMenu == _nextMenu)
			return;

		_nextMenu = menu;
		currentMenu.GetComponent<Animator>().SetTrigger("Close");
	}

	void OnMenuClosed(Menu menu) {
		if(currentMenu != menu)
			return;

		if(_nextMenu == null)
			return;

		currentMenu = _nextMenu;
		_nextMenu = null;
		currentMenu.GetComponent<Animator>().SetTrigger("Open");
	}
}
