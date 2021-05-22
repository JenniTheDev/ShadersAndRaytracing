Shader "Grass/LayerGrass"{
	Properties{
	   _BaseColor("Base color", Color) = (0,0.5,0,1) // lowest layer
	   _TopColor("Top Color", Color) = (0,1,0,1) // highest layer
	}
		SubShader{
		// UP
		Tags{"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "IgnoreProjector" = "True"}

			//forward pass
			Pass{
				Name "ForwardLit"
				Tags{"LightMode" = "UniversalForward"}
		

				HLSLPROGRAM
				// signal this shader requires a compute bugger
				#pragma prefer_hlslcc gles
				#pragma exclude_renders d3d11_9x

				// lighting and shadow keywords
				#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
				#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
				#pragma multi_compile _ _ADDITIONAL_LIGHTS
				#pragma multi_compile _ _ADDITIONAL_LIGHTS_SHADOWS
				#pragma multi_compile _ _SHADOWS_SOFT
				// gpu instancing
				#pragma multi_compile_instancing
				#pragma multi_compile _ DOTS_INSTANCING_ON

				// register functions
				#pragma vertex Vertex
				#pragma fragment Fragment

				// Include logic file
				#include "LayerGrass.hlsl"

				ENDHLSL
			}
		}
}