function StructTrySetDefault(struct, variable, value) {
	if (!variable_struct_exists(struct, variable)) {
		variable_struct_set(struct, variable, value);
	}
}