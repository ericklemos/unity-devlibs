#!/usr/bin/env bash
#
# Baixa pacotes NuGet para libs que nao possuem .unitypackage oficial.
# Os arquivos .nupkg sao salvos em packages/nuget/ para posterior extracao.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
NUGET_DIR="$PROJECT_DIR/packages/nuget"

mkdir -p "$NUGET_DIR"

# NuGet.org package download URL pattern
NUGET_BASE="https://www.nuget.org/api/v2/package"

declare -a PACKAGES=(
  "R3/1.3.1"
  "Microsoft.Bcl.TimeProvider/8.0.0"
  "System.Threading.Channels/8.0.0"
  "System.ComponentModel.Annotations/5.0.0"
  "MemoryPack/1.21.4"
  "ZLinq/1.5.6"
  "MasterMemory/3.0.4"
  "ObservableCollections/3.3.4"
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

echo "Downloads NuGet concluidos. Arquivos em: $NUGET_DIR"
