#!/usr/bin/env bash
#
# Baixa os arquivos .unitypackage das libs que possuem release oficial.
# Os arquivos sao salvos em packages/ para posterior extracao.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PACKAGES_DIR="$PROJECT_DIR/packages"

mkdir -p "$PACKAGES_DIR"

declare -a URLS=(
  "https://github.com/Cysharp/UniTask/releases/download/2.5.11/UniTask.2.5.11.unitypackage"
  "https://github.com/Cysharp/MessagePipe/releases/download/1.8.2/MessagePipe.1.8.2.unitypackage"
  "https://github.com/Cysharp/MessagePipe/releases/download/1.8.2/MessagePipe.Interprocess.1.8.2.unitypackage"
  "https://github.com/Cysharp/MessagePipe/releases/download/1.8.2/MessagePipe.VContainer.1.8.2.unitypackage"
  "https://github.com/Cysharp/ZString/releases/download/2.6.0/ZString.Unity.2.6.0.unitypackage"
  "https://github.com/Cysharp/NativeMemoryArray/releases/download/1.2.2/NativeMemoryArray.Unity.1.2.2.unitypackage"
  "https://github.com/hadashiA/VContainer/releases/download/1.16.2/VContainer.1.16.2.unitypackage"
)

for URL in "${URLS[@]}"; do
  FILENAME="$(basename "$URL")"
  OUT="$PACKAGES_DIR/$FILENAME"
  echo "Baixando $FILENAME ..."
  curl -fsSL -o "$OUT" "$URL" || {
    echo "Erro ao baixar $URL"
    rm -f "$OUT"
  }
done

echo "Downloads concluidos. Arquivos em: $PACKAGES_DIR"
