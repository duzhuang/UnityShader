//2D SDF（Signed Distance Field）指的是二维有符号距离场。SDF 是计算几何的一个技术，
//用来表示一个形状或场景中点与表面之间的最短距离，其中 "有符号" 指距离可以是正数或负数。
//正数表明点在形状的外部，负数表明点在形状的内部，而零通常指在形状的边界上。
//SDF 是定义在二维空间中每一点上的函数，常被用来快速和容易地表示复杂的形状和场景，特别是在图形学和物理模拟中。
//在二维空间中，SDF 可以描述线条、曲线、多边形等的边缘和内外部。SDF 有以下优点

// - 简化运算：使用 SDF 可以使碰撞检测、光线投射和形状合并变得简单。
// - 渲染效率：在图形渲染中，SDF 可用于快速渲染高质量的平滑边缘，特别是在文本渲染和矢量图形上。
// - 容易变形和联合：SDF 很容易实现形状变形以及不同形状之间的布尔运算（如交集、并集和差集）

Shader "Shaders/HLSL/SDF/sdf002"
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

            float4 frag(VertexOutput i): SV_Target{       
                //将0-1的uv转换到-1-1的uv
                float2 uv = i.uv;
                uv = uv * 2.0 - 1.0;                   
                float4 baseTex = SAMPLE_TEXTURE2D(_MainTex,sampler_MainTex, i.uv); 

                float radius = 0.5;                
                float dist = abs(length(uv) - radius);
                float grayColor = floor(dist * 20.0) / 20.0;
                baseTex = float4(grayColor,grayColor,grayColor, 0.0);                

                return baseTex;
            }

            ENDHLSL
        }
    }
}
