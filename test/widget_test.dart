import 'package:flutter_test/flutter_test.dart';
import 'package:imagiflow_mobile/core/theme/app_theme.dart';

void main() {
  test('cria o tema ImagiFlow com a cor primária institucional', () {
    final theme = buildAppTheme();

    expect(theme.colorScheme.primary, AppColors.primary);
    expect(theme.useMaterial3, isTrue);
  });
}
