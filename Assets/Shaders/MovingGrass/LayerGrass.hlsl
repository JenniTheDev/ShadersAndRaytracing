#ifndef GRASSLAYERS_INCLUDED
#define GRASSLAYERS_INCLUDED

// Include helper functions
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "NMGLayerGrassHelpers.hlsl"

struct Attributes{
	float3 positionOS : POSITION;
	float3 normalOS : NORMAL;
	float4 uvAndHeight : TEXCOORD0;
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct VertexOutput{
	float4 uvAndHeight : TEXCOORD0;
	float3 positionWS : TEXCOORD1;
	float3 normalWS : TEXCOORD2;

	float4 positionCS : SV_POSITION;
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

//properties
float4 _BaseColor;
float4 _TopColor;

VertexOutput Vertex(Attributes input){
	// initalize output
	VertexOutput output = (VertexOutput) 0;

	UNITY_SETUP_INSTANCE_ID(input);
	UNITY_TRANSFER_INSTANCE_ID(input,output);

	output.positionWS = GetVertexPositionInputs(input.positionOS).positionWS;
	output.normalWS = GetVertexNormalInputs(input.normalOS).normalWS;
	output.uvAndHeight = input.uvAndHeight;
	output.positionCS = TransformWorldToHClip(output.positionWS);

	return output;
}

half4 Fragment(VertexOutput input) : SV_Target {
	UNITY_SETUP_INSTANCE_ID(input);

	float layerHeight = input.uvAndHeight.w;

	InputData lightingInput = (InputData) 0;
	lightingInput.positionWS = input.positionWS;
	lightingInput.normalWS = NormalizeNormalPerPixel(input.normalWS);
	lightingInput.viewDirectionWS = GetViewDirectionFromPosition(input.positionWS);
	lightingInput.shadowCoord = CalculateShadowCoord(input.positionWS, input.positionCS);

	float3 albedo = lerp(_BaseColor.rgb, _TopColor.rgb, layerHeight);

	return UniversalFragmentBlinnPhong(lightingInput, albedo, 1, 0, 0, 1);
}






#endif