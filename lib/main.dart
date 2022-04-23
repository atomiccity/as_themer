import 'dart:io';

import 'package:as_themer/automation_studio/as_config.dart';
import 'package:as_themer/automation_studio/code_themer_c.dart';
import 'package:as_themer/automation_studio/editor_theme.dart';
import 'package:as_themer/ui/code_preview_c.dart';
import 'package:as_themer/ui/color_selector.dart';
import 'package:as_themer/ui/version_dialog.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async{
    // Hide window title bar
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
  });

  var configs = await AutomationStudioConfig.findAutomationStudioVersions();
  runApp(MyApp(configs: configs));
}

class MyApp extends StatelessWidget {
  final List<AutomationStudioConfig> configs;
  const MyApp({Key? key, required this.configs}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Automation Studio Themer',
      theme: ThemeData(
        accentColor: Colors.blue,
      ),
      home: MyHomePage(title: 'Automation Studio Themer', configs: configs),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<AutomationStudioConfig> configs;
  const MyHomePage({Key? key, required this.title, required this.configs}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  EditorTheme theme = EditorTheme();
  late CodeThemerC themer;

  @override
  void initState() {
    windowManager.addListener(this);
    themer = CodeThemerC(theme: theme);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
          title: DragToMoveArea(
              child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  )
              )
          ),
          automaticallyImplyLeading: false,
          actions: DragToMoveArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [Spacer(), WindowButtons()],
            ),
          )
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CommandBar(
            primaryItems: [
              CommandBarButton(
                  icon: const Icon(FluentIcons.open_file),
                  label: const Text('Load'),
                  onPressed: () async {
                    var config = await showDialog<AutomationStudioConfig?>(
                        context: context,
                        builder: (context) {
                          return SelectVersionDialog(configs: widget.configs);
                        }
                    );
                    if (config != null) {
                      setState(() {
                        theme = EditorTheme.fromEditorSet(
                            File(config.editorSetPath));
                        themer = CodeThemerC(theme: theme);
                      });
                    }
                  }
              ),
              CommandBarButton(
                  icon: const Icon(FluentIcons.save),
                  label: const Text('Save'),
                  onPressed: () {

                  }
              ),
            ],
          ),
          Row(
            children: [
              CodePreviewC(theme: theme, themer: themer),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ColorSelector(
                    name: 'Background',
                    color: theme.defaultBackground,
                    onColorChanged: (color) {
                      setState(() {
                        theme.defaultBackground = color;
                      });
                    }
                  ),
                  ColorSelector(
                      name: 'Monitor\nBackground',
                      color: theme.monitorBackground,
                      onColorChanged: (color) {
                        setState(() {
                          theme.monitorBackground = color;
                        });
                      }
                  ),
                  ColorSelector(
                      name: 'Keyword',
                      color: theme.keyword,
                      onColorChanged: (color) {
                        setState(() {
                          theme.keyword = color;
                        });
                      }
                  ),
                  ColorSelector(
                      name: 'String',
                      color: theme.string,
                      onColorChanged: (color) {
                        setState(() {
                          theme.string = color;
                        });
                      }
                  ),
                  ColorSelector(
                      name: 'Number',
                      color: theme.number,
                      onColorChanged: (color) {
                        setState(() {
                          theme.number = color;
                        });
                      }
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ColorSelector(
                      name: 'Data Types',
                      color: theme.dataType,
                      onColorChanged: (color) {
                        setState(() {
                          theme.dataType = color;
                        });
                      }
                  ),
                  ColorSelector(
                      name: 'Names',
                      color: theme.name,
                      onColorChanged: (color) {
                        setState(() {
                          theme.name = color;
                        });
                      }
                  ),
                  ColorSelector(
                      name: 'Comments',
                      color: theme.remark,
                      onColorChanged: (color) {
                        setState(() {
                          theme.remark = color;
                        });
                      }
                  ),
                  ColorSelector(
                      name: 'Operator',
                      color: theme.operator,
                      onColorChanged: (color) {
                        setState(() {
                          theme.operator = color;
                        });
                      }
                  ),
                  ColorSelector(
                      name: 'Header File',
                      color: theme.includeFiles,
                      onColorChanged: (color) {
                        setState(() {
                          theme.includeFiles = color;
                        });
                      }
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 30,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
