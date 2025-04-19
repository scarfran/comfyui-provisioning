#!/bin/bash

# Libera a porta 8188
fuser -k 8188/tcp || true

# Instala dependências do sistema
apt update && apt install -y psmisc libgl1

# Configuração inicial
LOG_FILE="/workspace/provisioning.log"
echo "Iniciando instalação em $(date)" > $LOG_FILE

# Instala dependências do sistema
apt update && apt install -y psmisc libgl1 >> $LOG_FILE 2>&1

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
  "https://github.com/cubiq/ComfyUI_IPAdapter_plus.git"  # Movido para essencial
)

# Lista de nodes secundários
EXTRA_NODES=(
  "https://github.com/Fannovel16/ComfyUI-Custom-Scripts.git"
  "https://github.com/m8flow/ComfyUI-deepcache.git"
  "https://github.com/FizzleDorf/ComfyUI-GGUF.git"
  "https://github.com/ClashJonny/comfyui-inpaint-nodes.git"
  "https://github.com/Ttl/ComfyUI-tooling-nodes.git"
  "https://github.com/ExPixelAI/comfyui-ultralytics-yolo.git"
)

# Instala nodes prioritários primeiro com verificações
for node in "${CORE_NODES[@]}"; do
  node_name=$(basename "$node" .git)
  echo "[$(date)] Instalando node prioritário: $node_name" >> $LOG_FILE
  if [ ! -d "$node_name" ]; then
    git clone "$node" >> $LOG_FILE 2>&1 || echo "Falha ao instalar $node_name" >> $LOG_FILE
    
    # Instala requirements específicos
    if [ -f "$node_name/requirements.txt" ]; then
      pip install -r "$node_name/requirements.txt" >> $LOG_FILE 2>&1
    fi
  else
    echo "$node_name já existe, pulando..." >> $LOG_FILE
  fi
done

# Instala nodes extras em paralelo
for node in "${EXTRA_NODES[@]}"; do
  node_name=$(basename "$node" .git)
  echo "[$(date)] Instalando node extra: $node_name" >> $LOG_FILE
  if [ ! -d "$node_name" ]; then
    (git clone "$node" >> $LOG_FILE 2>&1 && 
     echo "$node_name instalado com sucesso" >> $LOG_FILE &&
     [ -f "$node_name/requirements.txt" ] && pip install -r "$node_name/requirements.txt" >> $LOG_FILE 2>&1) &
  else
    echo "$node_name já existe, pulando..." >> $LOG_FILE
  fi
done

# Espera conclusão dos processos paralelos
wait

# Dependências críticas para GPU
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121 >> $LOG_FILE 2>&1
pip install onnxruntime-gpu ultralytics opencv-python-headless >> $LOG_FILE 2>&1

# Fix para KritaNodes
if [ ! -d "ComfyUI_KritaNodes" ] && [ -d "ComfyUI_KritaNodes-main" ]; then
  mv ComfyUI_KritaNodes-main ComfyUI_KritaNodes
fi

# Prepara para iniciar o ComfyUI
echo "[$(date)] Liberando porta 8188" >> $LOG_FILE
fuser -k 8188/tcp >> $LOG_FILE 2>&1 || true

# Cria script de inicialização automática
cat > /workspace/start_comfyui.sh << 'EOL'
#!/bin/bash
cd /workspace/ComfyUI
fuser -k 8188/tcp || true
python main.py --listen 0.0.0.0 --port 8188 --enable-cors-header
EOL

chmod +x /workspace/start_comfyui.sh

echo "[$(date)] Instalação concluída com sucesso!" >> $LOG_FILE
echo "Execute '/workspace/start_comfyui.sh' para iniciar o ComfyUI" >> $LOG_FILE
