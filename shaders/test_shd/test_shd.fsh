struct PixelShaderInput{
	float4 vPosition : SV_POSITION;
    float4 vColor    : COLOR0;
};

struct PixelShaderOutput
{
    float4 vColor    : SV_TARGET0;
};

PixelShaderOutput main(PixelShaderInput INPUT)
{
	PixelShaderOutput OUTPUT;
	OUTPUT.vColor =  INPUT.vColor;
 
	return OUTPUT;
}