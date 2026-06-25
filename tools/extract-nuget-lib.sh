#!/usr/bin/env bash
#
# Extrai DLLs de um pacote NuGet (.nupkg) e coloca em Runtime/<destino>/Plugins/.
# Usa netstandard2.1 por padrao; fallback para netstandard2.0 ou net6.0.
#
# Uso:
#   ./tools/extract-nuget-lib.sh <nome-do-pacote> <versao> <destino> [arquivos...]
#
# Exemplo:
#   ./tools/extract-nuget-lib.sh R3 1.3.1 Runtime/Cysharp/R3/Plugins
#   ./tools/extract-nuget-lib.sh Microsoft.Bcl.TimeProvider 8.0.0 Runtime/Cysharp/R3/Plugins Microsoft.Bcl.TimeProvider.dll
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

PKG_NAME="${1:-}"
VERSION="${2:-}"
DEST_REL="${3:-}"
shift 3 || true

if [[ -z "$PKG_NAME" || -z "$VERSION" || -z "$DEST_REL" ]]; then
  echo "Uso: $0 <nome> <versao> <destino-relativo-a-PROJECT_DIR> [arquivos...]"
  exit 1
fi

NUPKG="$PROJECT_DIR/packages/nuget/${PKG_NAME}.${VERSION}.nupkg"
DEST="$PROJECT_DIR/$DEST_REL"

if [[ ! -f "$NUPKG" ]]; then
  echo "Erro: nupkg nao encontrado: $NUPKG"
  exit 1
fi

mkdir -p "$DEST"

WORK_DIR="$(mktemp -d)"
unzip -q "$NUPKG" -d "$WORK_DIR"

# Determina a melhor pasta lib disponivel
LIB_DIR=""
for TF in "netstandard2.1" "netstandard2.0" "net6.0" "net8.0"; do
  if [[ -d "$WORK_DIR/lib/$TF" ]]; then
    LIB_DIR="$WORK_DIR/lib/$TF"
    echo "Usando lib/$TF para $PKG_NAME"
    break
  fi
done

if [[ -z "$LIB_DIR" ]]; then
  echo "Erro: nenhuma pasta lib compativel encontrada em $NUPKG"
  rm -rf "$WORK_DIR"
  exit 1
fi

# Se arquivos especificos foram passados, copia apenas eles. Caso contrario, copia todos os DLLs.
if [[ $# -gt 0 ]]; then
  for FILE in "$@"; do
    SRC="$LIB_DIR/$FILE"
    if [[ -f "$SRC" ]]; then
      cp "$SRC" "$DEST/"
      echo "  -> $FILE"
    else
      echo "  AVISO: $FILE nao encontrado em lib/"
    fi
  done
else
  for SRC in "$LIB_DIR"/*.dll; do
    [[ -f "$SRC" ]] || continue
    cp "$SRC" "$DEST/"
    echo "  -> $(basename "$SRC")"
  done
fi

rm -rf "$WORK_DIR"
echo "Concluido. DLLs em: $DEST"
