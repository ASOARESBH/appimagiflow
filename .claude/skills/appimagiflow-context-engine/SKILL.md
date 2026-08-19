---
name: appimagiflow-context-engine
description: "Contexto arquitetural do App ImagiFlow Flutter. Use para: entender rapidamente a estrutura, localizar módulos, analisar autenticação multiempresa, rastrear integrações com a API mobile e avaliar impacto antes de alterar o aplicativo."
---

# App ImagiFlow — Context Engine

## Quando usar

Use antes de investigar bugs, responder dúvidas de arquitetura, localizar uma tela, alterar navegação ou modificar chamadas da API. Leia primeiro `references/arquitetura.md`. Para endpoints e envelopes, leia `references/api-mobile.md`.

## Mapa rápido

| Necessidade | Local prioritário |
|---|---|
| Inicialização e escolha de tela | `lib/main.dart` |
| Cores, componentes e tokens | `lib/core/theme/app_theme.dart` |
| URL da empresa e token local | `lib/core/storage/secure_session_store.dart` |
| HTTP, Bearer e erros de API | `lib/core/api/imagiflow_api_client.dart` |
| Login, 2FA, logout e biometria | `lib/core/auth/auth_controller.dart` |
| Coleta pontual de posição | `lib/core/location/location_service.dart` |
| Dashboard e acesso a módulos | `lib/features/dashboard/presentation/dashboard_screen.dart` |
| Listagens reutilizáveis | `lib/features/shared/resource_list_screen.dart` |
| Cada domínio de negócio | `lib/features/<modulo>/presentation/` |

## Fluxo obrigatório de leitura

1. Ler `pubspec.yaml` para confirmar SDK e pacotes disponíveis.
2. Ler `lib/main.dart` para entender o ponto de entrada e a seleção de estado.
3. Ler o controller ou cliente de API antes de uma tela que faça rede.
4. Seguir os imports locais da tela até identificar o provider, serviço ou componente reutilizado.
5. Consultar o endpoint em `references/api-mobile.md` e verificar a permissão retornada no perfil.
6. Antes de concluir que há bug no app, verificar se o backend pode retornar `401`, `403`, `422` ou envelope diferente.

## Guardrails de segurança

- Nunca gravar token em `SharedPreferences`, arquivos, logs, analytics ou estado persistido comum; usar somente `SecureSessionStore`.
- Nunca aceitar tenant, `tenant_id` ou URL de API fornecidos por uma tela sem passar por `validateTenant`.
- Tratar `401` como sessão expirada e `403` como falta de autorização; não tentar contornar permissões no cliente.
- Considerar a localização como consentimento pontual associado a uma ação de campo; não criar rastreamento contínuo ou em segundo plano.
- Não colocar segredos, chaves de push, credenciais ou dados sensíveis no código, arquivos de ambiente versionados ou mensagens de erro.

## Resultado esperado de uma investigação

Registrar o arquivo analisado, o fluxo afetado, a chamada de API correspondente, a permissão necessária, o impacto no tenant e o teste recomendado. Evitar mudanças amplas quando o ajuste puder ficar isolado no módulo ou componente responsável.
