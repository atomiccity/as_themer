import 'dart:io';
import 'package:xml/xml.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

enum EditorComponent {
  dataType,
  number,
  invalidKeyword,
  keyword,
  name,
  remark,
  string,
  text,
  textSelection,
  operator,
  lineNumber,
  printPageBoundaries,
  lineModificationChange,
  lineModificationSave,
  bracesHighlight,
  hypertextUrlHighlight,
  codeSnippets,
  columnIndentation,
  includeFiles,
}

@immutable
class EditorTheme {
  static const Color defaultForegroundColor = Color.fromARGB(255, 0, 0, 0);
  static const Color defaultBackgroundColor = Color.fromARGB(255, 255, 255, 255);
  static const Color defaultSelectedBackgroundColor = Color.fromARGB(255, 0, 0, 255);
  static const Color defaultMonitorBackgroundColor = Color.fromARGB(255, 200, 200, 200);
  static const String defaultFont = 'Courier New';
  final Color foregroundColor;
  final Color backgroundColor;
  final Color selectedBackgroundColor;
  final Color monitorBackgroundColor;
  final Map<EditorComponent, Color> colors;
  final String font;

  const EditorTheme({
    this.foregroundColor = defaultForegroundColor,
    this.backgroundColor = defaultBackgroundColor,
    this.monitorBackgroundColor = defaultMonitorBackgroundColor,
    this.selectedBackgroundColor = defaultSelectedBackgroundColor,
    this.colors = const <EditorComponent, Color>{},
    this.font = defaultFont,
  });

  Color getColor(EditorComponent component) {
    return colors[component] ?? foregroundColor;
  }

  EditorTheme copyWith({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? monitorBackgroundColor,
    Color? selectedBackgroundColor,
    Map<EditorComponent, Color>? colors,
    String? font,
  }) {
    var combinedColors = Map.of(this.colors);
    if (colors != null) {
      for (var c in colors.keys) {
        combinedColors[c] = colors[c] ?? this.foregroundColor;
      }
    }
    return EditorTheme(
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      monitorBackgroundColor: monitorBackgroundColor ?? this.monitorBackgroundColor,
      selectedBackgroundColor: selectedBackgroundColor ?? this.selectedBackgroundColor,
      colors: combinedColors,
      font: font ?? this.font,
    );
  }
}

// Potential pre-defined theme list
// 'Defaults',
// 'Afterglow',
// 'Dracula',
// 'Gruvbox Dark',
// 'Gruvbox Light',
// 'Monokai',
// 'Nord',
// 'Solarized Dark',
// 'Solarized Light',
// 'Spacegray',
// 'Tokyo Night',

class PredefinedTheme {
  static Map<String, EditorTheme> themes = {
    'Dracula': const EditorTheme(
      foregroundColor: Color(0xFFF8F8F2),
      backgroundColor: Color(0xFF282A36),
      selectedBackgroundColor: Color(0xFF44475A),
      colors: {
        EditorComponent.remark: Color(0xFF6272A4),
        EditorComponent.keyword: Color(0xFFFF79C6),
        EditorComponent.string: Color(0xFFF1FA8C),
        EditorComponent.dataType: Color(0xFF8BE9FD),
        EditorComponent.name: Color(0xFFF8F8F2),
      })
  };
}

class EditorThemeUtils {
  static Color toColor(XmlElement xmlElement) {
    var red = int.parse(xmlElement.getAttribute('Red') ?? '0');
    var green = int.parse(xmlElement.getAttribute('Green') ?? '0');
    var blue = int.parse(xmlElement.getAttribute('Blue') ?? '0');
    return Color.fromARGB(255, red, green, blue);
  }

  static EditorTheme fromEditorSet(File editorSet) {
    Color foregroundColor = EditorTheme.defaultForegroundColor;
    Color backgroundColor = EditorTheme.defaultBackgroundColor;
    Color selectedBackgroundColor = EditorTheme.defaultSelectedBackgroundColor;
    Color monitorBackgroundColor = EditorTheme.defaultMonitorBackgroundColor;
    Map<EditorComponent, Color> colors = {};
    String font = EditorTheme.defaultFont;

    final document = XmlDocument.parse(editorSet.readAsStringSync());
    final categoryNodes = document.findAllElements('Category');
    final textEditorNode = categoryNodes.firstWhere((element) =>
    (element.getAttribute('Name') == 'TextEditor'));

    for (var child in textEditorNode.children) {
      if (child is XmlElement) {
        if (child.name.local == 'Font') {
          font = child.getAttribute('Name') ?? 'Courier';
        } else if (child.name.local == 'BackColor') {
          backgroundColor = toColor(child);
        } else if (child.name.local == 'Items') {
          for (var item in child.children) {
            if (item is XmlElement && item.name.local == 'Item') {
              var elementType = item.getAttribute('Name');
              var foreColor = item.getElement('ForeColor');
              if (foreColor != null) {
                switch (elementType) {
                  case 'DataType': colors[EditorComponent.dataType] = toColor(foreColor); break;
                  case 'Number': colors[EditorComponent.number] = toColor(foreColor); break;
                  case 'InvalidKeyword': colors[EditorComponent.invalidKeyword] = toColor(foreColor); break;
                  case 'Keyword': colors[EditorComponent.keyword] = toColor(foreColor); break;
                  case 'Name': colors[EditorComponent.name] = toColor(foreColor); break;
                  case 'Remark': colors[EditorComponent.remark] = toColor(foreColor); break;
                  case 'String': colors[EditorComponent.string] = toColor(foreColor); break;
                  case 'Text': colors[EditorComponent.text] = toColor(foreColor); break;
                  case 'TextSelection': selectedBackgroundColor = toColor(foreColor); break;
                  case 'Operator': colors[EditorComponent.operator] = toColor(foreColor); break;
                  case 'Linenumber': colors[EditorComponent.lineNumber] = toColor(foreColor); break;
                  case 'PrintPageBoundaries': colors[EditorComponent.printPageBoundaries] = toColor(foreColor); break;
                  case 'LineModificatorChange': colors[EditorComponent.lineModificationChange] = toColor(foreColor); break;
                  case 'LineModificatorSave': colors[EditorComponent.lineModificationSave] = toColor(foreColor); break;
                  case 'BracesHighlight': colors[EditorComponent.bracesHighlight] = toColor(foreColor); break;
                  case 'HypertextUrlHighlight': colors[EditorComponent.hypertextUrlHighlight] = toColor(foreColor); break;
                  case 'CodeSnippets': colors[EditorComponent.codeSnippets] = toColor(foreColor); break;
                  case 'ColumnIndentation': colors[EditorComponent.columnIndentation] = toColor(foreColor); break;
                  case 'IncludeFiles': colors[EditorComponent.includeFiles] = toColor(foreColor); break;
                  default: break;
                }
              }
            }
          }
        }
      }
    }

    return EditorTheme(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      selectedBackgroundColor: selectedBackgroundColor,
      monitorBackgroundColor: monitorBackgroundColor,
      colors: colors,
      font: font
    );
  }
}
