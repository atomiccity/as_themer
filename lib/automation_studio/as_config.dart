import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AutomationStudioConfig {
  String version;
  String editorSetPath;

  AutomationStudioConfig({
    required this.version,
    required this.editorSetPath
  });

  static Future<List<AutomationStudioConfig>> findAutomationStudioVersions() async {
    // Get AS config dir
    var roamingDir = (await getApplicationSupportDirectory()).parent.parent;
    var asDir = Directory(join(roamingDir.path, 'BR'));

    if (!asDir.existsSync()) {
      return List<AutomationStudioConfig>.empty();
    }

    var versions = List<AutomationStudioConfig>.empty(growable: true);

    asDir.list().forEach((element) {
      if (basename(element.path).startsWith('AS')) {
        var editorSet = File(join(element.path, 'Editor.set'));
        if (editorSet.existsSync()) {
          var version = basename(element.path);
          if (version == 'AS410') {
            version = '4.10';
          } else if (version == 'AS49') {
            version = '4.9';
          }
          versions.add(AutomationStudioConfig(version: version, editorSetPath: editorSet.path));
        }
      }
    });

    return versions;
  }
}
