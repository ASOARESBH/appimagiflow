# Checklist por módulo

## Antes de criar ou mudar uma tela

- Confirmar a permissão exibida no perfil e a permissão exigida pelo endpoint.
- Confirmar nome, método e envelope da rota em `api-mobile.md` do Context Engine.
- Identificar se a tela é de leitura, escrita, upload, geolocalização ou combinação dessas funções.
- Localizar componente ou serviço reutilizável antes de criar abstração nova.

## Clientes e fornecedores

- Preservar busca por `q`, paginação e status retornado pelo backend.
- Em novos formulários, validar documento e e-mail para orientar o usuário, mas deixar a decisão final de duplicidade no backend.
- Registrar localização apenas se o usuário optar pela ação de campo e o backend permitir.

## Financeiro e contratos

- Não fazer cálculos financeiros autoritativos no cliente.
- Exibir valores e status enviados pelo servidor; confirmar baixa ou mudança de status antes de POST.
- Não habilitar operações de escrita sem a permissão específica retornada no perfil.

## CRM, RDV e manutenção

- Manter campos de observação, datas e status em formato que o backend aceite.
- Para despesas e comprovantes, aceitar somente formatos aprovados pelo backend e usar upload multipart.
- Solicitar localização no momento de registrar visita, interação ou despesa, nunca ao abrir a tela.

## Perfil, notificações e dispositivos

- Alterações de senha exigem confirmação e senha atual quando o endpoint pedir.
- Nunca apresentar token de push ou token de API no UI.
- Logout sempre deve limpar a sessão local mesmo se a chamada remota falhar.
