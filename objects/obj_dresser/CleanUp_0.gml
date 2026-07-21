// Reset shader and blend mode in case room changes mid-frame
if (shader_current() != -1) {
    shader_reset();
}
gpu_set_blendmode(bm_normal);
gpu_set_stencil_enable(false);