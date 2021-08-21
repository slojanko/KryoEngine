struct VertexShaderInput
{
    float4 vPosition : POSITION;
	float4 vColor : COLOR0;
	//float4 vNorml    : NORMAL0;
};

struct VertexShaderOutput
{
    float4 vPosition : SV_POSITION;
    float4 vColor    : COLOR0;
};

VertexShaderOutput main(VertexShaderInput INPUT)
{
    VertexShaderOutput OUTPUT;

    float4 matrixWVP = mul(gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION], INPUT.vPosition);

    OUTPUT.vPosition = matrixWVP;
    OUTPUT.vColor = INPUT.vColor;

    return OUTPUT;
}