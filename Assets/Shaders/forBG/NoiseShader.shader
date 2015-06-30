Shader "Custom/NoiseShader" {
	Properties {
		//_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		//Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		//LOD 300
		
		//Blend SrcAlpha OneMinusSrcAlpha
		//ZWrite Off
		
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		Pass {
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				#define PI 3.14159
				
				struct v2f {
					float4 pos : SV_POSITION;
					float2 uv_MainTex : TEXCOORD0;
				};
			
				//float4 _MainTex_ST;
			
				v2f vert(appdata_base v) {
					v2f o;
					o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
					//o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.uv_MainTex = v.texcoord;
					return o;
				}
			
				// pattern noise
				half4 makeNoise2 (float2 co) {
					float a = frac(dot(float2 (co.x + _SinTime.w, co.y + _CosTime.w), float2 (2.067390879775102 * _SinTime.x, 12.451168662908249 * _SinTime.y))) - _SinTime.w;
					float s = a * (6.182785114200511 + a*a * (-38.026512460676566 + a*a * 53.392573080032137)) * _SinTime.w;
					float t = frac(s * 4.37585453 * _SinTime.z);
					return half4 (t, t, t, 1);
				}
				
				sampler2D _MainTex;
			
				float4 frag(v2f IN) : COLOR {
					//half4 c = tex2D (_MainTex, IN.uv_MainTex);
					//half4 c = rings (IN.uv_MainTex);
					//half4 scrPos = ComputeScreenPos(IN.pos);
					//float2 wcoord = (scrPos.xy/scrPos.w);
					//half4 c = makeNoise2 (xor (IN.uv_MainTex));
					half4 c = makeNoise2 ( (IN.uv_MainTex - 0.5));
					//half4 c = IN.pos / _ScreenParams.x;
					return c;
				}
				
			ENDCG
		}
	}
}
