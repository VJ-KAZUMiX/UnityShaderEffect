Shader "Custom/VanishingShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_ProgressValue ("ProgressValue", Range(0, 1.0)) = 0.5
		_FadeLength ("FadeLength", Float) = 0.1
		_ShakeLength ("ShakeLength", Float) = 0.005
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
					//return frac(sin( dot(co.xyz ,float3(12.9898,78.233,45.5432) + _ProgressValue * PI )) * 43758.5453);
					float a = frac(dot(co.xy, float2 (2.067390879775102, 12.451168662908249))) - 0.5;
					float s = a * (6.182785114200511 + a*a * (-38.026512460676566 + a*a * 53.392573080032137));
					float t = frac(s * 43758.5453);
					return t;
				}
				
				float rand2 (float2 co) {
					half a = sin (pow ((co.x + PI * 1.1) * PI, 2) * 1.1);
					half b = sin (pow ((co.y + PI * 1.1) * PI, 2) * 1.1);
					half c = sin (pow ((_ProgressValue + PI) * PI, 2));
					half d = sqrt((a + 1.1) * (b + 1.1) * (c + 1.1)) + a + b + c;
				    return frac (d / 0.0123456789);
				}
				
				float rand3 (float2 co) {
					half a = frac(dot(co.xy, float2 (2.067390879775102, 12.451168662908249)));
					a = frac (sin (co.x * PI) * sin (co.y * PI) * sin (a * PI));
					return a;
				}
				
				struct v2f {
					float4 pos : SV_POSITION;
					float2 uv_MainTex : TEXCOORD0;
				};
			
				float4 _MainTex_ST;
				float _ShakeLength;
			
				v2f vert(appdata_full v) {
					v2f o;
					o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
					
					// 揺れ
					half shakeRadian = rand (float2 (_ProgressValue, _ProgressValue)) * PI * 2;
					o.pos.x += cos (shakeRadian) * _ShakeLength;
					o.pos.y += sin (shakeRadian) * _ShakeLength;
					
					float4 texcoord = v.texcoord;
					texcoord.x = texcoord.x * EFFECT_SCALE - (EFFECT_SCALE - 1) * 0.5;
					texcoord.y = texcoord.y * EFFECT_SCALE - (EFFECT_SCALE - 1) * 0.5;
					o.uv_MainTex = TRANSFORM_TEX(texcoord, _MainTex);
					return o;
				}
			
				sampler2D _MainTex;
				float _FadeLength;
				
				float4 frag(v2f IN) : COLOR {
					float2 uv = IN.uv_MainTex;
					
					float baseLine = 1.0 - (1.0 + _FadeLength / 5) * _ProgressValue;
					float y = uv.y - baseLine;
					float delta = _FadeLength - y;
					
					if (uv.y < 0 || delta < 0) {
						return half4 (0, 0, 0, 0);
					}

					//uv.y = (4 - (2 - uv.y) * (2 - uv.y)) / 4;
					
					half alpha = 1;
					if (uv.y > baseLine) {
						//y = (_FadeLength * 4.0 - (_FadeLength * 2.0 - delta) * (_FadeLength * 2.0 - delta)) / _FadeLength * 4.0;
						if (1 - pow (rand2 (uv), 4) > delta / _FadeLength) {
							// うーん
							uv.y = -1;
						} else {
							y = y * 0.8;
							uv.y -= y;
							// 斜め
							//uv.x += y / _FadeLength * -0.05;
							
							alpha = delta / _FadeLength;
						}
					}
							
					half4 c = tex2D (_MainTex, uv);
					if (uv.x < 0 || uv.x > 1 || uv.y < 0 || uv.y > 1) {
						c.a = 0;
					} else {
						c.a *= alpha;
					}
					return c;
				}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
