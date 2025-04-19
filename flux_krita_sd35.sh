#!/bin/bash

# Configuração inicial
LOG_FILE="/workspace/provisioning.log"
echo "Iniciando instalação em $(date)" > $LOG_FILE

# Diretório base
mkdir -p /workspace/ComfyUI/custom_nodes
cd /workspace/ComfyUI/custom_nodes

# Lista de nodes prioritários (Krita/FLUX essentials)
CORE_NODES=(
  "https://github.com/ltdrdata/ComfyUI-Manager.git"
  "https://github.com/Glow-Worm/FLUX-1.git"
  "https://github.com/BlenderNeko/ComfyUI_KritaNodes.git"
  "https://github.com/ltdrdata/ComfyUI-Impact-Pack.git"
  "https://github.com/Fannovel16/comfyui_controlnet_aux.git"
)

# Lista de nodes secundários
EXTRA_NODES=(
  "https://github.com/Fannovel16/ComfyUI-Custom-Scripts.git"
  "https://github.com/m8flow/ComfyUI-deepcache.git"
  "https://github.com/FizzleDorf/ComfyUI-GGUF.git"
  "https://github.com/ClashJonny/comfyui-inpaint-nodes.git"
  "https://github.com/Ttl/ComfyUI-tooling-nodes.git"
  "https://github.com/ExPixelAI/comfyui-ultralytics-yolo.git"
  "https://github.com/cubiq/ComfyUI_IPAdapter_plus.git"
)

# Instala nodes prioritários primeiro
for node in "${CORE_NODES[@]}"; do
  echo "Instalando node prioritário: $node" >> $LOG_FILE
  git clone $node || echo "Falha ao instalar $node" >> $LOG_FILE
done

# Instala nodes extras em paralelo (acelera o processo)
for node in "${EXTRA_NODES[@]}"; do
  echo "Instalando node extra: $node" >> $LOG_FILE
  (git clone $node && echo "$node instalado com sucesso" >> $LOG_FILE) &
done

# Espera conclusão dos processos paralelos
wait

# Instalação específica para Krita (FLUX)
if [ -d "/workspace/ComfyUI/custom_nodes/FLUX-1" ]; then
  pip install -r /workspace/ComfyUI/custom_nodes/FLUX-1/requirements.txt >> $LOG_FILE
else
  echo "ATENÇÃO: FLUX-1 não foi instalado corretamente" >> $LOG_FILE
fi

# Dependências críticas
pip install ultralytics onnxruntime opencv-python >> $LOG_FILE

# Fix para KritaNodes (se necessário)
if [ -d "/workspace/ComfyUI/custom_nodes/ComfyUI_KritaNodes" ]; then
  wget https://github.com/BlenderNeko/ComfyUI_KritaNodes/archive/refs/heads/main.zip
  unzip main.zip && mv ComfyUI_KritaNodes-main ComfyUI_KritaNodes
fi

echo "Instalação concluída em $(date)" >> $LOG_FILE
