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
// 'Gruvbox Dark',
// 'Gruvbox Light',
// 'Nord',
// 'Solarized Dark',
// 'Solarized Light',
// 'Spacegray',

class PredefinedTheme {
  static Map<String, EditorTheme> themes = {
    'Default': const EditorTheme(
      colors: {
        EditorComponent.dataType: Color.fromARGB(255, 255, 0, 255),
        EditorComponent.invalidKeyword: Color.fromARGB(255, 255, 0, 0),
        EditorComponent.keyword: Color.fromARGB(255, 0, 0, 255),
        EditorComponent.remark: Color.fromARGB(255, 0, 128, 0),
        EditorComponent.string: Color.fromARGB(255, 255, 0, 255),
        EditorComponent.printPageBoundaries: Color.fromARGB(255, 0, 128, 0),
        EditorComponent.lineModificationChange: Color.fromARGB(255, 255, 255, 0),
        EditorComponent.lineModificationSave: Color.fromARGB(255, 0, 128, 0),
        EditorComponent.bracesHighlight: Color.fromARGB(255, 255, 255, 0),
        EditorComponent.hypertextUrlHighlight: Color.fromARGB(255, 0, 0, 255),
        EditorComponent.codeSnippets: Color.fromARGB(255, 180, 228, 180),
        EditorComponent.columnIndentation: Color.fromARGB(255, 211, 211, 211),
        EditorComponent.includeFiles: Color.fromARGB(255, 128, 0, 0),
      }),
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
        EditorComponent.operator: Color(0xFFFF79C6),
        EditorComponent.number: Color(0xFFF8F8F2),
        EditorComponent.includeFiles: Color(0xFFFFB86C),
        EditorComponent.bracesHighlight: Color(0xFFFF79C6),
      }),
    'Monokai': const EditorTheme(
      foregroundColor: Color(0xFFF8F8F2),
      backgroundColor: Color(0xFF282828),
      selectedBackgroundColor: Color(0xFF49483E),
      colors: {
        EditorComponent.remark: Color(0xFF75715E),
        EditorComponent.keyword: Color(0xFFF92672),
        EditorComponent.string: Color(0xFFE6DB74),
        EditorComponent.dataType: Color(0xFF66D9EF),
        EditorComponent.name: Color(0xFFA6E22E),
        EditorComponent.operator: Color(0xFFF8F8F2),
        EditorComponent.number: Color(0xFFF8F8F2),
        EditorComponent.includeFiles: Color(0xFFF8F8F2),
        EditorComponent.bracesHighlight: Color(0xFF49483E),
      }),
    'Tokyo Night': const EditorTheme(
      foregroundColor: Color(0xFFa9b1d6),
      backgroundColor: Color(0xFF1a1b26),
      selectedBackgroundColor: Color(0xFF5c7e40),
      colors: {
        EditorComponent.remark: Color(0xFF444b6a),
        EditorComponent.keyword: Color(0xFF89ddff),
        EditorComponent.string: Color(0xFF9ece6a),
        EditorComponent.dataType: Color(0xFFbb9af7),
        EditorComponent.name: Color(0xFFc0caf5),
        EditorComponent.operator: Color(0xFF89ddff),
        EditorComponent.number: Color(0xFFff9e64),
        EditorComponent.includeFiles: Color(0xFF7dcfff),
        EditorComponent.bracesHighlight: Color(0xFF698cd6),
      }
    )
  };
}

class EditorThemeUtils {
  static Color toColor(XmlElement xmlElement) {
    var red = int.parse(xmlElement.getAttribute('Red') ?? '0');
    var green = int.parse(xmlElement.getAttribute('Green') ?? '0');
    var blue = int.parse(xmlElement.getAttribute('Blue') ?? '0');
    return Color.fromARGB(255, red, green, blue);
  }

