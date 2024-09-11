Shader "Shaders/GLSL/Sweep"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SweepColor ("SweepColor", Color) = (1,1,1,1)
        _SweepSpeed ("SweepSpeed", Float) = 0.2
        _SweepSize ("SweepSize", Float) = 0.1      
    }
    SubShader
    {
        Pass
        {
            GLSLPROGRAM

            #include "UnityCG.glslinc" 
            uniform sampler2D _MainTex;
            uniform vec4 _Color;
            uniform vec4 _SweepColor;
            uniform float _SweepSpeed;
            uniform float _SweepSize;

            #define time _Time.g

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
                vec4 mainColor = texture2D(_MainTex, uv);  

                if(abs(tan(time) * _SweepSpeed - (uv.x*2.0+uv.y)/2.0) < _SweepSize ) {
                    mainColor *=  _SweepColor  ;
                }  
                            
                gl_FragColor = _Color * mainColor;
            }

            #endif

            ENDGLSL
        }
    }
}
