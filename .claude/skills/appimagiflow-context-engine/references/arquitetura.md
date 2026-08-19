# Arquitetura do App ImagiFlow

## Estrutura

O aplicativo é Flutter com Material 3 e Riverpod. O código fica em `lib/`; cada domínio de negócio possui uma tela em `lib/features/<dominio>/presentation/`. Não há camada de modelos de domínio separada nesta primeira base: as telas consomem envelopes JSON normalizados pelo cliente HTTP.

| Camada | Responsabilidade |
|---|---|
| `main.dart` | Inicializar `ProviderScope`, restaurar sessão e escolher tenant, login ou dashboard. |
| `core/theme` | Definir os tokens ImagiFlow, Material e componentes visuais globais. |
| `core/storage` | Manter URL, Bearer token, perfil e preferência biométrica em armazenamento seguro. |
| `core/api` | Centralizar base URL, header Bearer, requests Dio e conversão de erro. |
| `core/auth` | Orquestrar validação de empresa, login, desafio 2FA, recuperação de senha, sessão e biometria. |
| `core/location` | Obter posição somente após consentimento e enviar ponto explicitamente. |
| `features/shared` | Reutilizar listagem, pesquisa, atualização e estado de falha. |
| `features/*/presentation` | Apresentar módulos e manter navegação específica de cada domínio. |

## Fluxos principais

### Sessão multiempresa

1. `TenantScreen` coleta um domínio e chama `AuthController.validateTenant`.
2. O controller normaliza a URL e salva somente após validar `GET /api/mobile/v1/tenant/ping`.
3. `LoginScreen` envia credenciais somente para a base validada.
4. Após sucesso, token e perfil são persistidos em `SecureSessionStore`; `main.dart` apresenta o dashboard.
5. `logout(changeTenant: true)` remove também a URL da empresa.

### Autenticação

O login pode retornar `requires_2fa`. Nesse caso, a tela de 2FA recebe um `challenge_token` temporário, envia quatro dígitos ao endpoint de verificação e só então persiste o token Bearer. A biometria não substitui o login remoto: apenas desbloqueia uma sessão já persistida com segurança.

### Módulos

O dashboard lê `profile.permissions` retornado pelo backend. A visibilidade de clientes, fornecedores, financeiro, contratos, CRM, RDV e manutenção deve seguir esse conjunto. O backend continua sendo a autoridade para autorização.

## Alterações com maior risco

- Qualquer ajuste em `SecureSessionStore`, `ImagiFlowApiClient` ou `AuthController` pode quebrar isolamento por empresa e segurança de sessão.
- Qualquer novo endpoint deve ser incluído no cliente, receber tratamento de `ApiFailure` e ter seu contrato documentado em `api-mobile.md`.
- Uma tela de campo que envie localização deve invocar `LocationService` somente após uma ação visível do usuário.
- Não transformar `ResourceListScreen` em ponto de regras de negócio; manter regras específicas no módulo.
