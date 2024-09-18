Shader "Shaders/HLSL/SweepHLSL"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BaseColor ("Base Color", Color) = (1, 1, 1, 1)
        _SweepColor ("SweepColor", Color) = (1,1,1,1)
        _SweepSpeed ("SweepSpeed", Float) = 0.2
        _SweepSize ("SweepSize", Float) = 0.1   
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        HLSLINCLUDE

        //增加函数库                                     
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"  

        //时间函数
        #define time _Time.g

        CBUFFER_START(UnityPerMaterial)
            float4 _BaseColor;
            float4 _SweepColor;
            float _SweepSpeed;
            float _SweepSize;        
        CBUFFER_END

        TEXTURE2D(_MainTex);
        //添加前缀 sampler
        SAMPLER(sampler_MainTex);

        struct VertexInput{
            float4 position : POSITION;
            float2 uv : TEXCOORD0;
        };

        struct VertexOutput{
            float4 position : SV_POSITION;
            float2 uv : TEXCOORD0;
        };
            
        ENDHLSL


        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            VertexOutput vert(VertexInput input){
                VertexOutput output;
                output.position = TransformObjectToHClip(input.position.xyz);
                output.uv = input.uv;
                return output;
            }

            float4 frag(VertexOutput i): SV_Target{
                float2 uv = i.uv;
                float4 baseTex = SAMPLE_TEXTURE2D(_MainTex,sampler_MainTex, uv);
                if(abs(tan(time) * _SweepSpeed - (uv.x*2.0+uv.y)/2.0) < _SweepSize ) {
                    baseTex *=  _SweepColor;
                }  
                return baseTex * _BaseColor;
            }

            ENDHLSL
        }
    }
}
