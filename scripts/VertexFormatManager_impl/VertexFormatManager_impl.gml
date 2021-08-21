function VertexFormatManager() constructor {
	vertex_format_containers = array_create(0);
	vertex_format_count = 0;

	function GetVertexFormatContainer(types, usages) {
		for(var i = 0; i < vertex_format_count; i++) {
			if (vertex_format_containers[i].Compare(types, usages)) {
				return vertex_format_containers[i].vertex_format;
			}
		}
	
		var vertex_format_container = new VertexFormatContainer(types, usages);
		array_push(vertex_format_containers, vertex_format_container);
		vertex_format_count++;
		
		return vertex_format_container;
	}
}