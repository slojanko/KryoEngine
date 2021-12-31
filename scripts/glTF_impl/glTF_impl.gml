function glTF(filename) constructor {
	json = LoadJson(filename);
	AddDefaults(json);
	buffers = LoadBuffers();
	meshes = LoadMeshes();

	static LoadJson = function(filename) {
		var buffer = buffer_load(filename);
	
		buffer_seek(buffer, buffer_seek_start, 0);
		var text_from_buffer = buffer_read(buffer, buffer_string);
		buffer_delete(buffer);
	
		var json = json_parse(text_from_buffer);
		return json;
	}
	
	static AddDefaults = function(json) {
		var accessors_count = array_length(json.accessors);
		for(var i = 0; i < accessors_count; i++) {
			StructTrySetDefault(json.accessors[i], "byteOffset", 0);
			StructTrySetDefault(json.accessors[i], "normalized", false);
		}
		
		var bufferviews_count = array_length(json.bufferViews);
		for(var i = 0; i < bufferviews_count; i++) {
			StructTrySetDefault(json.bufferViews[i], "byteOffset", 0);
		}
	}
	
	static LoadBuffers = function() {
		var buffers_count = array_length(json.buffers);
		var buffers = array_create(buffers_count);
	
		for(var i = 0; i < buffers_count; i++) {
			buffers[i] = buffer_load(json.buffers[i].uri);
		}
		
		return buffers;
	}
	
	static LoadMeshes = function() {
		var meshes_count = array_length(json.meshes);
		var meshes = array_create(meshes_count);
	
		for(var i = 0; i < meshes_count; i++) {
			var primitives_count = array_length(json.meshes[i].primitives);
			var primitives = array_create(primitives_count);
			
			for(var j = 0; j < primitives_count; j++) {
				primitives[j] = BuildPrimitive(json.meshes[i].primitives[j]);
			}
			
			var mesh = new Mesh(primitives);
			meshes[i] = mesh;
		}
		
		return meshes;
	}

	static BuildPrimitive = function(primitive) {
		// Speedup
		var data = array_create(4);
		var accessor;
		var position_index;
		
		// Indices
		accessor = json.accessors[primitive.indices];
		var indices = {
			accessor : accessor,
			buffer_view : json.bufferViews[accessor.bufferView],
			buffer_type : ComponentTypeToBufferType(accessor.componentType),
			element_byte_size : ComponentTypeToElementByteSize(accessor.componentType)
		};
		
		// Attributes
		var attributes_names = variable_struct_get_names(primitive.attributes);
		var attributes_count = array_length(attributes_names);
		array_sort(attributes_names, function(el_left, el_right)
	    {
			return AttributeToOrderId(el_left) - AttributeToOrderId(el_right);
	    });
		
		var attributes = array_create(attributes_count);
		for(var i = 0; i < attributes_count; i++) {
			if (attributes_names[i] == "POSITION") {
				position_index = i;
			}
			
			accessor = json.accessors[variable_struct_get(primitive.attributes, attributes_names[i])];
			var attribute = {
				accessor : accessor,
				buffer_view : json.bufferViews[accessor.bufferView],
				number_of_components : AccessorTypeToNumberOfComponents(accessor.type),
				buffer_type : ComponentTypeToBufferType(accessor.componentType),
				element_byte_size : ComponentTypeToElementByteSize(accessor.componentType)
			};
			
			attributes[i] = attribute;
		}
		
		var vertex_buffer = vertex_create_buffer();
		vertex_begin(vertex_buffer, GetVertexFormat(primitive.attributes, attributes_names));
		
		// Go through all indices
		var indices_count = indices.accessor.count;
		for(var i = 0; i < indices_count; i++) {
			// Read index value
			var indices_byte_offset = indices.buffer_view.byteOffset + indices.accessor.byteOffset + i * indices.element_byte_size;
			buffer_seek(buffers[indices.buffer_view.buffer], buffer_seek_start, indices_byte_offset);
			var indices_value = buffer_read(buffers[indices.buffer_view.buffer], indices.buffer_type);
			
			// Go through all attributes
			for(var j = 0; j < attributes_count; j++) {
				var attribute = attributes[j];
				var attribute_byte_offset = attribute.buffer_view.byteOffset + attribute.accessor.byteOffset + indices_value * attribute.number_of_components * attribute.element_byte_size;
				buffer_seek(buffers[attribute.buffer_view.buffer], buffer_seek_start, attribute_byte_offset);
				
				if (attribute.accessor.normalized) {
					for(var k = 0; k < attribute.number_of_components; k++) {
						data[k] = ComponentTypeNormalized(attribute.accessor.componentType, buffer_read(buffers[attribute.buffer_view.buffer], attribute.buffer_type));
					}
				} else {
					for(var k = 0; k < attribute.number_of_components; k++) {
						data[k] = buffer_read(buffers[attribute.buffer_view.buffer], attribute.buffer_type);
					}
				}
				
				switch(attribute.number_of_components) {
					case 1:
						vertex_float1(vertex_buffer, data[0]);
						break;
					case 2:
						vertex_float2(vertex_buffer, data[0], data[1]);
						break;
					case 3:
						// Position on Y/Z needs to be flipped
						if (j == position_index) {
							vertex_float3(vertex_buffer, data[0], -data[1], -data[2]);
						} else {
							vertex_float3(vertex_buffer, data[0], data[1], data[2]);
						}
						break;
					case 4:
						vertex_float4(vertex_buffer, data[0], data[1], data[2], data[3]);
						break;
				}
			}
		}	
		
		vertex_end(vertex_buffer);
		return vertex_buffer;
	}

	static GetVertexFormat = function(attributes, attributes_names) {		
		var attributes_count = array_length(attributes_names);
		var types = array_create(attributes_count);
		var usages = array_create(attributes_count);
	
		for(var j = 0; j < attributes_count; j++) {
			var accessor = json.accessors[variable_struct_get(attributes, attributes_names[j])];
			types[j] = AccessorTypeToVertexType(accessor.type);
			usages[j] = AttributeToVertexUsage(attributes_names[j]);
		}
	
		var vertex_format_container = global.pVertexFormatManager.GetVertexFormatContainer(types, usages);
		return vertex_format_container.vertex_format;
	}
}