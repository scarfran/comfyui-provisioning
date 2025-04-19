#!/bin/bash

# Diretório base
cd /workspace/ComfyUI/custom_nodes

# Clone todos os nodes da sua instalação local
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

# Instalação específica para Krita
git clone https://github.com/Glow-Worm/FLUX-1.git
wget https://github.com/BlenderNeko/ComfyUI_KritaNodes/archive/refs/heads/main.zip
unzip main.zip && mv ComfyUI_KritaNodes-main ComfyUI_KritaNodes

# Dependências extras
pip install -r /workspace/ComfyUI/custom_nodes/FLUX-1/requirements.txt
pip install ultralytics onnxruntime
pip install ultralytics