  static void setColor(XmlElement xmlElement, Color color) {
    xmlElement.setAttribute('Red', color.red.toString());
    xmlElement.setAttribute('Green', color.green.toString());
    xmlElement.setAttribute('Blue', color.blue.toString());
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
    final textEditorNode = categoryNodes.firstWhere(
            (element) => (element.getAttribute('Name') == 'TextEditor')
    );

    for (var child in textEditorNode.children) {
      if (child is XmlElement) {
        if (child.name.local == 'Font') {
          font = child.getAttribute('Name') ?? 'Courier';
        } else if (child.name.local == 'BackColor') {
          backgroundColor = toColor(child);
        } else if (child.name.local == 'MonitorBackColor') {
          monitorBackgroundColor = toColor(child);
        } else if (child.name.local == 'SelectionBackColor') {
          selectedBackgroundColor = toColor(child);
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

  static void toEditorSet(EditorTheme theme, File editorSet) {
    // Make a backup of the file
    editorSet.copy(editorSet.path + '.bak');

    final document = XmlDocument.parse(editorSet.readAsStringSync());
    final categoryNodes = document.findAllElements('Category');
    final textEditorNode = categoryNodes.firstWhere(
            (element) => (element.getAttribute('Name') == 'TextEditor')
    );

    // TODO: Need to add background/monitor/selection/font if they don't already exist
    for (var child in textEditorNode.children) {
      if (child is XmlElement) {
        if (child.name.local == 'Font') {
          child.setAttribute('Name', theme.font);
        } else if (child.name.local == 'BackColor') {
          setColor(child, theme.backgroundColor);
        } else if (child.name.local == 'MonitorBackColor') {
          setColor(child, theme.monitorBackgroundColor);
        } else if (child.name.local == 'SelectionBackColor') {
          setColor(child, theme.selectedBackgroundColor);
        } else if (child.name.local == 'Items') {
          for (var item in child.children) {
            if (item is XmlElement && item.name.local == 'Item') {
              var elementType = item.getAttribute('Name');
              var foreColor = item.getElement('ForeColor');
              if (foreColor == null) {
                foreColor = XmlElement(XmlName('ForeColor'));
                item.children.add(foreColor);
              }
              switch (elementType) {
                case 'DataType': setColor(foreColor, theme.getColor(EditorComponent.dataType)); break;
                case 'Number': setColor(foreColor, theme.getColor(EditorComponent.number)); break;
                case 'InvalidKeyword': setColor(foreColor, theme.getColor(EditorComponent.invalidKeyword)); break;
                case 'Keyword': setColor(foreColor, theme.getColor(EditorComponent.keyword)); break;
                case 'Name': setColor(foreColor, theme.getColor(EditorComponent.name)); break;
                case 'Remark': setColor(foreColor, theme.getColor(EditorComponent.remark)); break;
                case 'String': setColor(foreColor, theme.getColor(EditorComponent.string)); break;
                case 'Text': setColor(foreColor, theme.getColor(EditorComponent.text)); break;
                case 'TextSelection': setColor(foreColor, theme.selectedBackgroundColor); break;
                case 'Operator': setColor(foreColor, theme.getColor(EditorComponent.operator)); break;
                case 'Linenumber': setColor(foreColor, theme.getColor(EditorComponent.lineNumber)); break;
                case 'PrintPageBoundaries': setColor(foreColor, theme.getColor(EditorComponent.printPageBoundaries)); break;
                case 'LineModificatorChange': setColor(foreColor, theme.getColor(EditorComponent.lineModificationChange)); break;
                case 'LineModificatorSave': setColor(foreColor, theme.getColor(EditorComponent.lineModificationSave)); break;
                case 'BracesHighlight': setColor(foreColor, theme.getColor(EditorComponent.bracesHighlight)); break;
                case 'HypertextUrlHighlight': setColor(foreColor, theme.getColor(EditorComponent.hypertextUrlHighlight)); break;
                case 'CodeSnippets': setColor(foreColor, theme.getColor(EditorComponent.codeSnippets)); break;
                case 'ColumnIndentation': setColor(foreColor, theme.getColor(EditorComponent.columnIndentation)); break;
                case 'IncludeFiles': setColor(foreColor, theme.getColor(EditorComponent.includeFiles)); break;
                default: break;
              }
            }
          }
        }
      }
    }

    editorSet.writeAsString(document.toXmlString(pretty: true));
  }
}
