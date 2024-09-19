Shader "Shaders/HLSL/SDF/sdf005"
{
    Properties
    {
        [HideInInSpector]_MainTex ("Base (RGB)", 2D) = "white" {} 
        _Albedo ("Albedo", Color) = (1,1,1,1)   
        _Speed ("Speed", Float) = 2.0
        _Density ("Density",Float) = 50.0
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
            float4 _Albedo;   
            float _Speed;
            float _Density;  
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

            float sdf_rectangle1(float2 uv, float2 wh){
                float2 dxy = abs(uv) - wh;
                if (dxy.x > 0. && dxy.y >0.) {
                    return length(dxy) - 0.1;
                } else {
                    return max(dxy.x, dxy.y) - 0.1;
                }
            }

            float4 frag(VertexOutput i): SV_Target{       
                //将0-1的uv转换到-1-1的uv
                float2 uv = i.uv;
                uv = uv * 2 - 1;  
                                             
                float4 baseTex = SAMPLE_TEXTURE2D(_MainTex,sampler_MainTex, i.uv); 
                
                float2 wh = float2(0.9,0.9);

                float dist = sdf_rectangle1(uv, wh);

                if(dist > 0.0){
                    discard;
                }
               
                return baseTex;
            }

            ENDHLSL
        }
    }
}
