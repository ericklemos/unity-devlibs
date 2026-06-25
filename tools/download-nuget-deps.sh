#!/usr/bin/env bash
#
# Baixa dependencias transitivas NuGet necessarias para as libs do wrapper.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
NUGET_DIR="$PROJECT_DIR/packages/nuget"

mkdir -p "$NUGET_DIR"

NUGET_BASE="https://www.nuget.org/api/v2/package"

declare -a PACKAGES=(
  # MemoryPack
  "MemoryPack.Core/1.21.4"
  "MemoryPack.Generator/1.21.4"
  # ZLinq
  "System.Runtime.CompilerServices.Unsafe/6.1.2"
  # MasterMemory
  "MasterMemory.Annotations/3.0.4"
  "MessagePack/3.1.3"
  # ObservableCollections
  "System.Runtime.CompilerServices.Unsafe/6.0.0"
)

for PKG in "${PACKAGES[@]}"; do
  IFS='/' read -r NAME VERSION <<< "$PKG"
  OUT="$NUGET_DIR/${NAME}.${VERSION}.nupkg"
  URL="$NUGET_BASE/$NAME/$VERSION"

  if [[ -f "$OUT" ]]; then
    echo "Ja existe: $OUT"
    continue
  fi

  echo "Baixando $NAME $VERSION ..."
  curl -fsSL -o "$OUT" "$URL" || {
    echo "Erro ao baixar $URL"
    rm -f "$OUT"
  }
done

echo "Downloads de dependencias concluidos."
