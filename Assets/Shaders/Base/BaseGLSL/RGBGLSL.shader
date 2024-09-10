Shader "Shaders/GLSL/RGB"
{   
    SubShader
    {
        Pass
        {
            GLSLPROGRAM
                              
            #ifdef VERTEX

            out vec4 v_color;
            
            void main(){
                v_color = gl_Vertex + vec4(0.4,0.4,0.4,0.0);
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;                
            }            

            #endif

            #ifdef FRAGMENT

            in vec4 v_color;
            void main(){
                gl_FragColor = v_color;
            }

            #endif

            ENDGLSL
        }
    }
}
