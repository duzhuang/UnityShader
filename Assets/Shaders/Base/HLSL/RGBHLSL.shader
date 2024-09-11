Shader "Shaders/HLSL/RGBHLSL"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)        
    }
    SubShader
    {        
        Pass
        {
            //使用HLSL语言 
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag  
            // 增加函数库                                     
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"         

            CBUFFER_START(UnityPerModel)
                half4 _Color;
            CBUFFER_END

            struct appdata
            {
                 float4 positionOS : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;               
            };
           
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.positionOS.xyz);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
               return _Color;
            }

            ENDHLSL
        }   
    }    
}
