float4x4 gViewProj : VIEWPROJ;
float4x4 gViewInverse : VIEWINV;
Texture2D gParticleTexture;

float PI = 3.141592;

SamplerState samLinear
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = WRAP;
    AddressV = WRAP;
};

DepthStencilState DisableDepthWriting
{
	DepthEnable = TRUE;
	DepthWriteMask = ZERO;
};

RasterizerState BackCulling
{
	CullMode = BACK;
};

struct VS_DATA
{
	float3 Position : POSITION;
	float4 Color: COLOR;
	float Size: TEXCOORD0;
	float Rotation : TEXCOORD1;
};

struct GS_DATA
{
	float4 Position : SV_POSITION;
	float2 TexCoord: TEXCOORD0;
	float4 Color : COLOR;
};

VS_DATA MainVS(VS_DATA input)
{
	return input;
}

void CreateVertex(inout TriangleStream<GS_DATA> triStream, float3 origin, float3 offset, float2 texCoord, float4 col, float2x2 rotation)
{
	GS_DATA data = (GS_DATA)0;
	offset = float3(mul(offset.xy, rotation), offset.z);
	offset = mul(offset, (float3x3)gViewInverse);
	float3 pos = offset + origin;
	data.Position = mul(float4(pos, 1.0f), gViewProj);
	data.TexCoord = texCoord;
	data.Color = col;
	triStream.Append(data);
}

[maxvertexcount(4)]
void MainGS(point VS_DATA vertex[1], inout TriangleStream<GS_DATA> triStream)
{
	float3 origin = vertex[0].Position;

	float3 topLeft = float3(-vertex[0].Size / 2.0f, vertex[0].Size / 2.0f, 0.0f);
	float3 topRight = float3(vertex[0].Size / 2.0f, vertex[0].Size / 2.0f, 0.0f);
	float3 bottomLeft = float3(-vertex[0].Size / 2.0f, -vertex[0].Size / 2.0f, 0.0f);
	float3 bottomRight = float3(vertex[0].Size / 2.0f, -vertex[0].Size / 2.0f, 0.0f);

	float rad = vertex[0].Rotation * PI / 180.0f;
	float2x2 rotation = {cos(rad), -sin(rad), sin(rad), cos(rad)};

	CreateVertex(triStream, origin, bottomLeft, float2(0,1), vertex[0].Color, rotation);
	CreateVertex(triStream, origin, topLeft, float2(0,0), vertex[0].Color, rotation);
	CreateVertex(triStream, origin, bottomRight, float2(1,1), vertex[0].Color, rotation);
	CreateVertex(triStream, origin, topRight, float2(1,0), vertex[0].Color, rotation);
}

float4 MainPS(GS_DATA input) : SV_TARGET 
{	
	float4 result = gParticleTexture.Sample(samLinear, input.TexCoord);
	return result * input.Color;
}

technique10 Default 
{
	pass P0 
	{
		SetVertexShader(CompileShader(vs_4_0, MainVS()));
		SetGeometryShader(CompileShader(gs_4_0, MainGS()));
		SetPixelShader(CompileShader(ps_4_0, MainPS()));
		SetRasterizerState(BackCulling);       
		SetDepthStencilState(DisableDepthWriting, 0);   
	}
}