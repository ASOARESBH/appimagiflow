# Instruções para agentes

Antes de investigar ou alterar este repositório, leia `.claude/skills/appimagiflow-context-engine/SKILL.md`. Essa habilidade contém o mapa de arquitetura, o fluxo multiempresa e as referências de API necessárias para entender o aplicativo com segurança.

Para criar ou modificar código Flutter, telas, integrações, uploads, localização, permissões nativas ou testes, leia também `.claude/skills/appimagiflow-flutter-engine/SKILL.md` e a referência específica indicada por ela. A autorização, o isolamento por tenant e as validações de domínio são responsabilidade do backend; o aplicativo não deve contorná-los.

Use `ImagiFlowApiClient`, `SecureSessionStore`, `AuthController` e o tema compartilhado em vez de criar clientes HTTP, persistência de token ou cores paralelas. Antes de qualquer commit, execute as verificações disponíveis no ambiente e nunca versione segredos, tokens, dados pessoais ou artefatos transitórios de build.
