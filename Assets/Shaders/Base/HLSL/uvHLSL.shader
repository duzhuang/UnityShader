Shader "Shaders/HLSL/uvHLSL"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}       
    }
    SubShader
    {
        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag  

            // 增加函数库                                     
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"     

            CBUFFER_START(UnityPerModel)
                half4 _Color;   
                float4 _MainTex_ST;
            CBUFFER_END

            struct appdata{
                float4 positionOS : POSITION;
                float2 texcoord : TEXCOORD0;
            };      

            struct v2f{
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            TEXTURE2D_X (_MainTex);
            SAMPLER(sampler_MainTex);

            v2f vert(appdata v){
                v2f o;
                o.vertex = TransformObjectToHClip(v.positionOS.xyz);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            half4 frag(v2f i) : SV_Target{
                half4 col = SAMPLE_TEXTURE2D(_MainTex,sampler_MainTex,i.uv);
                col *= _Color;
                return col;
            }

            ENDHLSL
        }
    }
}
