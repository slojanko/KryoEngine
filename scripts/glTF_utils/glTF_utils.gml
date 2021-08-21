function AccessorTypeToVertexType(type) {
	switch(type) {
		case "SCALAR": 
			return vertex_type_float1;
		case "VEC2": 
			return vertex_type_float2;
		case "VEC3": 
			return vertex_type_float3;
		case "VEC4": 
			return vertex_type_float4;
		default:
			throw("AccessorType not supported");
	}
}

function AccessorTypeToNumberOfComponents(type) {
		switch(type) {
		case "SCALAR": 
			return 1;
		case "VEC2": 
			return 2;
		case "VEC3": 
			return 3;
		case "VEC4": 
			return 4;
		default:
			throw("AccessorType not supported");
	}
}

function AttributeToVertexUsage(attribute) {
	switch(attribute) {
		case "POSITION": 
			return vertex_usage_position;
		case "TEXCOORD":
			return vertex_usage_texcoord;
		case "NORMAL": 
			return vertex_usage_normal;
		case "COLOR": 
			return vertex_usage_color;
		default:
			return vertex_usage_texcoord;
	}
}

function ComponentTypeToBufferType(type) {
	switch(type) {
		case 5120:
			return buffer_s8;
		case 5121:
			return buffer_u8;
		case 5122:
			return buffer_s16;
		case 5123:
			return buffer_u16;
		case 5125:
			return buffer_u32;
		case 5126:
			return buffer_f32;
		default:
			throw("ComponentType not supported");
	}
}

function ComponentTypeToElementByteSize(type) {
	switch(type) {
		case 5120:
			return 1;
		case 5121:
			return 1;
		case 5122:
			return 2;
		case 5123:
			return 2;
		case 5125:
			return 4;
		case 5126:
			return 4;
		default:
			throw("ComponentType not supported");
	}
}