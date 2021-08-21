shader_set(test_shd);
matrix_set(matrix_world, matrix_build(256, 256, -100, 0, 0, 0, 64, 64, 4));
vertex_submit(Box.meshes[0].primitive, pr_trianglelist, -1);
shader_reset();

matrix_set(matrix_world, matrix_build_identity());