global.vertex_formats = [];
global.vertex_formats_count = 0;

function GetVertexFormat(types, usages) {
	for(var i = 0; i < global.vertex_formats_count; i++) {
		if (global.vertex_formats[i].Compare(types, usages)) {
			return global.vertex_formats[i];
		}
	}
	
	var vertex_format = new VertexFormat(types, usages);
	array_push(global.vertex_formats, vertex_format);
	return vertex_format;
}