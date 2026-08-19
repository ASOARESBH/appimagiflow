---
name: appimagiflow-flutter-engine
description: "Implementação segura do App ImagiFlow Flutter. Use para: criar ou alterar telas, módulos, integrações HTTP, autenticação, upload, localização, estado Riverpod, componentes visuais, testes e preparação de builds Android/iOS."
---

# App ImagiFlow — Flutter Engine

## Pré-condições

1. Acionar `appimagiflow-context-engine` ou ler suas referências antes de mudanças de arquitetura, autenticação ou API.
2. Ler `pubspec.yaml` e o módulo alvo antes de editar.
3. Se alterar endpoint, validar o contrato no backend ImagiFlow antes de criar a tela.
4. Nunca assumir que permissões exibidas no app substituem a autorização do servidor.

## Fluxo de implementação

| Etapa | Ação obrigatória |
|---|---|
| Escopo | Delimitar módulo, fluxo, permissão, endpoint e estados de erro. |
| Reuso | Procurar primeiro `ResourceListScreen`, tema, controller de auth e cliente de API. |
| Dados | Usar `ImagiFlowApiClient`; não instanciar `Dio` fora de `core/api`. |
| Estado | Usar Riverpod para estado compartilhado ou assíncrono; não persistir token fora do armazenamento seguro. |
| Interface | Seguir `AppColors`, `AppRadii`, Material 3 e texto em português do Brasil. |
| Segurança | Validar campos no cliente para UX e no backend para autoridade; não expor dados sensíveis. |
| Validação | Executar `flutter analyze`, testes afetados e build do alvo quando o SDK estiver disponível. |

## Padrões obrigatórios

### Tela de leitura

- Preferir `ResourceListScreen` para listas simples com `q`, `page` e `per_page`.
- Mostrar carregamento, estado vazio e falha recuperável.
- Não ocultar erros `403`; explicar que o perfil não possui acesso.
- Não usar identificadores de outro tenant para filtrar ou formar URLs.

### Escrita e upload

- Usar `api.post` para JSON e `api.upload` com `FormData` para arquivos.
- Desabilitar botão enquanto a operação estiver pendente.
- Mostrar confirmação de sucesso somente após envelope `success: true`.
- Não repetir automaticamente POSTs de gravação ou upload após falhas de rede.
- Para localização, solicitar somente a partir de uma ação explícita e chamar `LocationService`.

### Autenticação

- Não alterar `SecureSessionStore` sem revisar todo o fluxo de restauração em `main.dart` e `AuthController`.
- Manter o fluxo tenant → login → 2FA → token → dashboard.
- Ao receber 401, oferecer novo login; ao receber 403, manter a sessão e explicar a permissão ausente.
- A biometria desbloqueia uma sessão local existente; não deve virar credencial remota ou substituir 2FA.

## Verificação antes do commit

1. Rodar `dart format lib test`.
2. Rodar `flutter analyze` e `flutter test` quando Flutter estiver instalado.
3. Testar manualmente o fluxo alterado com URL de tenant válida, incluindo erro de rede e erro de permissão.
4. Conferir que não há token, URL privada, dados pessoais, log sensível ou segredo no diff.
5. Atualizar `README.md` quando dependência, permissão nativa ou setup de plataforma mudar.

## Referências

- Ler `references/checklist-modulos.md` para roteiro por tipo de alteração.
- Ler `references/plataformas.md` ao mudar câmera, fotos, biometria, localização, push ou builds nativos.
