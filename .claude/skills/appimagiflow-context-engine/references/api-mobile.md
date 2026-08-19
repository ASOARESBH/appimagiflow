# Contrato da API Mobile ImagiFlow

## Base e envelope

A base é a URL validada da empresa. Todo endpoint móvel começa em `/api/mobile/v1`. Respostas esperadas:

```json
{"success": true, "data": {}}
```

Erros usam:

```json
{"success": false, "message": "Descrição", "errors": {"campo": ["mensagem"]}}
```

O cliente `ImagiFlowApiClient` converte a segunda forma em `ApiFailure`. Não duplicar essa conversão dentro das telas.

## Autenticação

| Rota | Método | Token | Finalidade |
|---|---|---|---|
| `/tenant/ping` | GET | Não | Validar o domínio da empresa. |
| `/login` | POST | Não | E-mail e senha; pode retornar desafio 2FA. |
| `/2fa/verify` | POST | Não | Confirmar `challenge_token` e código de quatro dígitos. |
| `/2fa/resend` | POST | Não | Reenviar código do desafio pendente. |
| `/forgot-password` | POST | Não | Solicitar recuperação sem enumerar usuários. |
| `/logout` | POST | Sim | Revogar a sessão atual. |
| `/perfil/me` | GET | Sim | Ler perfil, tenant e permissões. |

## Endpoints por domínio

| Domínio | Prefixo |
|---|---|
| Dashboard e busca | `/dashboard/resumo`, `/busca` |
| Clientes | `/clientes` |
| Fornecedores | `/fornecedores` |
| Financeiro | `/financeiro/contas-pagar`, `/financeiro/contas-receber`, `/financeiro/resumo` |
| Contratos e apuração | `/contratos`, `/apuracao/{cliente|prestador}` |
| CRM | `/crm/leads`, `/crm/oportunidades`, `/crm/funil`, `/crm/propostas`, `/crm/interacoes` |
| Manutenção | `/manutencao/ordens` |
| RDV | `/rdv/viagens`, `/rdv/despesas` |
| Localização | `/localizacoes`, `/localizacoes/equipe` |
| Notificações | `/notificacoes` |

## Regras para chamadas novas

1. Informar `authenticated: false` somente em endpoints públicos de autenticação.
2. Usar `get`, `post` ou `upload` do cliente em vez de instanciar `Dio` em telas.
3. Enviar JSON para dados comuns e `FormData` para fotos ou comprovantes.
4. Enviar `page`, `per_page` e `q` em listagens que suportarem paginação e pesquisa.
5. Interpretar `403` como bloqueio de acesso, não como lista vazia.
6. Não reenviar automaticamente operações de escrita após timeout sem mecanismo de idempotência.
