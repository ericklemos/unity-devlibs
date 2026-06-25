# Ferramentas do Wrapper

Scripts utilitarios para montar o pacote `unity-devlibs`.

## `extract-unitypackage.sh`

Extrai um arquivo `.unitypackage` do Unity e reorganiza o conteudo na pasta `Runtime/` do wrapper.

### Requisitos

- Git Bash (Windows) ou qualquer shell Unix.
- `tar` disponivel.

### Uso

```bash
./tools/extract-unitypackage.sh <caminho-do-unitypackage> <nome-da-lib>
```

### Exemplos

```bash
# UniTask
./tools/extract-unitypackage.sh ~/Downloads/UniTask.2.5.11.unitypackage UniTask

# VContainer
./tools/extract-unitypackage.sh ~/Downloads/VContainer.1.18.0.unitypackage VContainer
```

O script colocara os arquivos em:

- `Runtime/Cysharp/UniTask/` para libs Cysharp.
- `Runtime/VContainer/` para VContainer.

### Depois de extrair

1. Verifique se `.asmdef` e `.meta` foram copiados corretamente.
2. Se faltarem `.meta`, abra o wrapper no Unity 6.3 LTS para que os metadados sejam gerados.
3. Atualize `VERSIONS.md` com a versao exata da lib.
4. Execute testes de compilacao no Unity.
