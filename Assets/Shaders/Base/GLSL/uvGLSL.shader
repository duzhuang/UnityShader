Shader "Shaders/GLSL/uv"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}  
        _RangeH ("Range H", Float) = 0.5
        _RabgeV ("Range V", Float) = 0.5
    }
    SubShader
    {
        Pass
        {
            GLSLPROGRAM

            uniform vec4 _Color;            
            uniform sampler2D _MainTex;
            uniform float _RangeH;
            uniform float _RabgeV;

            #ifdef VERTEX           
                                         
            out vec2 v_uv0;      

            void main(){                                
                v_uv0 = gl_MultiTexCoord0.st;                
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex; 
            }      

            #endif

            #ifdef FRAGMENT           
            
            in vec2 v_uv0;          

            void main(){
                vec2 uv = v_uv0;

                vec4 mianColor = texture2D(_MainTex, v_uv0);

                if(uv.y > _RangeH){
                    mianColor.rgb *= 0.5;
                }

                if(uv.x > _RabgeV){
                    mianColor.rgb *= 0.5;
                }

                gl_FragColor = _Color * mianColor;
            }

            #endif

            ENDGLSL
        }
    }
}
