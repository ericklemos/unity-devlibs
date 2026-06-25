# Documento de Entrega — unity-devlibs

Este documento descreve todos os passos necessários para entregar o wrapper UPM `unity-devlibs`, contendo as bibliotecas Cysharp + VContainer, pronto para consumo local no Unity 6.3 LTS via **Add package from disk**.

---

## 1. Visão Geral da Entrega

| Item | Definição |
|------|-----------|
| Nome do pacote | `com.seuprojeto.devlibs` (substituir pelo nome real da organização) |
| Versão alvo | Unity 6.3 LTS |
| Tipo de pacote | UPM privado, instalado localmente via arquivo `package.json` |
| Escopo | Wrapper contendo: MasterMemory, MemoryPack, MessagePipe, MessagePipe.Interprocess, MessagePipe.VContainer, NativeMemoryArray, ObservableCollections, R3, UniTask, ZLinq, ZString e VContainer |
| Objetivo final | Zero gambiarra com UPM CLI/NuGet, assinatura válida, consumo único via disco |

---

## 2. Pré-requisitos

Antes de começar, garantir que a máquina de build possui:

- [ ] Unity 6.3 LTS instalado (versão exata a ser usada nos projetos consumidores).
- [ ] Editor de texto/IDE para editar `package.json`, `.asmdef` e C#.
- [ ] Acesso às fontes oficiais das libs:
  - Repositórios GitHub da Cysharp.
  - Repositório `hadashiA/VContainer`.
  - Releases UPM/NuGet correspondentes.
- [ ] Certificado/chave de assinatura para UPM (arquivo `.pem` e/ou configuração de assinatura do Unity).
- [ ] Git (para versionamento do wrapper).

---

## 3. Estrutura de Pastas do Pacote

Criar a seguinte estrutura na raiz do repositório:

```
unity-devlibs/
├── package.json                    # Manifesto UPM
├── package.json.meta               # Meta do Unity
├── README.md
├── README.md.meta
├── CHANGELOG.md
├── CHANGELOG.md.meta
├── LICENSE.md                      # Licenças agregadas (se necessário)
├── LICENSE.md.meta
├── Runtime/                        # Código das libs empacotadas
│   ├── Runtime.asmdef              # Assembly principal do wrapper (opcional)
│   ├── Cysharp/
│   │   ├── MasterMemory/
│   │   ├── MemoryPack/
│   │   ├── MessagePipe/
│   │   ├── MessagePipe.Interprocess/
│   │   ├── MessagePipe.VContainer/
│   │   ├── NativeMemoryArray/
│   │   ├── ObservableCollections/
│   │   ├── R3/
│   │   ├── UniTask/
│   │   ├── ZLinq/
│   │   └── ZString/
│   └── VContainer/
│       └── ...
├── Runtime.meta
└── Documentation~/                 # Opcional, para imagens/diagramas
    └── ...
```

> **Nota:** Cada subpasta de lib deve ter seu próprio `.asmdef` e `.asmdef.meta`, preservando os nomes originais sempre que possível.

---

## 4. Coleta das Bibliotecas — Estratégia "Tudo Embutido"

A entrega deve permitir que o usuário simplesmente adicione o wrapper via **Add package from disk**, sem instalar UPM CLI, NuGet, scoped registries ou DLLs adicionais. Por isso, todas as dependências devem estar fisicamente dentro do pacote.

### 4.1 Fontes por lib

| Lib | Fonte preferida | Motivo |
|-----|-----------------|--------|
| UniTask | `.unitypackage` do release oficial | Já inclui runtime + editor + dependências |
| R3 | `.unitypackage` do release oficial | Já inclui runtime + dependências |
| MemoryPack | NuGet core + UPM Unity add-on | Core não tem UPM puro; UPM add-on traz scripts Unity |
| MasterMemory | NuGet / OpenUPM | Não há `.unitypackage` oficial na 3.x; usar DLLs do NuGet + gerador se possível |
| MessagePipe | `.unitypackage` do release oficial | Inclui MessagePipe + subpacotes + dependências |
| MessagePipe.Interprocess | `.unitypackage` do release oficial ou UPM path | Incluir junto com MessagePipe |
| MessagePipe.VContainer | `.unitypackage` do release oficial ou UPM path | Incluir junto com MessagePipe |
| NativeMemoryArray | `.unitypackage` do release oficial | Inclui DLLs `System.Memory`, `System.Buffer`, `System.Runtime.CompilerServices.Unsafe` |
| ObservableCollections | NuGet / OpenUPM | Não há `.unitypackage` oficial; usar DLLs + scripts do NuGet/OpenUPM |
| ZLinq | NuGet core + UPM Unity add-on | Core é NuGet; UPM add-on traz extensões Unity |
| ZString | `.unitypackage` do release oficial | Inclui `System.Runtime.CompilerServices.Unsafe` |
| VContainer | `.unitypackage` do release oficial | Inclui runtime + dependências |

