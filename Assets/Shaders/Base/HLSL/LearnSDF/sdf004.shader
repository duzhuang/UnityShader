Shader "Shaders/HLSL/SDF/sdf004"
{
    Properties
    {
        [HideInInSpector]_MainTex ("Base (RGB)", 2D) = "white" {} 
        _Albedo ("Albedo", Color) = (1,1,1,1)      
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
                    return length(dxy);
                } else {
                    return max(dxy.x, dxy.y);
                }
            }

            float4 frag(VertexOutput i): SV_Target{       
                //将0-1的uv转换到-1-1的uv
                float2 uv = i.uv;
                uv = uv * 2 - 1;  
                                             
                float4 baseTex = SAMPLE_TEXTURE2D(_MainTex,sampler_MainTex, i.uv); 
                
                float2 wh = float2(0.6,0.3);

                float dist =  sdf_rectangle1(uv, wh);

                float grayColor = sin(dist * 100.0 - time*2.0) ;
                baseTex = float4(grayColor,grayColor,grayColor, 0.0);   
               
                return baseTex;
            }

            ENDHLSL
        }
    }
}
