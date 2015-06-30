Shader "Custom/ChaosShader" {
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
			
				half4 makePixelColor (float2 uv) {
					half a = sin (pow ((uv.x * 1.5 + _SinTime.z) * PI, 2));
					half b = sin (pow ((uv.y + _SinTime.x) * PI, 2));
					half c = sin (pow ((_SinTime.x + PI) * PI, 2));
					half d = ((a + 1.1) * (b + 1.1) * (c + 1.1)) + a + b + c;
				    half e = frac (d * PI * 1.1);
				    //half e = sin (d);
				    return half4 (e, e, e, 1);
				}
				
				// random noise
				half4 makeNoise (float2 co) {
					float a = frac(dot(float2 (co.x + _SinTime.x, co.y + _SinTime.y), float2 (2.067390879775102, 12.451168662908249))) - 0.5;
					float s = a * (6.182785114200511 + a*a * (-38.026512460676566 + a*a * 53.392573080032137));
					float t = frac(s * 43758.5453);
					return half4 (t, t, t, 1);
				}
				
				// pattern noise
				half4 makeNoise2 (float2 co) {
					float a = frac(dot(float2 (co.x + _SinTime.w, co.y + _CosTime.w), float2 (2.067390879775102 * _SinTime.x, 12.451168662908249 * _SinTime.y))) - _SinTime.w;
					float s = a * (6.182785114200511 + a*a * (-38.026512460676566 + a*a * 53.392573080032137)) * _SinTime.w;
					float t = frac(s * 4.37585453 * _SinTime.z);
					return half4 (t, t, t, 1);
				}
				
				// plasma
				half4 plasma(float2 p) {
					p -= 0.5;
					p *= 1000.0 * _SinTime.w, 2;
					half a = (sin(p.x)*0.25 + 0.25)+(sin(p.y)*0.25+0.25);
					return half4 (a, a, a, 1);
				}

				// rings
				float rings(float2 p) {
					//p -= 0.5;
					half a = sin(length(p)*16.0);
					return half4 (a, a, a, 1);
				}
				
				// 無限の広さを持つ二枚の平面
				float2 trans(float2 p) {
					const float height = 0.1;
					float r = height / (p.y);
					return float2 (p.x * r, r);
				}

				// 極座標
				float2 trans2(float2 p)
				{
					float theta = atan2(p.y, p.x);
					float r = length(p);
					return float2 (theta, r);
				}
				
				// xor
				float xor(float2 p)
				{
					int2 ip = int2(frac(p)*256.0);
					return float(ip.x^ip.y)/256.0;
				}
				
				//
				
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
