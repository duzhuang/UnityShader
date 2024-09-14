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
            //使用GLSL
            GLSLPROGRAM

            //引入核心库
            #include "UnityCG.glslinc" 

            //关联shader lab 的自定义属性
            uniform sampler2D _MainTex;
            uniform vec4 _Color;
            uniform vec4 _SweepColor;
            uniform float _SweepSpeed;
            uniform float _SweepSize;
            
            //时间函数
            #define time _Time.g

            #ifdef VERTEX

            out vec2 v_uv0;
            void main(){
                //uv坐标
                v_uv0 = gl_MultiTexCoord0.st;     
                //顶点位置   
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
            }

            #endif

            #ifdef FRAGMENT                       

            in vec2 v_uv0;           

            void main(){
                vec2 uv = v_uv0;
                //纹理采样
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
