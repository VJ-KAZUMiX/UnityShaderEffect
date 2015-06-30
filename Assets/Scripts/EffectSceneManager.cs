using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class EffectSceneManager : MonoBehaviour
{

	[SerializeField]
	private EffectCtrl effectCtrl;

	[SerializeField]
	private Material[] effectMaterials;

	private EffectCtrl.EffectInfo[] effectInfos;

	[SerializeField]
	private RawImage rawImageBG;

	[SerializeField]
	private Material[] bgEffectMaterials;

	// Use this for initialization
	void Start ()
	{
		effectInfos = new EffectCtrl.EffectInfo[2] {
			new EffectCtrl.EffectInfo (effectMaterials[0], 0.75f, 0.5f),
			new EffectCtrl.EffectInfo (effectMaterials[1], 5.0f, 0.5f),
		};
	}

	public void toggleEffectClickHandler (int index)
	{
		if (index < 0 || index >= effectInfos.Length) {
			effectCtrl.stopAndReset ();
		} else {
			effectCtrl.startEffect (effectInfos[index]);
		}
	}

	public void toggleBGEffectClickHandler (int index)
	{
		if (index < 0 || index >= bgEffectMaterials.Length) {
			rawImageBG.gameObject.SetActive (false);
		} else {
			rawImageBG.gameObject.SetActive (true);
			rawImageBG.material = bgEffectMaterials[index];
		}
	}
}
