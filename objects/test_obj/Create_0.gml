gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);

prof = new Profiler();
prof.Start();
gltf = new glTF("stress.gltf");
prof.End();
show_debug_message(prof);

xrot = 0;
yrot = 0;
zrot = 0;