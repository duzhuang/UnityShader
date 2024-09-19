Shader "Shaders/HLSL/SDF/sdfBox"
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
            float sdBox0(float2 p,float2 wh){
                float2 halfWh = wh * 0.5;
                return length(max(abs(p) - halfWh,0.0));
            }

            float sdBox1(float2 p,float2 wh){
                float2 halfWh = wh * 0.5;   
                float2 d = abs(p) - halfWh;                
                return length(max(d,0.0)) + min(max(d.x,d.y),0.0);                
            }
           
            float4 frag(VertexOutput i): SV_Target{       
                //将0-1的uv转换到-1-1的uv
                float2 uv = i.uv;
                uv = uv * 2 - 1;  
                                             
                float4 baseTex = SAMPLE_TEXTURE2D(_MainTex,sampler_MainTex, i.uv); 

                float d = sdBox1(uv,float2(0.5,0.5));

                float3 col = (d>0.0) ? float3(0.9,0.6,0.3) : float3(0.65,0.85,1.0);
                col *= 1.0 - exp(-6.0*abs(d));
                col *= 0.8 + 0.2*cos(150.0*d);
                col = lerp( col, float3(1.0,1.0,1.0), 1.0-smoothstep(0.0,0.01,abs(d)) );             
                               
                return float4(col,1.0);
            }

            ENDHLSL
        }
    }
}
