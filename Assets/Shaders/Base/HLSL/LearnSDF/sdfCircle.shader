Shader "Shaders/HLSL/SDF/sdfCircle"
{
    Properties
    {
        [HideInInSpector]_MainTex ("Base (RGB)", 2D) = "white" {} 
        _Albedo ("Albedo", Color) = (1,1,1,1)  
        _Radius ("Radius", Float) = 0.5        
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
            float _Radius;            
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

            float sdfCircle(float2 uv){    
                 // 弧度的取值范围是 0~2PI
                // cos 的取值范围是 -1~1                            
                float r = _Radius + 0.1 * cos( atan2(uv.x,uv.y)*5);
                return r;
            }

            float sdfCircleRotate(float2 uv){
                //旋转起来
                float r = _Radius + 0.1 * cos( atan2(uv.x,uv.y)*5 + time);
                return r;
            }
           
            float4 frag(VertexOutput i): SV_Target{       
                //将0-1的uv转换到-1-1的uv
                float2 uv = i.uv;
                uv = uv * 2 - 1;  
                                             
                float4 baseTex = SAMPLE_TEXTURE2D(_MainTex,sampler_MainTex, i.uv); 

                float q = length(uv - float2(0,0));                               

                float r = sdfCircleRotate(uv);
                            
                _Albedo.rgb = smoothstep(r,r+0.01,q);
                               
                return float4(_Albedo.rgb,1.0);
            }

            ENDHLSL
        }
    }
}
