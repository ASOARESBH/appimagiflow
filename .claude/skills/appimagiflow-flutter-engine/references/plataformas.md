# Plataformas Android e iOS

## Geração inicial

O repositório contém o código Flutter compartilhado. Quando o SDK Flutter estiver disponível, gerar os projetos nativos com `flutter create --platforms=android,ios .` e baixar dependências com `flutter pub get`. Não versionar diretórios transitórios como `.dart_tool`, `build`, `ios/Pods` ou `android/.gradle`.

## Permissões

| Recurso | Android | iOS | Regra de uso |
|---|---|---|---|
| Localização pontual | `ACCESS_FINE_LOCATION` e `ACCESS_COARSE_LOCATION` | `NSLocationWhenInUseUsageDescription` | Pedir durante a ação de campo; não usar acesso em segundo plano. |
| Foto de perfil ou comprovante | `CAMERA` e mídia conforme versão Android | `NSCameraUsageDescription` e `NSPhotoLibraryUsageDescription` | Explicar o objetivo do arquivo antes de abrir câmera ou galeria. |
| Biometria | Configuração do plugin `local_auth` | Entitlement e texto local quando exigido | Desbloquear sessão local existente, sem guardar biometria. |
| Notificações | Permissão de notificações no Android recente | Autorização de notificações | Registrar push token apenas depois de consentimento explícito. |

## Qualidade de build

Rodar `flutter analyze` e `flutter test` antes de revisar. Para cada plataforma, executar build de homologação em dispositivo ou simulador quando plugins nativos forem alterados. Verificar manualmente recusa de permissão, modo avião, sessão expirada, tenant inválido, biometria indisponível e upload cancelado.
