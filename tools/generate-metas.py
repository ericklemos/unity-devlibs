#!/usr/bin/env python3
"""
Gera arquivos .meta faltantes para pastas e arquivos do pacote UPM.
Guid deterministico baseado no caminho relativo (para estabilidade entre builds),
mas unico dentro do projeto.
"""

import os
import sys
import hashlib
import uuid

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

FOLDER_META = """fileFormatVersion: 2
guid: {guid}
folderAsset: yes
DefaultImporter:
  externalObjects: {{}}
"""

FILE_META = """fileFormatVersion: 2
guid: {guid}
MonoImporter:
  externalObjects: {{}}
  serializedVersion: 2
  defaultReferences: []
  executionOrder: 0
  widget: {{fileID: 0}}
"""

# Arquivos que nao precisam de meta (ja sao metas ou arquivos ocultos)
SKIP_EXTENSIONS = {".meta"}
SKIP_NAMES = {".git", ".gitignore", ".DS_Store"}


def guid_for_path(rel_path: str) -> str:
    # Deterministico mas unico o suficiente para um projeto
    h = hashlib.sha1(rel_path.encode("utf-8")).digest()
    # Formato do guid do Unity: 32 hex digitos
    return h.hex()[:32]


def generate_metas(root: str):
    for dirpath, dirnames, filenames in os.walk(root):
        rel_dir = os.path.relpath(dirpath, PROJECT_DIR)
        if rel_dir.startswith("packages"):
            continue

        # Pasta
        meta_path = dirpath + ".meta"
        if not os.path.exists(meta_path):
            with open(meta_path, "w", encoding="utf-8") as f:
                f.write(FOLDER_META.format(guid=guid_for_path(rel_dir + "/")))
            print(f"Criado {meta_path}")

        for filename in filenames:
            if filename in SKIP_NAMES:
                continue
            ext = os.path.splitext(filename)[1].lower()
            if ext in SKIP_EXTENSIONS:
                continue

            file_path = os.path.join(dirpath, filename)
            file_meta_path = file_path + ".meta"
            if os.path.exists(file_meta_path):
                continue

            rel_file = os.path.relpath(file_path, PROJECT_DIR)
            with open(file_meta_path, "w", encoding="utf-8") as f:
                f.write(FILE_META.format(guid=guid_for_path(rel_file)))
            print(f"Criado {file_meta_path}")


if __name__ == "__main__":
    target = os.path.join(PROJECT_DIR, "Runtime")
    generate_metas(target)

    # Meta para arquivos na raiz do pacote
    for filename in os.listdir(PROJECT_DIR):
        if filename in SKIP_NAMES:
            continue
        ext = os.path.splitext(filename)[1].lower()
        if ext in SKIP_EXTENSIONS:
            continue
        if os.path.isdir(os.path.join(PROJECT_DIR, filename)):
            continue
        file_path = os.path.join(PROJECT_DIR, filename)
        file_meta_path = file_path + ".meta"
        if os.path.exists(file_meta_path):
            continue
        rel_file = os.path.relpath(file_path, PROJECT_DIR)
        with open(file_meta_path, "w", encoding="utf-8") as f:
            f.write(FILE_META.format(guid=guid_for_path(rel_file)))
        print(f"Criado {file_meta_path}")

    target = os.path.join(PROJECT_DIR, "Documentation~")
    if os.path.exists(target):
        generate_metas(target)
    print("Concluido.")
