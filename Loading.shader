
Shader "shader test/Loading" {
    Properties {
        _Color ("Color", Color) = (0,0.4568243,1,1)
        _Color2 ("Color2", Color) = (1,0,0,1)
        _Amount ("Amount", Float ) = 8
        _Gap ("Gap", Float ) = 0.7
        _Percentage ("Percentage", Range(0, 1)) = 1
        [MaterialToggle] _UseTime ("UseTime", Float ) = 1
        _Speed ("Speed", Float ) = 2
        [MaterialToggle] _UseSin ("UseSin", Float ) = 0.5
        _Width ("Width", Range(0, 1)) = 1
        _Emission ("Emission", Float ) = 1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma target 3.0
            uniform float4 _Color;
            uniform float _Amount;
            uniform float _Gap;
            uniform float _Percentage;
            uniform fixed _UseTime;
            uniform float _Speed;
            uniform fixed _UseSin;
            uniform float _Width;
            uniform float4 _Color2;
            uniform float _Emission;
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
                float4 node_304 = _Time;
                float node_9041 = (node_304.g*_Speed);
                float node_8630 = floor(abs(_Amount));
                float node_440 = floor((1.0 - i.uv0.g) * node_8630) / (node_8630 - 1);
                clip((saturate(step(0.5,((lerp( lerp( _Percentage, frac(node_9041), _UseTime ), saturate(((sin(node_9041)+1.0)/2.0)), _UseSin )*1.1+-0.55)+node_440)))*saturate((1.0 - step(_Gap,frac((i.uv0.g*node_8630)))))*saturate(step((1.0 - _Width),(1.0 - abs((i.uv0.r*2.0+-1.0)))))) - 0.5);
////// Lighting:
////// Emissive:
                float3 emissive = (lerp(_Color2.rgb,_Color.rgb,node_440)*_Emission);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
