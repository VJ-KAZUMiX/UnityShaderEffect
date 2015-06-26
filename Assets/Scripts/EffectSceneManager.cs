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
		effectCtrl.startEffect (effectInfos[index]);
	}
}
