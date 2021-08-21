function VertexFormatContainer(types, usages) constructor {
	vertex_types = types;
	vertex_usages = usages;
	
	vertex_format_begin();
	for(var i = 0; i < array_length(types); i++) {
		vertex_format_add_custom(types[i], usages[i]);
	}
	vertex_format = vertex_format_end();
	
	static Compare = function(types, usages) {
		if (array_length(types) != array_length(vertex_types)) {
			return false;
		}
		
		var count = array_length(types);
		for(var i = 0; i < count; i++) {
			var match = false;
			for(var j = 0; j < count; j++) {
				if (vertex_types[j] == types[i] && vertex_usages[j] == types[i]) {
					match = true;
					break;
				}
			}
			
			if (!match) {
				return false;
			}
		}
		
		return true;
	}
	
	static Destroy = function() {
		vertex_types = 0;
		array_types = 0;
		vertex_format_delete(vertex_format);
	}
}