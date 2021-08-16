shader_set(test_shd);
matrix_set(matrix_world, matrix_build(32, 16, -100, 0, 0, 0, 16, 16, 4));
vertex_submit(Box.meshes[0].primitive, pr_trianglelist, -1);
shader_reset();