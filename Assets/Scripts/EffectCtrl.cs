using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class EffectCtrl : MonoBehaviour {

	[SerializeField]
	private RawImage rawImage;

	private float timer;

	private float effectDuration;
	private float waitDuration;

	private Coroutine currentEffectCoroutine = null;

	// Use this for initialization
	void Start ()
	{
		startEffect (5, 0.5f);
	}

	public void startEffect (float effectDuration, float waitDuration)
	{
		if (currentEffectCoroutine != null) {
			StopCoroutine (currentEffectCoroutine);
			currentEffectCoroutine = null;
		}

		this.effectDuration = effectDuration;
		this.waitDuration = waitDuration;

		currentEffectCoroutine = StartCoroutine (effectCoroutine ());
	}

	private IEnumerator effectCoroutine ()
	{
		while (true) {
			timer = 0;
			while (timer < effectDuration) {
				rawImage.material.SetFloat ("_ProgressValue", timer / effectDuration);
				timer += Time.deltaTime;
				yield return null;
			}
			rawImage.material.SetFloat ("_ProgressValue", 1.0f);
			
			timer = 0;
			while (timer < waitDuration) {
				timer += Time.deltaTime;
				yield return null;
			}
			
			timer = 0;
			while (timer < effectDuration) {
				rawImage.material.SetFloat ("_ProgressValue", 1.0f - timer / effectDuration);
				timer += Time.deltaTime;
				yield return null;
			}
			rawImage.material.SetFloat ("_ProgressValue", 0.0f);

			timer = 0;
			while (timer < waitDuration) {
				timer += Time.deltaTime;
				yield return null;
			}
		}
	}
}
