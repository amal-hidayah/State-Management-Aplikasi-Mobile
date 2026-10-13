import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_bookstore/providers/theme_provider.dart';

void main() {
  test('toggleTheme mengganti mode terang dan gelap', () {
    final theme = ThemeProvider();
    expect(theme.isDark, isFalse);
    expect(theme.themeMode, ThemeMode.light);

    var notifications = 0;
    theme.addListener(() => notifications++);

    theme.toggleTheme();
    expect(theme.isDark, isTrue);
    expect(theme.themeMode, ThemeMode.dark);

    theme.toggleTheme();
    expect(theme.isDark, isFalse);
    expect(notifications, 2);
  });
}
