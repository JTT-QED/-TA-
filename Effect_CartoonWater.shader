// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Effect_CartoonWater"
{
	Properties
	{
		_Matcap("Matcap", 2D) = "white" {}
		_Float11("MatcapAngle", Range( 0 , 360)) = 0
		_NormalTex("NormalTex", 2D) = "bump" {}
		_Vector6("Normal平铺和速度", Vector) = (1,1,0,0)
		_NormalIntensity("NormalIntensity", Float) = 1
		_Vector5("扭曲坐标位置", Vector) = (0,0,0,0)
		_Float2("整体颜色范围", Float) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[KeywordEnum(U,V)] _Keyword0("渐变方向", Float) = 1
		_Float0("颜色范围", Float) = 1
		[HDR]_Color0("Color 0", Color) = (0.07075471,0.1664071,1,1)
		[HDR]_Color1("Color 1", Color) = (0.5330188,1,0.8791344,1)
		[HDR]_Color2("水波纹颜色", Color) = (0.9292453,0.9976015,1,1)
		_WaveTex("水波纹贴图", 2D) = "white" {}
		[Toggle]_Float15("水波纹使用极坐标", Float) = 0
		_Vector0("水波纹速度", Vector) = (1,0.1,0,0)
		[HDR]_Color3("深度颜色", Color) = (0.2862746,0.4057,1,1)
		_Float1("深度颜色平铺", Float) = 40
		[HDR]_Color4("菲尼尔颜色", Color) = (1,1,1,1)
		_Float3("菲尼尔强度", Float) = 1
		_Float4("菲尼尔范围", Float) = 5
		_NoiseTex("UV扭曲贴图Flowmap", 2D) = "white" {}
		_Vector2("UV扭曲速度", Vector) = (0,0,0,0)
		_Float5("UV扭曲强度", Range( 0 , 1)) = 0
		_VOTex("顶点动画贴图", 2D) = "white" {}
		[Toggle]_Float14("是否开启波纹", Float) = 0
		_Vector3("顶点动画速度", Vector) = (0,0,0,0)
		_Float6("顶点动画强度", Float) = 0
		_TextureSample0("顶点动画遮罩", 2D) = "white" {}
		_DissTex("溶解贴图", 2D) = "white" {}
		_Float7("溶解进度", Range( 0 , 1)) = 0
		[Toggle]_Float8("Custom控制顶点动画W", Float) = 0
		_Float9("溶解宽度", Float) = 0
		[HDR]_Color5("溶解光边颜色", Color) = (1,1,1,1)
		_Vector4("溶解贴图速度", Vector) = (0,0,0,0)
		[Toggle]_Float10("Custom控制溶解Z", Float) = 0
		_MaskTex("MaskTex", 2D) = "white" {}
		_Float12("Mask角度", Range( 0 , 360)) = 0
		_Float13("扩散频率", Float) = 0
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 4.5
		#pragma shader_feature_local _KEYWORD0_U _KEYWORD0_V
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float4 uv2_texcoord2;
			float2 uv_texcoord;
			float4 screenPos;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _VOTex;
		uniform float2 _Vector3;
		uniform float4 _VOTex_ST;
		uniform sampler2D _NoiseTex;
		uniform float2 _Vector2;
		uniform float4 _NoiseTex_ST;
		uniform float _Float5;
		uniform float _Float13;
		uniform float _Float14;
		uniform float _Float6;
		uniform float _Float8;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform sampler2D _Matcap;
		uniform sampler2D _NormalTex;
		uniform float3 _Vector5;
		uniform float4 _Vector6;
		uniform float _NormalIntensity;
		uniform float _Float11;
		uniform float4 _Color5;
		uniform float _Float7;
		uniform float _Float10;
		uniform sampler2D _DissTex;
		uniform float2 _Vector4;
		uniform float4 _DissTex_ST;
		uniform float _Float9;
		uniform float _Float3;
		uniform float _Float4;
		uniform float4 _Color4;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _Float0;
		uniform float4 _Color2;
		uniform sampler2D _WaveTex;
		uniform float2 _Vector0;
		uniform float4 _WaveTex_ST;
		uniform float _Float15;
		uniform float4 _Color3;
		uniform float _Float1;
		uniform float _Float2;
		uniform sampler2D _MaskTex;
		uniform float4 _MaskTex_ST;
		uniform float _Float12;
		uniform float _Cutoff = 0.5;


		struct Gradient
		{
			int type;
			int colorsLength;
			int alphasLength;
			float4 colors[8];
			float2 alphas[8];
		};


		Gradient NewGradient(int type, int colorsLength, int alphasLength, 
		float4 colors0, float4 colors1, float4 colors2, float4 colors3, float4 colors4, float4 colors5, float4 colors6, float4 colors7,
		float2 alphas0, float2 alphas1, float2 alphas2, float2 alphas3, float2 alphas4, float2 alphas5, float2 alphas6, float2 alphas7)
		{
			Gradient g;
			g.type = type;
			g.colorsLength = colorsLength;
			g.alphasLength = alphasLength;
			g.colors[ 0 ] = colors0;
			g.colors[ 1 ] = colors1;
			g.colors[ 2 ] = colors2;
			g.colors[ 3 ] = colors3;
			g.colors[ 4 ] = colors4;
			g.colors[ 5 ] = colors5;
			g.colors[ 6 ] = colors6;
			g.colors[ 7 ] = colors7;
			g.alphas[ 0 ] = alphas0;
			g.alphas[ 1 ] = alphas1;
			g.alphas[ 2 ] = alphas2;
			g.alphas[ 3 ] = alphas3;
			g.alphas[ 4 ] = alphas4;
			g.alphas[ 5 ] = alphas5;
			g.alphas[ 6 ] = alphas6;
			g.alphas[ 7 ] = alphas7;
			return g;
		}


		float4 SampleGradient( Gradient gradient, float time )
		{
			float3 color = gradient.colors[0].rgb;
			UNITY_UNROLL
			for (int c = 1; c < 8; c++)
			{
			float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, (float)gradient.colorsLength-1));
			color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
			}
			#ifndef UNITY_COLORSPACE_GAMMA
			color = half3(GammaToLinearSpaceExact(color.r), GammaToLinearSpaceExact(color.g), GammaToLinearSpaceExact(color.b));
			#endif
			float alpha = gradient.alphas[0].x;
			UNITY_UNROLL
			for (int a = 1; a < 8; a++)
			{
			float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, (float)gradient.alphasLength-1));
			alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
			}
			return float4(color, alpha);
		}


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 ase_vertexNormal = v.normal.xyz;
			float2 appendResult59 = (float2(_Vector3.x , _Vector3.y));
			float2 uv_VOTex = v.texcoord.xy * _VOTex_ST.xy + _VOTex_ST.zw;
			float2 VOUV61 = uv_VOTex;
			float2 appendResult46 = (float2(_Vector2.x , _Vector2.y));
			float2 uv_NoiseTex = v.texcoord.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner43 = ( 1.0 * _Time.y * appendResult46 + uv_NoiseTex);
			float2 Noise108 = (tex2Dlod( _NoiseTex, float4( panner43, 0, 0.0) )).rg;
			float Soild112 = _Float5;
			float2 lerpResult63 = lerp( VOUV61 , Noise108 , Soild112);
			float2 VONoise65 = lerpResult63;
			float2 panner57 = ( 1.0 * _Time.y * appendResult59 + VONoise65);
			float4 tex2DNode56 = tex2Dlod( _VOTex, float4( panner57, 0, 0.0) );
			Gradient gradient175 = NewGradient( 0, 3, 2, float4( 1, 1, 1, 0.6115358 ), float4( 0, 0, 0, 0.6616617 ), float4( 1, 1, 1, 0.7167925 ), 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float2 uv_TexCoord158 = v.texcoord.xy * float2( 1.5,1 );
			float temp_output_186_0 = ( ( distance( uv_TexCoord158 , float2( 0.75,0.5 ) ) + ( 1.0 - frac( ( _Time.y * _Float13 ) ) ) ) + -0.5 );
			Gradient gradient181 = NewGradient( 0, 3, 2, float4( 1, 1, 1, 0.4335851 ), float4( 0, 0, 0, 0.4812085 ), float4( 1, 1, 1, 0.5338369 ), 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float bowen187 = ( ( 1.0 - SampleGradient( gradient175, temp_output_186_0 ).r ) + ( 1.0 - SampleGradient( gradient181, temp_output_186_0 ).r ) );
			float Toggle199 = _Float14;
			float lerpResult189 = lerp( tex2DNode56.r , ( tex2DNode56.r * bowen187 ) , Toggle199);
			float4 break89 = v.texcoord1;
			float lerpResult90 = lerp( _Float6 , break89.w , _Float8);
			float2 uv_TextureSample0 = v.texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float3 VertexOffset77 = ( ase_vertex3Pos + ( ( ( ase_vertexNormal * lerpResult189 ) * lerpResult90 ) * tex2Dlod( _TextureSample0, float4( uv_TextureSample0, 0, 0.0) ).r ) );
			v.vertex.xyz = VertexOffset77;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			float3 objToWorld130 = mul( unity_ObjectToWorld, float4( _Vector5, 1 ) ).xyz;
			float2 appendResult133 = (float2(_Vector6.x , _Vector6.y));
			float2 appendResult134 = (float2(_Vector6.z , _Vector6.w));
			float cos151 = cos( _Float11 );
			float sin151 = sin( _Float11 );
			float2 rotator151 = mul( (mul( float4( (WorldNormalVector( i , UnpackScaleNormal( tex2D( _NormalTex, ( ( (( ase_worldPos - objToWorld130 )).xy * appendResult133 ) + ( appendResult134 * _Time.y ) ) ), _NormalIntensity ) )) , 0.0 ), UNITY_MATRIX_V ).xyz).xy - float2( 0.5,0.5 ) , float2x2( cos151 , -sin151 , sin151 , cos151 )) + float2( 0.5,0.5 );
			float4 Matcap148 = tex2D( _Matcap, (rotator151*0.5 + 0.5) );
			float4 break89 = i.uv2_texcoord2;
			float lerpResult124 = lerp( _Float7 , break89.z , _Float10);
			float2 appendResult122 = (float2(_Vector4.x , _Vector4.y));
			float2 uv_DissTex = i.uv_texcoord * _DissTex_ST.xy + _DissTex_ST.zw;
			float2 DissUV106 = uv_DissTex;
			float2 appendResult46 = (float2(_Vector2.x , _Vector2.y));
			float2 uv_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner43 = ( 1.0 * _Time.y * appendResult46 + uv_NoiseTex);
			float2 Noise108 = (tex2D( _NoiseTex, panner43 )).rg;
			float Soild112 = _Float5;
			float2 lerpResult107 = lerp( DissUV106 , Noise108 , Soild112);
			float2 DissNoise118 = lerpResult107;
			float2 panner120 = ( 1.0 * _Time.y * appendResult122 + DissNoise118);
			float4 tex2DNode80 = tex2D( _DissTex, panner120 );
			float temp_output_82_0 = step( lerpResult124 , tex2DNode80.r );
			float4 Edge99 = ( _Color5 * ( temp_output_82_0 - step( ( lerpResult124 + _Float9 ) , tex2DNode80.r ) ) );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV36 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode36 = ( 0.0 + _Float3 * pow( 1.0 - fresnelNdotV36, _Float4 ) );
			#if defined(_KEYWORD0_U)
				float staticSwitch2 = pow( i.uv_texcoord.x , _Float0 );
			#elif defined(_KEYWORD0_V)
				float staticSwitch2 = pow( i.uv_texcoord.y , _Float0 );
			#else
				float staticSwitch2 = pow( i.uv_texcoord.y , _Float0 );
			#endif
			float4 lerpResult6 = lerp( _Color0 , _Color1 , staticSwitch2);
			float2 appendResult13 = (float2(_Vector0.x , _Vector0.y));
			float2 uv_WaveTex = i.uv_texcoord * _WaveTex_ST.xy + _WaveTex_ST.zw;
			float2 WaveUV49 = uv_WaveTex;
			float2 lerpResult47 = lerp( WaveUV49 , Noise108 , Soild112);
			float2 WaveUVNoise53 = lerpResult47;
			float2 CenteredUV15_g1 = ( WaveUVNoise53 - float2( 0.5,0.5 ) );
			float2 break17_g1 = CenteredUV15_g1;
			float2 appendResult23_g1 = (float2(( length( CenteredUV15_g1 ) * 0.65 * 2.0 ) , ( atan2( break17_g1.x , break17_g1.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float2 lerpResult212 = lerp( WaveUVNoise53 , appendResult23_g1 , _Float15);
			float2 panner10 = ( 1.0 * _Time.y * appendResult13 + lerpResult212);
			float4 tex2DNode9 = tex2D( _WaveTex, panner10 );
			Gradient gradient175 = NewGradient( 0, 3, 2, float4( 1, 1, 1, 0.6115358 ), float4( 0, 0, 0, 0.6616617 ), float4( 1, 1, 1, 0.7167925 ), 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float2 uv_TexCoord158 = i.uv_texcoord * float2( 1.5,1 );
			float temp_output_186_0 = ( ( distance( uv_TexCoord158 , float2( 0.75,0.5 ) ) + ( 1.0 - frac( ( _Time.y * _Float13 ) ) ) ) + -0.5 );
			Gradient gradient181 = NewGradient( 0, 3, 2, float4( 1, 1, 1, 0.4335851 ), float4( 0, 0, 0, 0.4812085 ), float4( 1, 1, 1, 0.5338369 ), 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float bowen187 = ( ( 1.0 - SampleGradient( gradient175, temp_output_186_0 ).r ) + ( 1.0 - SampleGradient( gradient181, temp_output_186_0 ).r ) );
			float Toggle199 = _Float14;
			float lerpResult198 = lerp( tex2DNode9.r , ( ( ( bowen187 * tex2DNode9.r ) / 0.5 ) + tex2DNode9.r ) , Toggle199);
			float4 lerpResult18 = lerp( lerpResult6 , _Color2 , lerpResult198);
			float3 objToView29 = mul( UNITY_MATRIX_MV, float4( float3(0,0,0), 1 ) ).xyz;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float simpleNoise15 = SimpleNoise( ( objToView29 - float3( (ase_screenPosNorm).xy ,  0.0 ) ).xy*_Float1 );
			float4 lerpResult20 = lerp( _Color3 , float4( 1,1,1,1 ) , simpleNoise15);
			float4 temp_cast_4 = (_Float2).xxxx;
			float4 Main86 = ( ( fresnelNode36 * _Color4 ) + pow( ( lerpResult18 * lerpResult20 ) , temp_cast_4 ) );
			o.Emission = ( ( Matcap148 * ( Edge99 + Main86 ) ) * i.vertexColor ).rgb;
			float2 uv_MaskTex = i.uv_texcoord * _MaskTex_ST.xy + _MaskTex_ST.zw;
			float cos154 = cos( radians( _Float12 ) );
			float sin154 = sin( radians( _Float12 ) );
			float2 rotator154 = mul( uv_MaskTex - float2( 0.5,0.5 ) , float2x2( cos154 , -sin154 , sin154 , cos154 )) + float2( 0.5,0.5 );
			o.Alpha = ( i.vertexColor.a * tex2D( _MaskTex, rotator154 ).r );
			float Alpha101 = temp_output_82_0;
			clip( Alpha101 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
709;109;1360;849;1154.06;1339.106;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;116;-2330.096,-161.9931;Inherit;False;1427.805;619.996;Comment;9;45;44;46;43;42;55;108;48;112;UV扭曲;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;45;-2280.096,42.00659;Inherit;False;Property;_Vector2;UV扭曲速度;22;0;Create;False;0;0;0;False;0;False;0,0;0.1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-2173.096,-111.9931;Inherit;False;0;42;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;46;-2096.096,90.00655;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;185;-2956.191,1418.788;Inherit;False;2233.999;838.1923;Comment;17;181;182;165;174;170;175;176;169;166;167;158;159;180;168;179;186;187;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;43;-1866.096,-8.993381;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;42;-1704.668,-53.71568;Inherit;True;Property;_NoiseTex;UV扭曲贴图Flowmap;21;0;Create;False;0;0;0;False;0;False;-1;None;3f61f1fb8666d704e8657f7b5ffb3bd2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;33;-862.5697,-1234.078;Inherit;False;2570.274;1497.35;Comment;40;212;12;13;10;208;86;37;34;38;39;22;35;36;40;20;18;41;19;15;21;6;201;16;28;2;7;8;4;3;27;29;30;5;1;25;9;49;11;52;213;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;165;-2933.191,1811.98;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;167;-2934.191,1891.98;Inherit;False;Property;_Float13;扩散频率;38;0;Create;False;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;166;-2757.191,1853.98;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-1985.358,331.1521;Inherit;False;Property;_Float5;UV扭曲强度;23;0;Create;False;0;0;0;False;0;False;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;55;-1412.02,-5.995697;Inherit;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-796.2336,-555.474;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-584.7547,-552.284;Inherit;False;WaveUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;123;-1707.263,-1221.485;Inherit;False;808.3141;1029.597;Comment;15;109;51;114;47;62;115;110;105;111;113;107;63;53;118;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-1126.289,-79.8056;Inherit;False;Noise;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;158;-2848.08,1464.788;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.5,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;168;-2610.192,1764.98;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;-1638.531,342.0025;Inherit;False;Soild;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;-1614.285,-980.843;Inherit;False;112;Soild;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;169;-2448.192,1758.98;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-1613.901,-1061.959;Inherit;False;108;Noise;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DistanceOpNode;159;-2562.327,1479.958;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.75,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-1622.14,-1171.485;Inherit;False;49;WaveUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;170;-2234.192,1624.98;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;47;-1415.482,-1105.951;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GradientNode;175;-2092.192,1529.98;Inherit;False;0;3;2;1,1,1,0.6115358;0,0,0,0.6616617;1,1,1,0.7167925;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-1196.052,-960.4933;Inherit;False;WaveUVNoise;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;186;-2001.788,1825.971;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;181;-2077.192,2017.98;Inherit;False;0;3;2;1,1,1,0.4335851;0,0,0,0.4812085;1,1,1,0.5338369;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.GradientSampleNode;180;-1792.193,2000.98;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientSampleNode;174;-1824.193,1693.98;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;127;1704.741,-1228.451;Inherit;False;3008.185;742.2819;Comment;23;148;147;146;145;144;143;142;141;140;139;138;137;136;135;134;133;132;131;130;129;128;151;152;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;-843.6176,-934.4819;Inherit;False;53;WaveUVNoise;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;176;-1444.193,1684.98;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;79;-661.0856,1429.607;Inherit;False;2496.02;845.7338;Comment;24;60;61;58;59;66;57;68;56;69;70;73;72;75;74;77;71;90;91;188;190;189;191;199;200;顶点动画;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;182;-1390.193,1954.98;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;103;-639.3273,270.1717;Inherit;False;2233.058;1055.915;Comment;20;125;126;101;99;96;97;95;82;92;80;93;94;120;124;83;119;122;121;106;104;溶解;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;213;-546.0269,-954.0503;Inherit;False;Property;_Float15;水波纹使用极坐标;14;1;[Toggle];Create;False;0;0;0;True;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;128;1847.794,-1012.997;Inherit;False;Property;_Vector5;扭曲坐标位置;5;0;Create;False;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;208;-815.0755,-1190.354;Inherit;True;Polar Coordinates;-1;;1;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;0.65;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;12;-838.5864,-839.563;Inherit;False;Property;_Vector0;水波纹速度;15;0;Create;False;0;0;0;False;0;False;1,0.1;-0.5,-0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TransformPositionNode;130;2068.663,-994.6386;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;13;-633.3467,-859.1086;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;212;-446.151,-1118.315;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;179;-1155.193,1769.98;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;129;2085.709,-1142.197;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;104;-588.1107,323.8942;Inherit;False;0;80;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-611.0856,1479.607;Inherit;False;0;56;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;10;-458.9522,-878.918;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-320.3235,1496.986;Inherit;False;VOUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-231.3583,343.0045;Inherit;False;DissUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;132;2322.238,-994.3755;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;187;-936.4014,1761.669;Inherit;False;bowen;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;131;2143.246,-836.6801;Inherit;False;Property;_Vector6;Normal平铺和速度;3;0;Create;False;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;136;2407.102,-606.3354;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-220.6113,-1126.806;Inherit;True;Property;_WaveTex;水波纹贴图;13;0;Create;False;0;0;0;False;0;False;-1;e6fc5761ebe8a7a41ae8e620734658be;e6fc5761ebe8a7a41ae8e620734658be;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;105;-1556.824,-510.9011;Inherit;False;106;DissUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-1564.537,-426.5901;Inherit;False;108;Noise;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-1657.263,-649.4105;Inherit;False;112;Soild;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;133;2493.436,-874.4777;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-1586.836,-337.3902;Inherit;False;112;Soild;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;196;-436.489,-1616.195;Inherit;False;187;bowen;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;135;2483.088,-989.2866;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;134;2490.673,-782.716;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-1603.347,-817.5681;Inherit;False;61;VOUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-1594.077,-744.8046;Inherit;False;108;Noise;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;2674.856,-684.2277;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;107;-1342.774,-434.0225;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;197;-256.6923,-1617.975;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;25;-370.3882,-60.33759;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;191;229.0411,2186.315;Inherit;False;Property;_Float14;是否开启波纹;25;1;[Toggle];Create;False;0;0;0;True;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-756.7698,-238.6275;Inherit;False;Property;_Float0;颜色范围;9;0;Create;False;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-804.7698,-389.6273;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;2654.167,-920.3386;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;30;-363.9872,-241.9482;Inherit;False;Constant;_Vector1;Vector 1;9;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;63;-1336.326,-722.8992;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;139;3095.825,-753.1559;Inherit;False;Property;_NormalIntensity;NormalIntensity;4;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;-1125.349,-449.8882;Inherit;True;DissNoise;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TransformPositionNode;29;-176.9877,-242.9482;Inherit;False;Object;View;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;88;-1066.037,1199.321;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;58;-282.9592,1616.005;Inherit;False;Property;_Vector3;顶点动画速度;26;0;Create;False;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;140;3097.222,-889.5927;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;27;-79.98773,-19.94809;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;121;-563.7397,766.7089;Inherit;False;Property;_Vector4;溶解贴图速度;34;0;Create;False;0;0;0;False;0;False;0,0;0.2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PowerNode;4;-483.7693,-274.6275;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;3;-501.7695,-379.6274;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;202;-9.782959,-1621.376;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;199;412.3347,2186.95;Inherit;False;Toggle;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-1178.455,-722.4249;Inherit;False;VONoise;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;89;-819.9234,1196.183;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;66;-74.99474,1608.227;Inherit;False;65;VONoise;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;-591.4788,609.2069;Inherit;False;118;DissNoise;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;203;201.5963,-1385.137;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-478.7152,951.7059;Inherit;False;Property;_Float7;溶解进度;30;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;28;184.0122,-121.948;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;16;48.0634,157.8797;Inherit;False;Property;_Float1;深度颜色平铺;17;0;Create;False;0;0;0;False;0;False;40;40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;201;96.21704,-1088.376;Inherit;False;199;Toggle;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;141;3318.906,-916.4917;Inherit;True;Property;_NormalTex;NormalTex;2;0;Create;True;0;0;0;False;0;False;-1;ef7534639cc4a5a44a4bb1f441306a54;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;125;-357.7002,1218.643;Inherit;False;Property;_Float10;Custom控制溶解Z;35;1;[Toggle];Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;59;-80.54887,1703.369;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;7;-225.5696,-892.2272;Inherit;False;Property;_Color0;Color 0;10;1;[HDR];Create;True;0;0;0;False;0;False;0.07075471,0.1664071,1,1;0,0.1513855,0.754717,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;122;-363.7402,823.7089;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;8;-231.5696,-675.2274;Inherit;False;Property;_Color1;Color 1;11;1;[HDR];Create;True;0;0;0;False;0;False;0.5330188,1,0.8791344,1;0,0.7490196,0.5564947,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;2;-330.5692,-478.2274;Inherit;True;Property;_Keyword0;渐变方向;8;0;Create;False;0;0;0;False;0;False;0;1;1;True;;KeywordEnum;2;U;V;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;57;119.7929,1622.699;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;198;439.2023,-1435.676;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;163.148,1082.62;Inherit;False;Property;_Float9;溶解宽度;32;0;Create;False;0;0;0;False;0;False;0;0.005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;6;76.43024,-684.2274;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;120;-240.5292,648.2439;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewMatrixNode;142;3674.102,-913.5547;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.ColorNode;19;78.03925,-905.6046;Inherit;False;Property;_Color2;水波纹颜色;12;1;[HDR];Create;False;0;0;0;False;0;False;0.9292453,0.9976015,1,1;1.537736,1.985372,2,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;124;-128.987,1005.293;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;15;331.8048,-113.3913;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;200.7274,-462.6966;Inherit;False;Property;_Color3;深度颜色;16;1;[HDR];Create;False;0;0;0;False;0;False;0.2862746,0.4057,1,1;0.06755074,0.06755074,0.6226415,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;143;3654.95,-1137.174;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;56;330.5102,1626.859;Inherit;True;Property;_VOTex;顶点动画贴图;24;0;Create;False;0;0;0;False;0;False;-1;cd2f829a66b72914d9ffc160b9dae113;cd2f829a66b72914d9ffc160b9dae113;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;3823.202,-930.1547;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;93;326.148,937.618;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;188;360.7408,1834.218;Inherit;False;187;bowen;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;388.6614,-811.9142;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;41;410.6734,-1050.172;Inherit;False;Property;_Float4;菲尼尔范围;20;0;Create;False;0;0;0;False;0;False;5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;80;-33.03594,648.1039;Inherit;True;Property;_DissTex;溶解贴图;29;0;Create;False;0;0;0;False;0;False;-1;None;416b86b856786a246bdd720e7928ef1c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;20;613.3511,-346.2791;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;40;369.6734,-1116.172;Inherit;False;Property;_Float3;菲尼尔强度;19;0;Create;False;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;794.1352,-749.1078;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;82;494.8388,660.3889;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;92;541.1482,936.618;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;756.1998,-932.8264;Inherit;False;Property;_Color4;菲尼尔颜色;18;1;[HDR];Create;False;0;0;0;False;0;False;1,1,1,1;0.4386792,0.5567722,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;859.6028,-484.3106;Inherit;False;Property;_Float2;整体颜色范围;6;0;Create;False;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;200;452.3347,2027.95;Inherit;False;199;Toggle;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;145;3969.803,-967.1545;Inherit;False;FLOAT2;0;1;0;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;152;3592.875,-652.101;Inherit;False;Property;_Float11;MatcapAngle;1;0;Create;False;0;0;0;False;0;False;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;665.341,1746.714;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;36;621.9968,-1161.413;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-200.6024,1906.252;Inherit;False;Property;_Float6;顶点动画强度;27;0;Create;False;0;0;0;False;0;False;0;0.93;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;97;748.1482,427.6181;Inherit;False;Property;_Color5;溶解光边颜色;33;1;[HDR];Create;False;0;0;0;False;0;False;1,1,1,1;0.73379,1.247339,1.414214,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;95;855.1482,817.6179;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-253.0277,1983.785;Inherit;False;Property;_Float8;Custom控制顶点动画W;31;1;[Toggle];Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;151;3914.875,-771.1009;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalVertexDataNode;68;440.0499,1476.185;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;34;1043.213,-614.5789;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;1092.023,-1045.699;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;189;735.5409,1899.615;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;90;17.75288,1912.452;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;1134.149,720.6179;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;767.15,1527.209;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;160;2020.738,-427.0437;Inherit;False;1548.206;874.1104;Comment;15;87;78;102;150;153;154;100;149;155;157;85;98;156;204;206;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;1369.857,-936.928;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;146;4142.304,-995.5546;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;1482.788,-748.7272;Inherit;False;Main;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;156;2054.701,141.8337;Inherit;False;Property;_Float12;Mask角度;37;0;Create;False;0;0;0;False;0;False;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;73;850.8451,2044.039;Inherit;True;Property;_TextureSample0;顶点动画遮罩;28;0;Create;False;0;0;0;False;0;False;-1;None;80c25592e1e7fd6458d917cacdc601e1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;1394.917,751.2539;Inherit;False;Edge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;950.874,1802.954;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;147;4359.125,-1107.469;Inherit;True;Property;_Matcap;Matcap;0;0;Create;True;0;0;0;False;0;False;-1;f589b65c9a720074ea4cdcf101002779;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;1127.907,1894.462;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;148;4486.607,-845.3201;Inherit;False;Matcap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;75;1073.356,1603.74;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RadiansOpNode;157;2331.7,135.8337;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;155;2112.7,22.83368;Inherit;False;0;153;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;98;2448.219,-345.2178;Inherit;False;99;Edge;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;2445.231,-275.8615;Inherit;False;86;Main;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RotatorNode;154;2462.7,41.83368;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;100;2650.669,-303.2584;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;2638.084,-377.0437;Inherit;False;148;Matcap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;1379.807,1794.752;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;204;2686.39,-188.3712;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;2828.595,-304.318;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;153;2665.85,5.319378;Inherit;True;Property;_MaskTex;MaskTex;36;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;830.754,644.1399;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;1608.534,1661.771;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;2756.201,191.9747;Inherit;False;101;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;2992.576,-165.4407;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;126;315.5005,442.989;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;206;3139.576,-95.44073;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;2742.595,288.3006;Inherit;False;77;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;87;3295.092,-235.7843;Float;False;True;-1;5;ASEMaterialInspector;0;0;Unlit;Effect_CartoonWater;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;AlphaTest;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;7;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;46;0;45;1
WireConnection;46;1;45;2
WireConnection;43;0;44;0
WireConnection;43;2;46;0
WireConnection;42;1;43;0
WireConnection;166;0;165;0
WireConnection;166;1;167;0
WireConnection;55;0;42;0
WireConnection;49;0;11;0
WireConnection;108;0;55;0
WireConnection;168;0;166;0
WireConnection;112;0;48;0
WireConnection;169;0;168;0
WireConnection;159;0;158;0
WireConnection;170;0;159;0
WireConnection;170;1;169;0
WireConnection;47;0;51;0
WireConnection;47;1;109;0
WireConnection;47;2;114;0
WireConnection;53;0;47;0
WireConnection;186;0;170;0
WireConnection;180;0;181;0
WireConnection;180;1;186;0
WireConnection;174;0;175;0
WireConnection;174;1;186;0
WireConnection;176;0;174;1
WireConnection;182;0;180;1
WireConnection;208;1;52;0
WireConnection;130;0;128;0
WireConnection;13;0;12;1
WireConnection;13;1;12;2
WireConnection;212;0;52;0
WireConnection;212;1;208;0
WireConnection;212;2;213;0
WireConnection;179;0;176;0
WireConnection;179;1;182;0
WireConnection;10;0;212;0
WireConnection;10;2;13;0
WireConnection;61;0;60;0
WireConnection;106;0;104;0
WireConnection;132;0;129;0
WireConnection;132;1;130;0
WireConnection;187;0;179;0
WireConnection;9;1;10;0
WireConnection;133;0;131;1
WireConnection;133;1;131;2
WireConnection;135;0;132;0
WireConnection;134;0;131;3
WireConnection;134;1;131;4
WireConnection;137;0;134;0
WireConnection;137;1;136;0
WireConnection;107;0;105;0
WireConnection;107;1;111;0
WireConnection;107;2;113;0
WireConnection;197;0;196;0
WireConnection;197;1;9;1
WireConnection;138;0;135;0
WireConnection;138;1;133;0
WireConnection;63;0;62;0
WireConnection;63;1;110;0
WireConnection;63;2;115;0
WireConnection;118;0;107;0
WireConnection;29;0;30;0
WireConnection;140;0;138;0
WireConnection;140;1;137;0
WireConnection;27;0;25;0
WireConnection;4;0;1;2
WireConnection;4;1;5;0
WireConnection;3;0;1;1
WireConnection;3;1;5;0
WireConnection;202;0;197;0
WireConnection;199;0;191;0
WireConnection;65;0;63;0
WireConnection;89;0;88;0
WireConnection;203;0;202;0
WireConnection;203;1;9;1
WireConnection;28;0;29;0
WireConnection;28;1;27;0
WireConnection;141;1;140;0
WireConnection;141;5;139;0
WireConnection;59;0;58;1
WireConnection;59;1;58;2
WireConnection;122;0;121;1
WireConnection;122;1;121;2
WireConnection;2;1;3;0
WireConnection;2;0;4;0
WireConnection;57;0;66;0
WireConnection;57;2;59;0
WireConnection;198;0;9;1
WireConnection;198;1;203;0
WireConnection;198;2;201;0
WireConnection;6;0;7;0
WireConnection;6;1;8;0
WireConnection;6;2;2;0
WireConnection;120;0;119;0
WireConnection;120;2;122;0
WireConnection;124;0;83;0
WireConnection;124;1;89;2
WireConnection;124;2;125;0
WireConnection;15;0;28;0
WireConnection;15;1;16;0
WireConnection;143;0;141;0
WireConnection;56;1;57;0
WireConnection;144;0;143;0
WireConnection;144;1;142;0
WireConnection;93;0;124;0
WireConnection;93;1;94;0
WireConnection;18;0;6;0
WireConnection;18;1;19;0
WireConnection;18;2;198;0
WireConnection;80;1;120;0
WireConnection;20;0;21;0
WireConnection;20;2;15;0
WireConnection;22;0;18;0
WireConnection;22;1;20;0
WireConnection;82;0;124;0
WireConnection;82;1;80;1
WireConnection;92;0;93;0
WireConnection;92;1;80;1
WireConnection;145;0;144;0
WireConnection;190;0;56;1
WireConnection;190;1;188;0
WireConnection;36;2;40;0
WireConnection;36;3;41;0
WireConnection;95;0;82;0
WireConnection;95;1;92;0
WireConnection;151;0;145;0
WireConnection;151;2;152;0
WireConnection;34;0;22;0
WireConnection;34;1;35;0
WireConnection;38;0;36;0
WireConnection;38;1;39;0
WireConnection;189;0;56;1
WireConnection;189;1;190;0
WireConnection;189;2;200;0
WireConnection;90;0;71;0
WireConnection;90;1;89;3
WireConnection;90;2;91;0
WireConnection;96;0;97;0
WireConnection;96;1;95;0
WireConnection;69;0;68;0
WireConnection;69;1;189;0
WireConnection;37;0;38;0
WireConnection;37;1;34;0
WireConnection;146;0;151;0
WireConnection;86;0;37;0
WireConnection;99;0;96;0
WireConnection;70;0;69;0
WireConnection;70;1;90;0
WireConnection;147;1;146;0
WireConnection;72;0;70;0
WireConnection;72;1;73;1
WireConnection;148;0;147;0
WireConnection;157;0;156;0
WireConnection;154;0;155;0
WireConnection;154;2;157;0
WireConnection;100;0;98;0
WireConnection;100;1;85;0
WireConnection;74;0;75;0
WireConnection;74;1;72;0
WireConnection;150;0;149;0
WireConnection;150;1;100;0
WireConnection;153;1;154;0
WireConnection;101;0;82;0
WireConnection;77;0;74;0
WireConnection;205;0;150;0
WireConnection;205;1;204;0
WireConnection;206;0;204;4
WireConnection;206;1;153;1
WireConnection;87;2;205;0
WireConnection;87;9;206;0
WireConnection;87;10;102;0
WireConnection;87;11;78;0
ASEEND*/
//CHKSM=7F0DCB41B5DD0D5AF5A4FF1214871837781C84AA