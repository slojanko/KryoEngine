prof = new Profiler();
prof.Start();
Box = new glTF("untitled.gltf");
prof.End();
show_debug_message(prof);

gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);

xrot = 0;
yrot = 0;
zrot = 0;