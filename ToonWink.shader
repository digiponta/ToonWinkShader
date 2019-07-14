// Modified Unity Toon/Base
//
Shader "Toon/Wink001" {
Properties
{
_Color ("Main Color", Color) = (.5,.5,.5,1)
_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
// _ToonShade ("ToonShader Cubemap(RGB)", CUBE) = "" { }
_WinkTex ("Wink (RGB) Trans (A)", 2D) = "white" {}
_MainBumpMap ("Normal Map Base", 2D) = "white" {}
_WinkBumpMap ("Normal Map Wink", 2D) = "white" {}
}
SubShader {
Tags { "RenderType"="Opaque" }
Pass {
Name "BASE"
Cull Off

CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma multi_compile_fog
 #include "UnityCG.cginc"
 sampler2D _MainTex;
sampler2D _WinkTex;
sampler2D _MainBumpMap;
sampler2D _WinkBumpMap;
samplerCUBE _ToonShade;
float4 _MainTex_ST;
float4 _Color;
 struct appdata {
float4 vertex : POSITION;
float2 texcoord : TEXCOORD0;
float3 normal : NORMAL;
};
struct v2f {
float4 pos : SV_POSITION;
float2 texcoord : TEXCOORD0;
float3 cubenormal : TEXCOORD1;
UNITY_FOG_COORDS(2)
};
 v2f vert (appdata v)
{
v2f o;
o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
o.cubenormal = mul (UNITY_MATRIX_MV, float4(v.normal,0));
UNITY_TRANSFER_FOG(o,o.pos);
return o;
}
 fixed4 frag (v2f i) : SV_Target
{
fixed4 col;
if ( (sin(_Time.y/2.0f) > 0) && (sin(_Time.y/2.0f) < 0.05)) {
col = _Color * tex2D(_WinkTex, i.texcoord);
// col = tex2D(_WinkTex, i.texcoord);
} else {
col = _Color * tex2D(_MainTex, i.texcoord);
// col = tex2D(_MainTex, i.texcoord);
}
fixed4 cube = texCUBE(_ToonShade, i.cubenormal);
// fixed4 c = fixed4(2.0f * cube.rgb * col.rgb, col.a);
fixed4 c = fixed4(col.rgb, col.a);
UNITY_APPLY_FOG(i.fogCoord, c);
return c;
}
ENDCG 
}
}
Fallback "VertexLit"
}
