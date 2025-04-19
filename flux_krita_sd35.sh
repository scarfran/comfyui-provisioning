#!/bin/bash

# Diretório de trabalho
cd /workspace/ComfyUI/custom_nodes

# Clonando os custom nodes
git clone https://github.com/Fannovel16/ComfyUI-Custom-Scripts.git
git clone https://github.com/m8flow/ComfyUI-deepcache.git
git clone https://github.com/FizzleDorf/ComfyUI-GGUF.git
git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
git clone https://github.com/ClashJonny/comfyui-inpaint-nodes.git
git clone https://github.com/ltdrdata/ComfyUI-Manager.git
git clone https://github.com/Ttl/ComfyUI-tooling-nodes.git
git clone https://github.com/ExPixelAI/comfyui-ultralytics-yolo.git
git clone https://github.com/Fannovel16/comfyui_controlnet_aux.git
git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git

# Clonando o FLUX.1
git clone https://github.com/Glow-Worm/FLUX-1.git

# Clonando suporte ao Stable Diffusion 3.5
git clone https://github.com/liusida/ComfyUI-SD3-nodes.git

echo "Todos os custom nodes foram clonados com sucesso."