### 4.2 Procedimento por lib

Para libs com `.unitypackage`:

1. Baixar o `.unitypackage` da release oficial compatível com Unity 6.3 LTS.
2. Extrair o conteúdo (`.unitypackage` é um tarball gzip com YAML).
3. Copiar pastas `Runtime/`, `Editor/` e DLLs gerenciadas para `Runtime/Cysharp/<Lib>/` ou `Runtime/VContainer/`.
4. Preservar `.meta` e `.asmdef`.
5. Garantir que todas as DLLs de dependência estejam presentes.

Para libs sem `.unitypackage` (MemoryPack, MasterMemory, ZLinq, ObservableCollections):

1. Baixar o pacote NuGet oficial.
2. Extrair DLLs do diretório `lib/netstandard2.1/` ou `lib/net6.0/` conforme compatibilidade com Unity 6.3 LTS.
3. Baixar o UPM Unity add-on (se existir) para scripts/adaptadores Unity.
4. Copiar DLLs + scripts para `Runtime/Cysharp/<Lib>/`.
5. Criar `.asmdef` e `.meta` adequados.

### 4.3 Verificação por lib

- [ ] `UniTask` — runtime + editor + dependências inclusas.
- [ ] `R3` — runtime + adaptadores Unity + dependências inclusas.
- [ ] `MemoryPack` — DLLs core NuGet + scripts Unity do add-on.
- [ ] `MasterMemory` — DLLs runtime NuGet + gerador (opcional).
- [ ] `MessagePipe` — runtime core + dependências inclusas.
- [ ] `MessagePipe.Interprocess` — runtime + dependências inclusas.
- [ ] `MessagePipe.VContainer` — bridge DI + dependências inclusas.
- [ ] `NativeMemoryArray` — runtime + DLLs `System.Memory`, `System.Buffer`, `System.Runtime.CompilerServices.Unsafe`.
- [ ] `ObservableCollections` — DLLs + scripts.
- [ ] `ZLinq` — DLL core NuGet + scripts Unity do add-on.
- [ ] `ZString` — runtime + `System.Runtime.CompilerServices.Unsafe` incluso.
- [ ] `VContainer` — runtime + dependências inclusas.

---

## 5. Configuração dos Assembly Definitions

Para cada biblioteca:

1. Criar/ajustar o arquivo `.asmdef`:
   - Nome consistente (ex.: `Cysharp.MasterMemory`, `VContainer`, etc.).
   - `autoReferenced: true` apenas se a lib precisar ser referenciada automaticamente.
   - `noEngineReferences: false` (true apenas para libs puramente .NET).
2. Configurar as **referências entre assemblies** conforme dependências reais:
   - `MessagePipe.VContainer` referencia `MessagePipe` e `VContainer`.
   - `MessagePipe.Interprocess` referencia `MessagePipe`.
   - `R3` pode referenciar `UniTask` se houver bridge.
3. Garantir que não existam **nomes duplicados** de assemblies.
4. Adicionar `.asmdef.meta` e `.meta` em todas as pastas.

---

## 6. Configuração do `package.json`

Criar o manifesto principal do pacote:

```json
{
  "name": "com.seuprojeto.devlibs",
  "version": "1.0.0",
  "displayName": "Unity DevLibs",
  "description": "Wrapper UPM privado com Cysharp libs + VContainer para Unity 6.3 LTS.",
  "unity": "6000.3",
  "unityRelease": "0f1",
  "author": {
    "name": "Seu Projeto",
    "email": "dev@seuprojeto.com"
  },
  "keywords": [
    "cysharp",
    "vcontainer",
    "wrapper",
    "unity6"
  ],
  "dependencies": {},
  "samples": [],
  "hideInEditor": false
}
```

### 6.1 Pontos de atenção no `package.json`

- `unity`: deve ser `6000.3` para Unity 6.3 LTS.
- Não declarar dependências externas no `dependencies` se tudo está embutido no wrapper.
- Se alguma lib exigir `scoped registry`, embutir o conteúdo, não a referência.

---

## 7. Resolução de Conflitos e Dependências

Durante o empacotamento, verificar e resolver:

