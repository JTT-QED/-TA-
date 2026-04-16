
Shader "shader test/RadialLoading" {
    Properties {
        _Color ("Color", Color) = (0,0.4,1,1)
        _Color2 ("Color2", Color) = (1,0,0,1)
        _Emission ("Emission", Float ) = 1
        _Level ("Level", Float ) = 8
        _Width ("Width", Range(0, 1)) = 0.5
        _Radius ("Radius", Range(0, 1)) = 1
        _CenterRadius ("CenterRadius", Range(0, 1)) = 0.2066802
        [MaterialToggle] _UseSin ("UseSin", Float ) = 0.3846478
        _FadeIn ("FadeIn", Range(0, 1)) = 0.3846478
        _Speed ("Speed", Float ) = 2
        _Icon ("Icon", 2D) = "white" {}
        _ScaleIcon ("ScaleIcon", Range(0, 1)) = 1
        [MaterialToggle] _UseIcon ("UseIcon", Float ) = 0
        _BG_Opacity ("BG_Opacity", Range(0, 1)) = 0
        [MaterialToggle] _UseRectangle ("UseRectangle", Float ) = 1.624514
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma target 3.0
            uniform float4 _Color;
            uniform float _Level;
            uniform float _FadeIn;
            uniform float _Emission;
            uniform float _Speed;
            uniform fixed _UseSin;
            uniform float _CenterRadius;
            uniform float _Width;
            uniform float4 _Color2;
            uniform float _Radius;
            uniform sampler2D _Icon; uniform float4 _Icon_ST;
            uniform float _ScaleIcon;
            uniform fixed _UseIcon;
            uniform float _BG_Opacity;
            uniform fixed _UseRectangle;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float node_3345 = length((i.uv0*2.0+-1.0));
                float node_5289 = (_Radius*0.95);
                float node_4204 = 0.0;
                float node_8254 = 0.0;
                float node_9949 = saturate(lerp( (node_4204 + ( (node_3345 - _CenterRadius) * (1.0 - node_4204) ) / (node_5289 - _CenterRadius)), (node_8254 + ( (saturate(max(saturate(abs((1.0 - i.uv0.r)-i.uv0.r)),saturate(abs(i.uv0.g-(1.0 - i.uv0.g))))) - _CenterRadius) * (1.0 - node_8254) ) / (node_5289 - _CenterRadius)), _UseRectangle ));
                float node_6232 = (1.0+_Level);
                float node_9052 = floor(node_9949 * node_6232) / (node_6232 - 1);
                float3 emissive = (lerp(_Color2.rgb,_Color.rgb,node_9052)*_Emission);
                float3 finalColor = emissive;
                float4 node_2863 = _Time;
                float node_9226 = sin((node_2863.g*_Speed));
                float node_440 = (node_6232*node_9949);
                float node_6901 = step(_Width,(1.0 - frac(node_440)));
                float node_4803 = (1.0 - floor(node_9949));
                float2 UV = i.uv0;
                float node_1420 = ((1.0 - _ScaleIcon)/2.0);
                float node_737 = 1.0;
                float node_9069 = 0.0;
                float2 node_360 = (node_9069 + ( (UV - node_1420) * (node_737 - node_9069) ) / ((node_737-node_1420) - node_1420));
                float4 _Icon_var = tex2D(_Icon,TRANSFORM_TEX(node_360, _Icon));
                float Fade = saturate((node_9226*-0.5+0.5));
                return fixed4(finalColor,((step((lerp( _FadeIn, saturate((node_9226*0.5555556+0.5)), _UseSin )+0.05),node_9052)*node_6901*node_4803)+lerp( 0.0, (_Icon_var.a*Fade), _UseIcon )+(_BG_Opacity*node_6901*node_4803*trunc(saturate(node_440)))));
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
