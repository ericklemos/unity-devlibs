# unity-devlibs

Wrapper UPM privado para **Unity 6.3 LTS** contendo as bibliotecas **Cysharp** e **VContainer**, pré-configuradas para consumo local sem gambiarras.

> Um único pacote. Zero UPM CLI. Zero NuGet.

---

## O problema

Para usar as bibliotecas da Cysharp (`UniTask`, `R3`, `MemoryPack`, etc.) junto com `VContainer` hoje, cada projeto precisa:

1. Instalar bibliotecas via **UPM CLI** (pacotes que nem sempre são UPM puros).
2. Resolver dependências transitivas via **NuGet** (conflicts de versão, assemblies duplicados).
3. Configurar scopes e registries diferentes para cada lib.
4. Lidar com o erro **`missing signing`** ao abrir o projeto no **Unity 6.3 LTS**.

Resultado: cada projeto resolve do seu jeito, com uma porcalhada de scripts, workarounds e inconsistência.

## A solução

`unity-devlibs` empacota tudo em um único pacote UPM:

- Todas as libs Cysharp + VContainer em um ponto só de dependência.
- Conflitos de assembly e versão resolvidos uma vez.
- Pacote assinado para ser compatível com Unity 6.3 LTS.
- Consumo local via **Add package from disk** — nada exposto publicamente.

## Objetivos

1. **Eliminar UPM CLI e NuGet** do fluxo de instalação dessas libs.
2. **Centralizar** todas as dependências em um único pacote privado.
3. Garantir **compatibilidade com Unity 6.3 LTS** (incluindo assinatura do pacote).
4. Permitir que qualquer projeto interno consuma as libs **prontas para uso**.
5. Facilitar **atualizações em lote** — atualiza o wrapper e todos os projetos herdam.

## Versão do Unity

- **Unity 6.3 LTS**

## Bibliotecas Incluídas

| Lib | Origem | Propósito |
| --- | --- | --- |
| MasterMemory | Cysharp | Banco de dados em memória embutido |
| MemoryPack | Cysharp | Serializador binário de alta performance |
| MessagePipe | Cysharp | Message broker in-process / pub-sub |
| MessagePipe.Interprocess | Cysharp | Comunicação entre processos via MessagePipe |
| MessagePipe.VContainer | Cysharp | Integração MessagePipe + VContainer DI |
| NativeMemoryArray | Cysharp | Coleções nativas de memória não gerenciada |
| ObservableCollections | Cysharp | Coleções observáveis com notificações de alteração |
| R3 | Cysharp | Biblioteca de reactive programming |
| UniTask | Cysharp | Async/await sem alocação para Unity |
| ZLinq | Cysharp | LINQ de zero alocação / alta performance |
| ZString | Cysharp | String builder / interpolation sem alocação |
| VContainer | hadashiA/VContainer | Container de injeção de dependência leve |

## Como Usar

1. Clone este repositório em sua máquina.
2. No Unity, abra **Window → Package Manager**.
3. Clique em **+** → **Add package from disk...**
4. Selecione o arquivo `package.json` deste repositório.
5. O Unity importará todas as bibliotecas incluídas automaticamente.

> O pacote é **privado** e nunca deve ser publicado. Use sempre via clone local.

## Assinatura

A assinatura do pacote é o próximo passo a ser executado no **Unity 6.3 LTS** com um certificado válido. O conteúdo do wrapper já está preparado; após a assinatura, o erro `missing signing` não aparecerá.

## Estrutura Interna

- `package.json` — manifesto do wrapper.
- `Runtime/Cysharp/` — bibliotecas Cysharp empacotadas.
- `Runtime/VContainer/` — VContainer empacotado.
- `Runtime/Shared/` — DLLs compartilhadas entre libs (MessagePack, System.Memory, Unsafe, etc.).
- `Runtime/.../*.asmdef` — assembly definitions organizadas por lib.

## Versionamento

Seguimos [Semantic Versioning](https://semver.org/lang/pt-BR/). Acompanhe as versões das libs internas no `CHANGELOG.md`.

## Status

- **Pronto para uso:** todas as 12 libs importadas, conflitos de DLL resolvidos, `.asmdef` e `.meta` configurados.
- **Pendente:** assinatura do pacote e testes finais de compilação/Play Mode no Unity 6.3 LTS.
- Pacote adicionado localmente via **Add package from disk** no Unity Package Manager.
- Veja `DELIVERY.md` para o plano completo e `VERSIONS.md` para as versões exatas das libs.