1. **Conflitos de versão de assembly** — manter apenas uma versão de cada dependência compartilhada.
2. **DLLs duplicadas** — remover duplicatas (ex.: `System.Runtime.CompilerServices.Unsafe`, `System.Memory`, etc.).
3. **Incompatibilidade de namespace** — ajustar namespaces conflitantes apenas se absolutamente necessário.
4. **Scripts de editor vs runtime** — mover scripts de editor para `Editor/` com `EditorOnly` platforms.
5. **Plataformas suportadas** — ajustar `.meta` de DLLs nativas se houver.

---

## 8. Assinatura do Pacote

O Unity 6.3 LTS exige assinatura para evitar `missing signing`.

### 8.1 Gerar/validar certificado

1. Obter ou gerar o certificado PEM da organização.
2. Certificar-se de que a chave privada está disponível apenas na máquina de build.
3. Validar a cadeia de confiança no Unity.

### 8.2 Assinar o pacote

Opções:

- **A) Via Unity Editor:**
  - `Window → Package Manager → ... → Sign Package` (se disponível na versão).
- **B) Via linha de comando:**
  - Usar ferramenta de assinatura do Unity (`upm-pkgutil` ou script de CI, se disponível).
- **C) Via CI/CD:**
  - Pipeline que assina o pacote automaticamente após o build.

### 8.3 Verificação

- [ ] Abrir o pacote no Unity 6.3 LTS.
- [ ] Confirmar que não aparece o warning `missing signing`.
- [ ] Confirmar que o pacote aparece como assinado no Package Manager.

---

## 9. Testes no Unity 6.3 LTS

Criar um projeto Unity vazio para validação:

1. Criar novo projeto 3D/URP no Unity 6.3 LTS.
2. Adicionar o wrapper via **Package Manager → + → Add package from disk**.
3. Selecionar o `package.json` do `unity-devlibs`.
4. Aguardar importação completa.
5. Verificar **Console** por erros de compilação.
6. Verificar **Package Manager** por conflitos de versão.
7. Criar um script de teste simples que use:
   - `UniTask.Delay`
   - `VContainer` registration + resolve
   - `R3` observable
   - `MessagePipe` broker
   - `ZString` concatenação
8. Rodar em Play Mode e confirmar que tudo compila e executa.

### 9.1 Checklist de testes

- [ ] Importação sem erros.
- [ ] Nenhum warning de `missing signing`.
- [ ] Compilação do projeto vazio OK.
- [ ] Scripts de teste compilam.
- [ ] Play Mode executa sem exceções relacionadas às libs.
- [ ] Build para Standalone (Windows/Mac/Linux) funciona.
- [ ] Build para Android/iOS funciona (se aplicável).

---

## 10. Entrega para os Projetos Consumidores

### 10.1 Forma de entrega

Como o pacote é privado e **tudo está incluso**:

1. Obter o repositório `unity-devlibs` (clone local, zip, ou compartilhamento interno).
2. No projeto Unity consumidor:
   - `Window → Package Manager`
   - `+ → Add package from disk...`
   - Navegar até `unity-devlibs/package.json`
   - Confirmar.
3. O Unity importa todas as libs automaticamente.

**Não é necessário:** UPM CLI, NuGet, scoped registries, instalação individual de libs, ou adicionar DLLs manualmente.

### 10.2 Documentação para equipes consumidoras

Fornecer um resumo simples:

```
Para usar as libs Cysharp + VContainer:
1. Obtenha a pasta unity-devlibs (clone/zip).
2. No Unity, Package Manager → + → Add package from disk.
3. Selecione package.json do unity-devlibs.
4. Pronto — todas as libs estão disponíveis, assinadas e sem gambiarras.
```

---

## 11. Versionamento e Atualização

1. Seguir Semantic Versioning (`MAJOR.MINOR.PATCH`).
2. Criar tag Git para cada release (ex.: `v1.0.0`).
3. Atualizar `CHANGELOG.md` com:
   - Versão do wrapper.
   - Versões das libs internas.
   - Correções e mudanças de breaking changes.
4. Para atualizar uma lib:
   - Substituir os arquivos na pasta correspondente.
   - Ajustar `.asmdef` e dependências se necessário.
   - Reassinar o pacote.
   - Testar no projeto de validação.
   - Bump de versão + tag.

---

## 12. Checklist Final de Entrega

