import 'package:as_themer/automation_studio/code_themer_c.dart';
import 'package:as_themer/automation_studio/editor_theme.dart';
import 'package:fluent_ui/fluent_ui.dart';

String sourceCode = '''
#include <bur/plctypes.h>

int main() {
    UDINT length = 256;
    STRING message[5];
    STRING *otherMessage = "Hello, World";
    int i;

    // The braces in this for loop will be highlighted
    for (i = 0; i < sizeof(message); i++) {
        message[i] = 0x00;
    }

    /* Another memory clear */
    brsmemset((UDINT) message, 0x00, sizeof(message));

    return length;
}''';

class CodePreviewC extends StatefulWidget {
  final EditorTheme theme;
  final CodeThemerC themer;

  const CodePreviewC({Key? key, required this.theme, required this.themer}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CodePreviewCState();
}

class _CodePreviewCState extends State<CodePreviewC> {
  var isMonitorMode = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isMonitorMode ? widget.theme.monitorBackground : widget.theme.defaultBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Checkbox(
              content: const Text('Monitor Mode'),
              checked: isMonitorMode,
              onChanged: (checked) {
                setState(() {
                  isMonitorMode = checked ?? false;
                });
              },
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: widget.theme.fontName,
                  fontSize: 14,
                ),
                children: widget.themer.themeSourceCode(sourceCode, monitorMode: isMonitorMode)
              ),
            )
          )
        ],
      )
    );
  }
}