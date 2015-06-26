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
					half a = sin (pow ((uv.x + _SinTime.x + PI * 1.1) * PI, 2));
					half b = sin (pow ((uv.y + _SinTime.x + PI * 1.1) * PI, 2));
					half c = sin (pow ((_SinTime.x + PI) * PI, 1));
					half d = sqrt((a + 1.1) * (b + 1.1) * (c + 1.1)) + a + b + c;
				    //half e = frac (d * PI);
				    half e = sin (d);
				    return half4 (e, e, e, 1);
				}
				
				
				half4 makeNoise (float2 co) {
					float a = frac(dot(float2 (co.x + _SinTime.x, co.y + _SinTime.y), float2 (2.067390879775102, 12.451168662908249))) - 0.5;
					float s = a * (6.182785114200511 + a*a * (-38.026512460676566 + a*a * 53.392573080032137));
					float t = frac(s * 43758.5453);
					return half4 (t, t, t, 1);
				}
				
				half4 makeNoise2 (float2 co) {
					float a = frac(dot(float2 (co.x + _Time.x, co.y + _Time.y), float2 (2.067390879775102, 12.451168662908249))) - 0.5;
					float s = a * (6.182785114200511 + a*a * (-38.026512460676566 + a*a * 53.392573080032137));
					float t = frac(s);
					return half4 (t, t, t, 1);
				}
				
				sampler2D _MainTex;
			
				float4 frag(v2f IN) : COLOR {
					//half4 c = tex2D (_MainTex, IN.uv_MainTex);
					half4 c = makeNoise2 (IN.uv_MainTex);
					return c;
				}
				
			ENDCG
		}
	}
}
