Shader "Custom/SinRasterShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_ProgressValue ("ProgressValue", Range(0, 1.0)) = 0.5
		_MaxSlideAmount ("Max Slide Amount", Float) = 0.5
	}
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 300
		
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off
		
		Pass {
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				#define PI 3.14159
				#define EFFECT_SCALE 2.0
			
				float _ProgressValue;

				float rand (float2 co) {
					half a = sin (pow ((co.x + PI * 1.1) * PI, 2) * 1.1);
					half b = sin (pow ((co.y + PI * 1.1) * PI, 2) * 1.1);
					half c = sin (pow ((_ProgressValue + PI) * PI, 2));
					half d = sqrt((a + 1.1) * (b + 1.1) * (c + 1.1)) + a + b + c;
				    return frac (d / 0.123456789);
				}

				struct v2f {
					float4 pos : SV_POSITION;
					float2 uv_MainTex : TEXCOORD0;
				};
			
				float4 _MainTex_ST;
			
				v2f vert(appdata_full v) {
					v2f o;
					o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
					float4 texcoord = v.texcoord;
					texcoord.x = texcoord.x * EFFECT_SCALE - (EFFECT_SCALE - 1) * 0.5;
					texcoord.y = texcoord.y * EFFECT_SCALE - (EFFECT_SCALE - 1) * 0.5;
					o.uv_MainTex = TRANSFORM_TEX(texcoord, _MainTex);
					return o;
				}
			
				sampler2D _MainTex;
				float _MaxSlideAmount;
				
				float4 frag(v2f IN) : COLOR {
					float2 uv = IN.uv_MainTex;
					half direction = sin (rand(float2 (uv.y, uv.y)) * PI * 2.0) * _ProgressValue * _MaxSlideAmount;
					uv.x += direction;
					direction = cos (rand(float2 (uv.x, uv.x)) * PI * 2.0) * _ProgressValue * _MaxSlideAmount / 2.0;
					uv.y += direction;
					half4 c = tex2D (_MainTex, uv);
					if (uv.x < 0 || uv.x > 1 || uv.y < 0 || uv.y > 1) {
						c.a = 0;
					} else {
						c.a = c.a * (1 - _ProgressValue);
					}
					return c;
				}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
