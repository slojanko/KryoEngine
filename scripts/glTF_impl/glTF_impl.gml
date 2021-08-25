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
			var mesh = new Mesh();
			mesh.primitive = BuildPrimitive(json.meshes[i].primitives[0]);
			meshes[i] = mesh;
		}
		
		return meshes;
	}

	static BuildPrimitive = function(primitive) {
		var attributes_names = variable_struct_get_names(primitive.attributes);
		var attributes_count = array_length(attributes_names);
		
		var indices_accessor = json.accessors[primitive.indices];
		var indices_buffer_view = json.bufferViews[indices_accessor.bufferView];
		var indices_buffer_type = ComponentTypeToBufferType(indices_accessor.componentType);
		var indices_element_byte_size = ComponentTypeToElementByteSize(indices_accessor.componentType);
		
		var vertex_buffer = vertex_create_buffer();
		vertex_begin(vertex_buffer, GetVertexFormat(primitive.attributes));
		
		// Go through all indices
		for(var i = 0; i < indices_accessor.count; i++) {
			// Read index value
			var indices_byte_offset = indices_buffer_view.byteOffset + indices_accessor.byteOffset + i * indices_element_byte_size;
			buffer_seek(buffers[indices_buffer_view.buffer], buffer_seek_start, indices_byte_offset);
			var indices_value = buffer_read(buffers[indices_buffer_view.buffer], indices_buffer_type);
			
			// Go through all attributes
			for(var j = 0; j < attributes_count; j++) {
				var attribute = variable_struct_get(primitive.attributes, attributes_names[j]);
				var attribute_accessor = json.accessors[attribute];
				
				var attribute_buffer_view = json.bufferViews[attribute_accessor.bufferView];
				var attribute_number_of_components = AccessorTypeToNumberOfComponents(attribute_accessor.type);
				var attribute_buffer_type = ComponentTypeToBufferType(attribute_accessor.componentType);
				var attribute_element_byte_size = ComponentTypeToElementByteSize(attribute_accessor.componentType);
				
				var attribute_byte_offset = attribute_buffer_view.byteOffset + attribute_accessor.byteOffset + indices_value * attribute_number_of_components * attribute_element_byte_size;
				buffer_seek(buffers[attribute_buffer_view.buffer], buffer_seek_start, attribute_byte_offset);
				
				var data = array_create(attribute_number_of_components);
				for(var k = 0; k < attribute_number_of_components; k++) {
					if (attribute_accessor.normalized) 
						data[k] = ComponentTypeNormalized(attribute_accessor.componentType, buffer_read(buffers[attribute_buffer_view.buffer], attribute_buffer_type));
					else 
						data[k] = buffer_read(buffers[attribute_buffer_view.buffer], attribute_buffer_type);
				}
				
				switch(attribute_number_of_components) {
					case 1:
						vertex_float1(vertex_buffer, data[0]);
						break;
					case 2:
						vertex_float2(vertex_buffer, data[0], data[1]);
						break;
					case 3:
						vertex_float3(vertex_buffer, data[0], -data[1], -data[2]);
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

	static GetVertexFormat = function(attributes) {		
		var attributes_names = variable_struct_get_names(attributes);
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