import 'dart:io';
import 'package:xml/xml.dart';
import 'package:flutter/painting.dart';

enum Component {
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

class EditorTheme {
  static const Color defaultForeground = Color.fromARGB(255, 0, 0, 0);
  Color defaultBackground = const Color.fromARGB(255, 255, 255, 255);
  Color monitorBackground = const Color.fromARGB(255, 227, 227, 227);
  Color selectedBackground = const Color.fromARGB(255, 0, 120, 215);

  Color dataType = const Color.fromARGB(0xFF, 255, 0, 255);
  Color number = defaultForeground;
  Color invalidKeyword = const Color.fromARGB(0xFF, 255, 0, 0);
  Color keyword = const Color.fromARGB(0xFF, 0, 0, 255);
  Color name = defaultForeground;
  Color remark = const Color.fromARGB(0xFF, 0, 128, 0);
  Color string = const Color.fromARGB(0xFF, 255, 0, 255);
  Color text = defaultForeground;
  Color textSelection = defaultForeground;
  Color operator = defaultForeground;
  Color lineNumber = defaultForeground;
  Color printPageBoundaries = const Color.fromARGB(0xFF, 0, 128, 0);
  Color lineModificationChange = const Color.fromARGB(0xFF, 255, 255, 0);
  Color lineModificationSave = const Color.fromARGB(0xFF, 0, 128, 0);
  Color bracesHighlight = const Color.fromARGB(0xFF, 255, 255, 0);
  Color hypertextUrlHighlight = const Color.fromARGB(0xFF, 0, 0, 255);
  Color codeSnippets = const Color.fromARGB(0xFF, 180, 228, 180);
  Color columnIndentation = const Color.fromARGB(0xFF, 211, 211, 211);
  Color includeFiles = const Color.fromARGB(0xFF, 128, 0, 0);

  String? fontName;

  TextSpan createTextSpan(Component component, String text,
      {
        bool isSelected = false,
        bool isMonitorMode = false
      }) {
    Color foreground = defaultForeground;
    Color background = defaultBackground;

    switch (component) {
      case Component.dataType: foreground = dataType; break;
      case Component.number: foreground = number; break;
      case Component.invalidKeyword: foreground = invalidKeyword; break;
      case Component.keyword: foreground = keyword; break;
      case Component.name: foreground = name; break;
      case Component.remark: foreground = remark; break;
      case Component.string: foreground = string; break;
      case Component.text: foreground = this.text; break;
      case Component.operator: foreground = operator; break;
      case Component.lineNumber: foreground = lineNumber; break;
      case Component.printPageBoundaries: foreground = printPageBoundaries; break;
      case Component.lineModificationChange: foreground = lineModificationChange; break;
      case Component.lineModificationSave: foreground = lineModificationSave; break;
      case Component.hypertextUrlHighlight: foreground = hypertextUrlHighlight; break;
      case Component.codeSnippets: foreground = codeSnippets; break;
      case Component.columnIndentation: foreground = columnIndentation; break;
      case Component.includeFiles: foreground = includeFiles; break;
      default: foreground = defaultForeground; break;
    }

    if (isSelected) {
      background = selectedBackground;

      // Best guess at Automation Studios automatic foreground selection
      var c = background.red + background.green + background.blue;

      if (c < ((256 / 2) * 3)) {
        foreground = const Color.fromARGB(255, 255, 255, 255);
      } else {
        foreground = const Color.fromARGB(255, 0, 0, 0);
      }
    } else if (component == Component.bracesHighlight) {
      background = bracesHighlight;
      foreground = defaultForeground;
    } else if (isMonitorMode) {
      background = monitorBackground;
    }

    return TextSpan(
      text: text,
      style: TextStyle(color: foreground, backgroundColor: background),
    );
  }

  static Color toColor(XmlElement xmlElement) {
    var red = int.parse(xmlElement.getAttribute('Red') ?? '0');
    var green = int.parse(xmlElement.getAttribute('Green') ?? '0');
    var blue = int.parse(xmlElement.getAttribute('Blue') ?? '0');
    return Color.fromARGB(255, red, green, blue);
  }

  static EditorTheme fromEditorSet(File editorSet) {
    var theme = EditorTheme();

    final document = XmlDocument.parse(editorSet.readAsStringSync());
    final categoryNodes = document.findAllElements('Category');
    final textEditorNode = categoryNodes.firstWhere((element) =>
      (element.getAttribute('Name') == 'TextEditor'));

    for (var child in textEditorNode.children) {
      if (child is XmlElement) {
        if (child.name.local == 'Font') {
          theme.fontName = child.getAttribute('Name');
        } else if (child.name.local == 'BackColor') {
          theme.defaultBackground = toColor(child);
        } else if (child.name.local == 'Items') {
          for (var item in child.children) {
            if (item is XmlElement && item.name.local == 'Item') {
              var elementType = item.getAttribute('Name');
              var foreColor = item.getElement('ForeColor');
              if (foreColor != null) {
                switch (elementType) {
                  case 'DataType': theme.dataType = toColor(foreColor); break;
                  case 'Number': theme.number = toColor(foreColor); break;
                  case 'InvalidKeyword': theme.invalidKeyword = toColor(foreColor); break;
                  case 'Keyword': theme.keyword = toColor(foreColor); break;
                  case 'Name': theme.name = toColor(foreColor); break;
                  case 'Remark': theme.remark = toColor(foreColor); break;
                  case 'String': theme.string = toColor(foreColor); break;
                  case 'Text': theme.text = toColor(foreColor); break;
                  case 'TextSelection': theme.textSelection = toColor(foreColor); break;
                  case 'Operator': theme.operator = toColor(foreColor); break;
                  case 'Linenumber': theme.lineNumber = toColor(foreColor); break;
                  case 'PrintPageBoundaries': theme.printPageBoundaries = toColor(foreColor); break;
                  case 'LineModificatorChange': theme.lineModificationChange = toColor(foreColor); break;
                  case 'LineModificatorSave': theme.lineModificationSave = toColor(foreColor); break;
                  case 'BracesHighlight': theme.bracesHighlight = toColor(foreColor); break;
                  case 'HypertextUrlHighlight': theme.hypertextUrlHighlight = toColor(foreColor); break;
                  case 'CodeSnippets': theme.codeSnippets = toColor(foreColor); break;
                  case 'ColumnIndentation': theme.columnIndentation = toColor(foreColor); break;
                  case 'IncludeFiles': theme.includeFiles = toColor(foreColor); break;
                  default: break;
                }
              }
            }
          }
        }
      }
    }
    
    return theme;
  }
}
