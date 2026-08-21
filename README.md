# ImagiFlow Mobile

O repositório contém o cliente **Flutter** do ERP ImagiFlow para Android e iOS. O aplicativo usa uma URL própria por empresa, autenticação por token Bearer, segundo fator, armazenamento seguro, biometria local opcional, permissões de módulo e geolocalização apenas em ações de campo consentidas.

## Pronto para Android Studio

Os diretórios nativos `android/` e `ios/` já estão versionados. No Android, o projeto possui Gradle Wrapper, namespace e identificador `br.com.imagiflow.app`, atividade compatível com biometria (`FlutterFragmentActivity`) e permissões declaradas para localização, câmera e imagens.

> Para teste local, abra **a raiz deste repositório** no Android Studio — não abra apenas a pasta `android/`. Instale os plugins **Flutter** e **Dart** quando solicitado.

| Requisito | Configuração no Android Studio |
|---|---|
| Flutter SDK | Em **Settings → Languages & Frameworks → Flutter**, selecione a pasta do SDK Flutter. |
| Android SDK | Em **Settings → Android SDK**, instale uma plataforma Android recente, Build Tools, Platform Tools e Emulator. |
| Emulador | Em **Device Manager**, crie um dispositivo virtual com Google APIs e inicie-o. |
| Dependências | Execute `flutter pub get` pelo terminal integrado ou aguarde a sincronização Flutter. |
| Execução | Selecione o emulador e clique em **Run**; alternativamente, execute `flutter run`. |

## Atualizar o Flutter no Windows

Na raiz do repositório, execute o script versionado abaixo pelo PowerShell. Ele confirma a instalação, seleciona o canal estável, atualiza o SDK e exibe o diagnóstico do ambiente.

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\update-flutter.ps1
```

Para também limpar o projeto, restaurar as dependências e executar a análise estática, use:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\update-flutter.ps1 -RefreshProject
```

## Verificações antes do primeiro teste

Na raiz do projeto, execute:

```bash
flutter analyze
flutter test
flutter run
```

Para validar a geração do pacote Android de depuração, execute:

```bash
flutter build apk --debug
```

O APK será gerado em `build/app/outputs/flutter-apk/app-debug.apk`.

## Permissões móveis

A solicitação de localização é pontual: o aplicativo não configura rastreamento contínuo nem acesso em segundo plano.

| Plataforma | Arquivo | Permissões configuradas ou necessárias |
|---|---|---|
| Android | `android/app/src/main/AndroidManifest.xml` | `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`, `CAMERA` e `READ_MEDIA_IMAGES`. |
| iOS | `ios/Runner/Info.plist` | Antes de publicar iOS, incluir `NSLocationWhenInUseUsageDescription`, `NSCameraUsageDescription` e `NSPhotoLibraryUsageDescription` com textos claros de finalidade. |

## Fluxo de homologação

Ao abrir o aplicativo, use o mesmo e-mail e senha do sistema web. O host compartilhado resolve o vínculo ativo do usuário com a empresa antes de emitir o token móvel. O token de sessão fica apenas em `flutter_secure_storage`; não é salvo em preferências comuns.

Teste obrigatoriamente os fluxos de falha de rede, login inválido, segundo fator, sessão expirada, autorização insuficiente e localização negada. Use uma conta de homologação, sem dados pessoais ou financeiros de produção.

## Módulos entregues

| Área | Integração móvel |
|---|---|
| Autenticação | Login unificado por e-mail e senha, empresa vinculada resolvida pelo backend, recuperação de senha, 2FA, logout e biometria local opcional. |
| Início | KPIs, ações rápidas e módulos filtrados por permissões retornadas pela API. |
| Cadastros | Listagens pesquisáveis de clientes e fornecedores. |
| Financeiro | Listagens de contas a pagar e receber, além de resumo do dashboard. |
| Comercial | Contratos, apurações, leads, oportunidades, propostas e funil. |
| Campo | Ordens de serviço, RDV, despesas e ponto de localização explícito. |
| Perfil | Dados de sessão, biometria, dispositivos, senha, logout e troca de empresa. |

## Contrato da API

Consulte `.claude/skills/appimagiflow-context-engine/references/api-mobile.md` para o resumo de endpoints, envelopes JSON e regras de segurança. O aplicativo trata respostas `401`, `403`, `422` e falhas de conectividade sem interpretar páginas HTML como sucesso.
