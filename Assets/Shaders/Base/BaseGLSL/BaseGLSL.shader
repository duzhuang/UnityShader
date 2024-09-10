// 需要再启动unity editor 之前设置添加命令行参数 -force-opengl
Shader "Shaders/2D/BaseGLSL"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            GLSLPROGRAM

            #ifdef VERTEX
            void main()
            {
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
            }
            #endif

            #ifdef FRAGMENT
            uniform vec4 _Color;
            void main()
            {
                gl_FragColor = _Color;
            }
            #endif

            ENDGLSL
        }
      
    }    
}
