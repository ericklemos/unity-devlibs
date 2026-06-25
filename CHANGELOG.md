# Changelog

## [Nao lancado]

### Corrigido
- Dependencias transitivas ausentes que impediam carregamento de DLLs ao importar o pacote em outro projeto:
  - `Microsoft.Bcl.AsyncInterfaces.dll` adicionada a `Runtime/Cysharp/R3/Runtime/` e referenciada em `R3.Unity.asmdef` (resolve erro CS0012 de `IAsyncDisposable` em `UnityTimeProvider.cs`).
  - `System.Collections.Immutable.dll` adicionada a `Runtime/Cysharp/MemoryPack/Runtime/` e referenciada em `MemoryPack.Unity.asmdef` (resolve falha ao carregar `MemoryPack.Core.dll`).
- `tools/validate-wrapper.py` passa a reportar DLLs compartilhadas entre asmdefs diferentes como aviso, nao erro, pois o Unity exige que cada `.asmdef` carregue suas dependencias no proprio diretorio.

### Alterado
- `tools/copy-resolved-dlls.sh` atualizado para copiar `Microsoft.Bcl.AsyncInterfaces.dll` (R3) e `System.Collections.Immutable.dll` (MemoryPack) em builds futuros.

## [1.0.0] - 2026-06-24

### Adicionado
- Wrapper UPM privado e autocontido para Unity 6.3 LTS.
- Bibliotecas Cysharp incluidas:
  - MasterMemory 3.0.4
  - MemoryPack 1.21.4
  - MessagePipe 1.8.2
  - MessagePipe.Interprocess 1.8.2
  - MessagePipe.VContainer 1.8.2
  - NativeMemoryArray 1.2.2
  - ObservableCollections 3.3.4
  - R3 1.3.1
  - UniTask 2.5.11
  - ZLinq 1.5.6
  - ZString 2.6.0
- VContainer 1.16.2.
- DLLs compartilhadas centralizadas em `Runtime/Shared/Plugins/` para evitar duplicatas:
  - System.Buffers 4.5.1
  - System.Memory 4.5.5
  - System.Runtime.CompilerServices.Unsafe 6.1.2
- Scripts utilitarios em `tools/` para download e extracao das libs.

### Decisoes
- Pacote adicionado localmente via **Add package from disk**.
- Integracoes opcionais que dependem de pacotes nao-garantidos foram removidas por padrao (Addressables, DOTween, TextMeshPro, XRInteractionToolkit).
- VContainer mantido em 1.16.2 porque versoes mais recentes nao disponibilizam `.unitypackage` oficial.

### Pendente
- Assinatura do pacote para evitar `missing signing` no Unity 6.3 LTS.
- Testes de compilacao e Play Mode no Unity 6.3 LTS.
