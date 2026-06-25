#!/usr/bin/env bash
#
# Copia DLLs do cache NuGet global para as pastas Runtime do wrapper.
# Usa netstandard2.1 quando disponivel; fallback para netstandard2.0.
#

set -uo pipefail

NUGET_CACHE="/c/Users/erick/.nuget/packages"
PROJECT_DIR="/c/Users/erick/OneDrive/Documentos/projetos/unity-devlibs"

copy_dll() {
  local PKG="$1"
  local VERSION="$2"
  local DEST_DIR="$3"
  local FILENAME="$4"

  # Fontes possiveis: cache global NuGet ou nupkg local baixado manualmente
  local LOCAL_NUPKG="$PROJECT_DIR/packages/nuget/${PKG}.${VERSION}.nupkg"
  local WORK_DIR=""
  local BASE_DIR=""

  if [[ -f "$LOCAL_NUPKG" ]]; then
    WORK_DIR="$(mktemp -d)"
    unzip -q "$LOCAL_NUPKG" -d "$WORK_DIR"
    BASE_DIR="$WORK_DIR"
  else
    BASE_DIR="$NUGET_CACHE/$PKG/$VERSION"
  fi

  # Procura em netstandard2.1, depois netstandard2.0, depois net8.0, depois net6.0
  local SRC=""
  for TFM in "netstandard2.1" "netstandard2.0" "net8.0" "net6.0"; do
    local CANDIDATE="$BASE_DIR/lib/$TFM/$FILENAME"
    if [[ -f "$CANDIDATE" ]]; then
      SRC="$CANDIDATE"
      echo "  Copiando $FILENAME ($TFM) de $PKG/$VERSION"
      break
    fi
  done

  if [[ -z "$SRC" ]]; then
    echo "  AVISO: $FILENAME nao encontrado em $PKG/$VERSION"
    [[ -n "$WORK_DIR" ]] && rm -rf "$WORK_DIR"
    return 1
  fi

  mkdir -p "$DEST_DIR"
  cp "$SRC" "$DEST_DIR/$FILENAME"
  [[ -n "$WORK_DIR" ]] && rm -rf "$WORK_DIR"
}

# R3
DEST="$PROJECT_DIR/Runtime/Cysharp/R3/Runtime"
copy_dll "r3" "1.3.1" "$DEST" "R3.dll"
copy_dll "microsoft.bcl.asyncinterfaces" "6.0.0" "$DEST" "Microsoft.Bcl.AsyncInterfaces.dll"
copy_dll "microsoft.bcl.timeprovider" "8.0.0" "$DEST" "Microsoft.Bcl.TimeProvider.dll"
copy_dll "system.threading.channels" "8.0.0" "$DEST" "System.Threading.Channels.dll"
copy_dll "system.componentmodel.annotations" "5.0.0" "$DEST" "System.ComponentModel.Annotations.dll"

# MemoryPack
DEST="$PROJECT_DIR/Runtime/Cysharp/MemoryPack/Runtime"
copy_dll "memorypack.core" "1.21.4" "$DEST" "MemoryPack.Core.dll"
copy_dll "system.collections.immutable" "8.0.0" "$DEST" "System.Collections.Immutable.dll"

# ZLinq
DEST="$PROJECT_DIR/Runtime/Cysharp/ZLinq/Runtime"
copy_dll "zlinq" "1.5.6" "$DEST" "ZLinq.dll"

# MasterMemory
DEST="$PROJECT_DIR/Runtime/Cysharp/MasterMemory/Runtime"
copy_dll "mastermemory" "3.0.4" "$DEST" "MasterMemory.dll"
copy_dll "mastermemory.annotations" "3.0.4" "$DEST" "MasterMemory.Annotations.dll"
copy_dll "messagepack" "3.1.3" "$DEST" "MessagePack.dll"
copy_dll "messagepack.annotations" "3.1.3" "$DEST" "MessagePack.Annotations.dll"
copy_dll "microsoft.bcl.asyncinterfaces" "8.0.0" "$DEST" "Microsoft.Bcl.AsyncInterfaces.dll"
copy_dll "microsoft.net.stringtools" "17.11.4" "$DEST" "Microsoft.NET.StringTools.dll"
copy_dll "system.collections.immutable" "8.0.0" "$DEST" "System.Collections.Immutable.dll"
copy_dll "system.memory" "4.5.5" "$DEST" "System.Memory.dll"
copy_dll "system.threading.tasks.extensions" "4.5.4" "$DEST" "System.Threading.Tasks.Extensions.dll"

# ObservableCollections
DEST="$PROJECT_DIR/Runtime/Cysharp/ObservableCollections/Runtime"
copy_dll "observablecollections" "3.3.4" "$DEST" "ObservableCollections.dll"

echo "Concluido."
