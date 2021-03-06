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
			if (vertex_types[i] != types[i] || vertex_usages[i] == usages[i]) {
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