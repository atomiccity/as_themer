import 'package:as_themer/automation_studio/as_config.dart';
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
  @override
  void initState() {
    windowManager.addListener(this);
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
                    var theme = await showDialog<AutomationStudioConfig?>(
                        context: context,
                        builder: (context) {
                          return SelectVersionDialog(configs: widget.configs);
                        }
                    );
                    setState(() {

                    });
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
