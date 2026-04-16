
Shader "shader test/OpenSurface" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _Color ("Color", Color) = (0.07843138,0.3921569,0.7843137,1)
        _Emission ("Emission", Float ) = 1
        _Open ("Open", Range(0, 1)) = 0
        _G_Opacity ("G_Opacity", Float ) = 0.5
        _Scanline_Density ("Scanline_Density", Float ) = 16
        _ScanlineSpeed ("ScanlineSpeed", Float ) = 1
        _ScanlineContrast ("ScanlineContrast", Range(0, 1)) = 0.5
        _ShinnyAmplitude ("ShinnyAmplitude", Range(0, 1)) = 0
        _B_ShakeStrength ("B_ShakeStrength", Range(0, 1)) = 0
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
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles metal 
            #pragma target 3.0
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _Open;
            uniform float _Emission;
            uniform float _G_Opacity;
            uniform float _Scanline_Density;
            uniform float _ScanlineSpeed;
            uniform float _ScanlineContrast;
            uniform float _ShinnyAmplitude;
            uniform float _B_ShakeStrength;
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
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float3 emissive = (_Color.rgb*_Emission);
                float3 finalColor = emissive;
                float node_512 = (_Open/2.0);
                float2 node_268 = float2((i.uv0.r-node_512),i.uv0.g);
                float4 node_4003 = tex2D(_MainTex,TRANSFORM_TEX(node_268, _MainTex));
                float node_4559 = round(i.uv0.r);
                float2 node_55 = float2(((1.0 - i.uv0.r)-node_512),i.uv0.g);
                float4 node_1503 = tex2D(_MainTex,TRANSFORM_TEX(node_55, _MainTex));
                float3 node_7004 = ((node_4003.rgb*(1.0 - node_4559))+(node_1503.rgb*node_4559));
                float node_8242 = node_7004.g;
                float node_1935 = (i.uv0.g*_Scanline_Density);
                float4 node_6394 = _Time;
                float node_4381 = (node_6394.g*_ScanlineSpeed);
                float node_8762 = (node_6394.r*0.01);
                float2 node_9929 = float2(node_8762,node_8762);
                float2 node_1386_skew = node_9929 + 0.2127+node_9929.x*0.3713*node_9929.y;
                float2 node_1386_rnd = 4.789*sin(489.123*(node_1386_skew));
                float node_1386 = frac(node_1386_rnd.x*node_1386_rnd.y*(1+node_1386_skew.x));
                float node_2330 = (node_1386*0.05*_B_ShakeStrength);
                float2 node_8412 = ((node_2330-(node_2330/2.0))+i.uv0);
                float4 node_3159 = tex2D(_MainTex,TRANSFORM_TEX(node_8412, _MainTex));
                float4 node_7298 = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float Shinny = saturate((node_1386+(1.0 - _ShinnyAmplitude)));
                float2 node_3094 = float2(node_6394.r,node_6394.g);
                float2 node_8534_skew = node_3094 + 0.2127+node_3094.x*0.3713*node_3094.y;
                float2 node_8534_rnd = 4.789*sin(489.123*(node_8534_skew));
                float node_8534 = frac(node_8534_rnd.x*node_8534_rnd.y*(1+node_8534_skew.x));
                float InitiateGlitch = saturate(step(0.95,((1.0 - _Open)+node_8534)));
                return fixed4(finalColor,(saturate((node_7004.r+(node_8242*_G_Opacity*saturate((step(0.1,(frac((node_1935+node_4381))*2.0+-1.0))+_ScanlineContrast+node_3159.b))*(1.0 - node_3159.b))+(node_7298.a*node_8242)+(node_8242*node_3159.b)))*Shinny*InitiateGlitch));
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
