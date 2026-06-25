# Mapeamento de Versões — unity-devlibs

Arquivo de rastreamento das versões exatas de cada biblioteca incluída no wrapper.

## Versões incluídas na release atual

| Lib | Versão | Origem | DLLs/Scripts em |
|-----|--------|--------|-----------------|
| MasterMemory | 3.0.4 | NuGet | `Runtime/Cysharp/MasterMemory/Runtime/` |
| MemoryPack | 1.21.4 | NuGet + UPM Unity add-on | `Runtime/Cysharp/MemoryPack/Runtime/` |
| MessagePipe | 1.8.2 | `.unitypackage` oficial | `Runtime/Cysharp/MessagePipe/` |
| MessagePipe.Interprocess | 1.8.2 | `.unitypackage` oficial | `Runtime/Cysharp/MessagePipe.Interprocess/` |
| MessagePipe.VContainer | 1.8.2 | `.unitypackage` oficial | `Runtime/Cysharp/MessagePipe.VContainer/` |
| NativeMemoryArray | 1.2.2 | `.unitypackage` oficial | `Runtime/Cysharp/NativeMemoryArray/` |
| ObservableCollections | 3.3.4 | NuGet | `Runtime/Cysharp/ObservableCollections/Runtime/` |
| R3 | 1.3.1 | NuGet + UPM Unity add-on | `Runtime/Cysharp/R3/` |
| UniTask | 2.5.11 | `.unitypackage` oficial | `Runtime/Cysharp/UniTask/` |
| ZLinq | 1.5.6 | NuGet + UPM Unity add-on | `Runtime/Cysharp/ZLinq/` |
| ZString | 2.6.0 | `.unitypackage` oficial | `Runtime/Cysharp/ZString/` |
| VContainer | 1.16.2 | `.unitypackage` oficial | `Runtime/VContainer/` |

## DLLs compartilhadas

Local: `Runtime/Shared/Plugins/`

| DLL | Versão | Origem |
|-----|--------|--------|
| System.Buffers.dll | 4.5.1 | NuGet |
| System.Memory.dll | 4.5.5 | NuGet |
| System.Runtime.CompilerServices.Unsafe.dll | 6.1.2 | NuGet |

## Notas

- VContainer foi mantido em **1.16.2** porque as versoes mais recentes (1.17.0 / 1.18.0) nao disponibilizam `.unitypackage` oficial no GitHub.
- R3, MemoryPack, ZLinq, MasterMemory e ObservableCollections nao tem `.unitypackage` oficial; foram montados a partir de NuGet + UPM add-on (quando existente).
- Integracoes opcionais foram removidas por padrao para evitar dependencias de pacotes externos nao garantidos:
  - R3: removidos `TextMeshPro` e `XRInteractionToolkit`.
  - UniTask: removidos `Addressables`, `DOTween` e `TextMeshPro`.
  - ZString: removidas extensoes `TextMeshPro`.
