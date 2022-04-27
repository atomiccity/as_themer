import 'package:as_themer/automation_studio/editor_theme.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CodeThemerC {
  final EditorTheme theme;

  CodeThemerC({required this.theme});

  List<TextSpan> themeSourceCode(String code, {bool monitorMode = false}) {
    var spans = List<TextSpan>.empty(growable: true);
    var background = monitorMode ? theme.monitorBackgroundColor : theme.backgroundColor;

    for (var line in code.split('\n')) {
      if (line.startsWith('#include')) {
        spans.add(TextSpan(text: '#include', style: TextStyle(backgroundColor: background, color: theme.getColor(EditorComponent.keyword))));
        var includeFile = line.substring('#include'.length);
        spans.add(TextSpan(text: includeFile, style: TextStyle(backgroundColor: background, color: theme.getColor(EditorComponent.includeFiles))));
      } else {
        var tokens = _readTokens(line);

        for (var t in tokens) {
          if (t == '') continue;

          if (t == ' ') {
            spans.add(
                TextSpan(
                    text: t,
                    style: TextStyle(
                      color: theme.getColor(EditorComponent.name),
                      backgroundColor: background,
                    )
                )
            );
            continue;
          }

          if (_isDataType(t)) {
            spans.add(
                TextSpan(
                    text: t,
                    style: TextStyle(
                      color: theme.getColor(EditorComponent.dataType),
                      backgroundColor: background,
                    )
                )
            );
          } else if (_isKeyword(t)) {
            spans.add(
                TextSpan(
                    text: t,
                    style: TextStyle(
                      color: theme.getColor(EditorComponent.keyword),
                      backgroundColor: background,
                    )
                )
            );
          } else if (_isOperator(t)) {
            spans.add(
              TextSpan(
                text: t,
                style: TextStyle(
                  color: theme.getColor(EditorComponent.operator),
                  backgroundColor: background,
                )
              )
            );
          } else if (_isString(t)) {
            spans.add(
                TextSpan(
                    text: t,
                    style: TextStyle(
                      color: theme.getColor(EditorComponent.string),
                      backgroundColor: background,
                    )
                )
            );
          } else if (_isComment(t)) {
            spans.add(
                TextSpan(
                    text: t,
                    style: TextStyle(
                      color: theme.getColor(EditorComponent.remark),
                      backgroundColor: background,
                    )
                )
            );
          } else if (_isNumber(t)) {
            spans.add(
                TextSpan(
                    text: t,
                    style: TextStyle(
                      color: theme.getColor(EditorComponent.number),
                      backgroundColor: background,
                    )
                )
            );
          } else {
            spans.add(
                TextSpan(
                    text: t,
                    style: TextStyle(
                      color: theme.getColor(EditorComponent.name),
                      backgroundColor: background,
                    )
                )
            );
          }
        }
      }

      // Insert the newline
      spans.add(const TextSpan(text: '\n'));
    }

    return spans;
  }

  List<String> _readTokens(String s) {
    var tokens = List<String>.empty(growable: true);
    String tokenBuffer = '';
    bool inString = false;
    bool inComment = false;
    bool inNumber = false;

    for (var c in s.characters) {
      if (inNumber) {
        if (['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'x'].contains(c)) {
          tokenBuffer += c;
          continue;
        } else {
          tokens.add(tokenBuffer);
          inNumber = false;
          tokenBuffer = '';
        }
      }

      if (inComment) {
        tokenBuffer += c;
      } else if (inString) {
        tokenBuffer += c;
        if (c == '"' || c == "'") {
          tokens.add(tokenBuffer);
          inString = false;
          tokenBuffer = '';
        }
      } else if (c == '"' || c == "'") {
        inString = true;
        tokenBuffer += c;
      } else if (c == ' ') {
        tokens.add(tokenBuffer);
        tokenBuffer = '';
        tokens.add(c);
      } else if (_isOperator(c)) {
        tokens.add(tokenBuffer);
        tokenBuffer = '';
        tokens.add(c);
      } else if (c == '/') {
        inComment = true;
        tokenBuffer = c;
      } else if (['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(c)) {
        inNumber = true;
        tokenBuffer = c;
      } else {
        tokenBuffer += c;
      }
    }

    tokens.add(tokenBuffer);

    return tokens;
  }

  bool _isOperator(String s) {
    // Currently leaving '/' out since it messes with comment parsing
    var operators = [
      '(', ')', '+', '-', '*', '=', '{', '}', '[', ']', ',', ';',
    ];
    return operators.contains(s);
  }

  bool _isKeyword(String s) {
    var keywords = [
      'void',
      'char',
      'int',
      'for',
      'sizeof',
      'return',
    ];
    return keywords.contains(s);
  }

  bool _isDataType(String s) {
    var dataTypes = [
      'UDINT',
      'STRING',
    ];
    return dataTypes.contains(s);
  }

  bool _isString(String s) {
    return (s.startsWith('"') || s.startsWith("'"));
  }

  bool _isComment(String s) {
    return (s.startsWith('//') || s.startsWith('/*'));
  }

  bool _isNumber(String s) {
    return int.tryParse(s) != null;
  }
}
