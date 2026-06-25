#!/usr/bin/env python3
"""
Validacao estatica do wrapper UPM.
Verifica JSON dos asmdefs, existencia de DLLs referenciadas e conflitos de nomes.
"""

import json
import os
import sys

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RUNTIME_DIR = os.path.join(PROJECT_DIR, "Runtime")

errors = []
warnings = []

asmdefs = {}
for root, dirs, files in os.walk(RUNTIME_DIR):
    for f in files:
        if f.endswith(".asmdef"):
            path = os.path.join(root, f)
            try:
                with open(path, "r", encoding="utf-8") as fp:
                    data = json.load(fp)
                asmdefs[data.get("name", f)] = {"path": path, "data": data, "dir": root}
            except Exception as e:
                errors.append(f"JSON invalido em {path}: {e}")

# Verifica se todas as referencias de asmdef existem
for name, info in asmdefs.items():
    refs = info["data"].get("references", [])
    for ref in refs:
        if ref not in asmdefs:
            warnings.append(f"{name}.asmdef referencia '{ref}' que nao existe no wrapper")

# Verifica se precompiledReferences existem no mesmo diretorio do asmdef
for name, info in asmdefs.items():
    pre = info["data"].get("precompiledReferences", [])
    for dll in pre:
        dll_path = os.path.join(info["dir"], dll)
        if not os.path.isfile(dll_path):
            errors.append(f"{name}.asmdef: DLL nao encontrada: {dll_path}")

# Verifica duplicatas de DLLs
from collections import defaultdict
dll_names = defaultdict(list)
for root, dirs, files in os.walk(RUNTIME_DIR):
    for f in files:
        if f.endswith(".dll"):
            dll_names[f].append(os.path.join(root, f))

for name, paths in dll_names.items():
    if len(paths) > 1:
        errors.append(f"DLL duplicada: {name} em {paths}")

# Verifica se Shared esta sendo referenciado corretamente
if "Shared" not in asmdefs:
    errors.append("Shared.asmdef nao encontrado")

if errors:
    print("=== ERROS ===")
    for e in errors:
        print(f"ERRO: {e}")

if warnings:
    print("=== AVISOS ===")
    for w in warnings:
        print(f"AVISO: {w}")

if not errors and not warnings:
    print("Validacao concluida: nenhum erro ou aviso encontrado.")
    sys.exit(0)
elif errors:
    sys.exit(1)
else:
    print("Validacao concluida com avisos.")
    sys.exit(0)
