Shader "Custom/CircleLightShader" {
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
			
				half4 circle (float2 uv) {
					//float2 position = ( gl_FragCoord.xy / resolution.xy ) + vec2(-0.5, -0.5); position.x *= resolution.x/resolution.y; position*=0.5;
					float2 position = uv;// - 0.5;
					float3 color = float3(0.0, 0.0, 0.0);
					const int count = 3;
					
					for (int i = 0; i < 3; i++) {
						float radius = 0.2 + sin(_Time.z - i * 0.2) * 0.3;
						for (int j = 0; j < count; j++) {
							float angle = float(j) * (2.0 * PI / float(count)) - _Time.z + i * 0.2;
							float2 pos = float2(cos(angle) * radius, sin(angle) * radius);
							color[i] += pow(0.2 / distance(position, pos), 1.5);
						}
					}
					
					return half4 (color.x, color.y, color.z, 1.0);
				}
				
				//
				
				sampler2D _MainTex;
			
				float4 frag(v2f IN) : COLOR {
					//half4 c = tex2D (_MainTex, IN.uv_MainTex);
					//half4 c = rings (IN.uv_MainTex);
					//half4 scrPos = ComputeScreenPos(IN.pos);
					//float2 wcoord = (scrPos.xy/scrPos.w);
					//half4 c = makeNoise2 (xor (IN.uv_MainTex));
					half4 c = circle ( (IN.uv_MainTex - 0.5));
					//half4 c = IN.pos / _ScreenParams.x;
					return c;
				}
				
			ENDCG
		}
	}
}
