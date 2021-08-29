shader_set(test_shd);
matrix_set(matrix_world, matrix_build(640, 360, -200, xrot, yrot, zrot, 128, 128, 128));
vertex_submit(gltf.meshes[0].primitives[0], pr_trianglelist, -1);
shader_reset();

matrix_set(matrix_world, matrix_build_identity());