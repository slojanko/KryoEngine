function struct_try_set_default(struct, variable, value) {
	if (!variable_struct_exists(struct, variable)) {
		variable_struct_set(struct, variable, value);
		return value;
	}
	return variable_struct_get(struct, variable);
}