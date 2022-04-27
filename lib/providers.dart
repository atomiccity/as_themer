import 'package:as_themer/automation_studio/editor_theme.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<EditorTheme> {
  ThemeNotifier() : super(const EditorTheme());

  void setTheme(EditorTheme theme) {
    state = theme;
  }

  void setFont(String fontName) {
    state = state.copyWith(font: fontName);
  }

  void setColor(EditorComponent component, Color color) {
    state = state.copyWith(colors: { component: color });
  }

  void setBackground(Color color) {
    state = state.copyWith(backgroundColor: color);
  }

  void setMonitorBackground(Color color) {
    state = state.copyWith(monitorBackgroundColor: color);
  }

  void setSelectedBackground(Color color) {
    state = state.copyWith(selectedBackgroundColor: color);
  }

  void setForeground(Color color) {
    state = state.copyWith(foregroundColor: color);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, EditorTheme>((ref) {
  return ThemeNotifier();
});
