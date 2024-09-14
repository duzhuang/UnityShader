// 需要再启动unity editor 之前设置添加命令行参数 -force-opengl
Shader "Shaders/GLSL/BaseGLSL"
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
            //使用GLSL
            GLSLPROGRAM

            //指定顶点着色器
            #ifdef VERTEX
            //函数名必须为main
            //顶点着色器的入口函数
            void main()
            {
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
            }
            #endif

            //指定片元着色器
            #ifdef FRAGMENT
            uniform vec4 _Color;
            
            //函数名必须为main
            //片元着色器的入口函数
            void main()
            {
                gl_FragColor = _Color;
            }
            #endif

            ENDGLSL
        }
      
    }    
}
