Shader "Custom/SimpleOutlineShader"
{
    Properties
    {
		_Color ("Main Color", Color) = (1,1,1,1)
		_Outline ("Outline", float) = 0
    }
    SubShader
    {
		Pass
		{
		Cull Front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform float _Outline;

			struct appData
			{
				float4 position : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex: SV_POSITION;
			};

			v2f vert(appData v)
			{
				v2f o;
				float4 r = v.position;

				float3 normal = normalize(v.normal);
				r += float4(normal, 0.0) * _Outline;
				o.vertex = UnityObjectToClipPos(r);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				
				return float4(1,1,1,1);
			}
			ENDCG

		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appData
			{
				float4 position : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex: SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appData v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.position);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			fixed4 _Color;

			fixed4 frag(v2f i) : SV_Target
			{
				//fixed4 col = tex2D(_MainTex, i.uv);
				return _Color;
			}
			ENDCG
		}
		Pass
		{
			ZTest Greater
			Color [_Color]
		}
		Pass
		{
			ZTest Less
		}
        
    }
    FallBack "Diffuse"
}
