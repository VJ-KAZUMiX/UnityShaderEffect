using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class EffectCtrl : MonoBehaviour {

	public class EffectInfo
	{
		public EffectInfo (Material effectMaterial, float effectDuration, float waitDuration)
		{
			this.effectMaterial = effectMaterial;
			this.effectDuration = effectDuration;
			this.waitDuration = waitDuration;
		}

		public Material effectMaterial;
		public float effectDuration;
		public float waitDuration;
	}

	private EffectInfo effectInto;

	[SerializeField]
	private RawImage rawImage;

	private float timer;

	private Coroutine currentEffectCoroutine = null;

	// Use this for initialization
	void Start ()
	{
		rawImage.material.SetFloat ("_ProgressValue", 0.0f);
	}

	public void startEffect (EffectInfo effectInfo)
	{
		if (currentEffectCoroutine != null) {
			StopCoroutine (currentEffectCoroutine);
			currentEffectCoroutine = null;
		}
		if (effectInfo.effectMaterial != null) {
			rawImage.material = effectInfo.effectMaterial;
		}

		this.effectInto = effectInfo;
		currentEffectCoroutine = StartCoroutine (effectCoroutine ());
	}

	private IEnumerator effectCoroutine ()
	{
		while (true) {
			timer = 0;
			while (timer < effectInto.effectDuration) {
				rawImage.material.SetFloat ("_ProgressValue", timer / effectInto.effectDuration);
				timer += Time.deltaTime;
				yield return null;
			}
			rawImage.material.SetFloat ("_ProgressValue", 1.0f);
			
			timer = 0;
			while (timer < effectInto.waitDuration) {
				timer += Time.deltaTime;
				yield return null;
			}
			
			timer = 0;
			while (timer < effectInto.effectDuration) {
				rawImage.material.SetFloat ("_ProgressValue", 1.0f - timer / effectInto.effectDuration);
				timer += Time.deltaTime;
				yield return null;
			}
			rawImage.material.SetFloat ("_ProgressValue", 0.0f);

			timer = 0;
			while (timer < effectInto.waitDuration) {
				timer += Time.deltaTime;
				yield return null;
			}
		}
	}
}
