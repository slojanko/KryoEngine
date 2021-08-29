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
		case "NORMAL":
			return vertex_usage_normal;
		case "TANGENT":
			return vertex_usage_texcoord;
		case "TEXCOORD":
		case "TEXCOORD_0":
		case "TEXCOORD_1":
			return vertex_usage_texcoord;
		case "COLOR": 
		case "COLOR_0":
		case "COLOR_1":
			return vertex_usage_color;
		case "JOINTS":
		case "JOINTS_0":
			return vertex_usage_texcoord;
		case "WEIGHTS":
		case "WEIGHTS_0":
			return vertex_usage_texcoord;
		default:
			throw("Attribute not supported");
	}
}

function AttributeToOrderId(attribute) {
	switch(attribute) {
		case "POSITION": 
			return 0;
		case "NORMAL":
			return 1
		case "TANGENT":
			return 2;
		case "TEXCOORD":
			return 3;
		case "TEXCOORD_0":
			return 4;
		case "TEXCOORD_1":
			return 5;
		case "COLOR": 
			return 6;
		case "COLOR_0":
			return 7;
		case "COLOR_1":
			return 8;
		case "JOINTS":
			return 9;
		case "JOINTS_0":
			return 10;
		case "WEIGHTS":
			return 11;
		case "WEIGHTS_0":
			return 12;
		default:
			throw("Attribute not supported");
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

function ComponentTypeNormalized(type, value) {
	switch(type) {
		case 5120:
			return max(value / 127, -1.0);
		case 5121:
			return value / 255;
		case 5122:
			return max(value / 32767, -1.0);
		case 5123:
			return value / 65535;
		case 5125:
			return value / 4294967295;
		case 5126:
			return value;
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