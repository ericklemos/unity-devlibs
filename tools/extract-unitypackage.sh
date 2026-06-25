#!/usr/bin/env bash
#
# Extrai um .unitypackage do Unity e copia o conteudo para a pasta Runtime do wrapper.
# Remove caminhos intermediarios tipo Plugins/<Lib>/ ou Assets/Plugins/<Lib>/,
# normalizando a estrutura para Runtime/ e Editor/ diretamente sob a pasta da lib.
#
# Uso:
#   ./tools/extract-unitypackage.sh <caminho-do-unitypackage> <nome-da-lib>
#
# Exemplo:
#   ./tools/extract-unitypackage.sh ~/Downloads/UniTask.2.5.11.unitypackage UniTask
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

UNITYPACKAGE="${1:-}"
LIB_NAME="${2:-}"

if [[ -z "$UNITYPACKAGE" || -z "$LIB_NAME" ]]; then
  echo "Uso: $0 <caminho-do-unitypackage> <nome-da-lib>"
  echo "Exemplo: $0 ~/Downloads/UniTask.2.5.11.unitypackage UniTask"
  exit 1
fi

if [[ ! -f "$UNITYPACKAGE" ]]; then
  echo "Erro: arquivo nao encontrado: $UNITYPACKAGE"
  exit 1
fi

# Libs Cysharp ficam em Runtime/Cysharp/<Lib>; VContainer fica em Runtime/VContainer.
if [[ "$LIB_NAME" == "VContainer" ]]; then
  DEST_DIR="$PROJECT_DIR/Runtime/VContainer"
else
  DEST_DIR="$PROJECT_DIR/Runtime/Cysharp/$LIB_NAME"
fi

mkdir -p "$DEST_DIR"

WORK_DIR="$(mktemp -d)"
echo "Extraindo $UNITYPACKAGE para $WORK_DIR ..."

tar -xzf "$UNITYPACKAGE" -C "$WORK_DIR"

# Cada arquivo no .unitypackage tem o formato: ./<guid>/pathname e ./<guid>/asset
# O arquivo pathname contem o caminho original do asset dentro do projeto Unity.
echo "Reorganizando arquivos para $DEST_DIR ..."

find "$WORK_DIR" -maxdepth 1 -type d | while read -r GUID_DIR; do
  [[ "$GUID_DIR" == "$WORK_DIR" ]] && continue

  PATHNAME_FILE="$GUID_DIR/pathname"
  ASSET_FILE="$GUID_DIR/asset"
  ASSET_META_FILE="$GUID_DIR/asset.meta"

  if [[ ! -f "$PATHNAME_FILE" ]]; then
    continue
  fi

  # Le o caminho original e remove prefixos comuns de pacotes UPM/AssetStore.
  RAW_PATH="$(cat "$PATHNAME_FILE" | sed 's|\r||g')"

  # Remove prefixos como Assets/Plugins/UniTask/, Plugins/UniTask/, Assets/UniTask/, etc.
  NORMALIZED_PATH="$RAW_PATH"
  NORMALIZED_PATH="$(echo "$NORMALIZED_PATH" | sed -E "s|^Assets/Plugins/${LIB_NAME}/||")"
  NORMALIZED_PATH="$(echo "$NORMALIZED_PATH" | sed -E "s|^Plugins/${LIB_NAME}/||")"
  NORMALIZED_PATH="$(echo "$NORMALIZED_PATH" | sed -E "s|^Assets/${LIB_NAME}/||")"
  NORMALIZED_PATH="$(echo "$NORMALIZED_PATH" | sed -E "s|^${LIB_NAME}/||")"

  # Ignora o package.json interno do .unitypackage; o wrapper ja tem o seu proprio.
  if [[ "$(basename "$NORMALIZED_PATH")" == "package.json" ]]; then
    continue
  fi

  if [[ -f "$ASSET_FILE" ]]; then
    TARGET_FILE="$DEST_DIR/$NORMALIZED_PATH"
    mkdir -p "$(dirname "$TARGET_FILE")"
    cp "$ASSET_FILE" "$TARGET_FILE"
  fi

  if [[ -f "$ASSET_META_FILE" ]]; then
    # Se o asset original foi ignorado (package.json), ignora o .meta tambem.
    if [[ "$(basename "$NORMALIZED_PATH")" == "package.json" ]]; then
      continue
    fi
    TARGET_META="$DEST_DIR/${NORMALIZED_PATH}.meta"
    mkdir -p "$(dirname "$TARGET_META")"
    cp "$ASSET_META_FILE" "$TARGET_META"
  fi
done

rm -rf "$WORK_DIR"

echo "Concluido. Conteudo disponivel em: $DEST_DIR"