- [ ] `package.json` criado e validado.
- [ ] Todas as 12 libs copiadas para `Runtime/`.
- [ ] `.asmdef` e `.meta` criados para cada lib.
- [ ] Conflitos de assembly/DLL resolvidos.
- [ ] Pacote assinado corretamente.
- [ ] Teste no Unity 6.3 LTS concluído sem erros.
- [ ] README.md e CHANGELOG.md atualizados.
- [ ] Instruções de consumo repassadas aos times.
- [ ] Repositório versionado e tag de release criada.

---

## 13. Plano de Execução Imediato

### Fase 1 — Infraestrutura do pacote ✅

- [x] Definir escopo e objetivos.
- [x] Mapear fontes oficiais e caminhos UPM/NuGet.
- [x] Criar `README.md`, `DELIVERY.md`, `CHANGELOG.md`, `VERSIONS.md`.
- [x] Criar `package.json` inicial e metas.
- [x] Criar estrutura de pastas `Runtime/Cysharp/*`, `Runtime/VContainer/` e `Runtime/Shared/`.
- [x] Criar scripts utilitarios em `tools/`.

### Fase 2 — Importação das libs ✅

Todas as 12 libs foram importadas e organizadas:

| Lib | Fonte | Local |
|-----|-------|-------|
| UniTask | `.unitypackage` | `Runtime/Cysharp/UniTask/` |
| VContainer | `.unitypackage` | `Runtime/VContainer/` |
| MessagePipe | `.unitypackage` | `Runtime/Cysharp/MessagePipe/` |
| MessagePipe.Interprocess | `.unitypackage` | `Runtime/Cysharp/MessagePipe.Interprocess/` |
| MessagePipe.VContainer | `.unitypackage` | `Runtime/Cysharp/MessagePipe.VContainer/` |
| ZString | `.unitypackage` | `Runtime/Cysharp/ZString/` |
| NativeMemoryArray | `.unitypackage` | `Runtime/Cysharp/NativeMemoryArray/` |
| R3 | NuGet + UPM add-on | `Runtime/Cysharp/R3/` |
| MemoryPack | NuGet + UPM add-on | `Runtime/Cysharp/MemoryPack/` |
| ZLinq | NuGet + UPM add-on | `Runtime/Cysharp/ZLinq/` |
| MasterMemory | NuGet | `Runtime/Cysharp/MasterMemory/` |
| ObservableCollections | NuGet | `Runtime/Cysharp/ObservableCollections/` |

### Fase 3 — Resolução de conflitos ✅

- [x] DLLs compartilhadas centralizadas em `Runtime/Shared/`:
  - `Runtime/Shared/Plugins/` — `System.Buffers`, `System.Memory`, `System.Runtime.CompilerServices.Unsafe`.
  - `Runtime/Shared/MessagePack/` — `MessagePack`, `MessagePack.Annotations`.
- [x] Todas as referências de `.asmdef` ajustadas.
- [x] Integrações opcionais removidas por padrão (Addressables, DOTween, TextMeshPro, XRInteractionToolkit, ECS).
- [x] Validacao estatica (`tools/validate-wrapper.py`) passando sem erros.

### Fase 4 — Assinatura ⏳

- [ ] Gerar/obter certificado de assinatura UPM.
- [ ] Assinar o pacote no Unity 6.3 LTS.
- [ ] Validar que o Unity 6.3 LTS não exibe `missing signing`.

### Fase 5 — Testes finais ⏳

- [ ] Importar em projeto Unity 6.3 LTS vazio via `Add package from disk`.
- [ ] Compilar sem erros.
- [ ] Criar scripts de smoke-test para cada lib.
- [ ] Rodar Play Mode.
- [ ] Fazer build de pelo menos uma plataforma alvo.

### Fase 6 — Entrega ⏳

- [x] Atualizar `CHANGELOG.md`.
- [ ] Assinar o pacote.
- [ ] Criar tag Git `v1.0.0`.
- [ ] Repassar instruções de uso aos times consumidores.
- [ ] Arquivar certificado e processo de assinatura de forma segura.

---

## 14. Estado Atual do Wrapper

**Versao do pacote:** `1.0.0`

**O que esta pronto:**
- Estrutura UPM completa com todas as 12 libs.
- DLLs compartilhadas centralizadas para evitar conflitos.
- `.meta` gerados para todos os arquivos e pastas.
- `package.json`, `README.md`, `CHANGELOG.md`, `VERSIONS.md` e `DELIVERY.md` atualizados.
- Validacao estatica sem erros.

**O que falta:**
- Assinatura do pacote (requer Unity 6.3 LTS + certificado).
- Testes de compilacao e Play Mode no Unity 6.3 LTS.
