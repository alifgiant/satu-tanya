import 'dart:convert';

final configRemoteUrl =
    'https://raw.githubusercontent.com/buahbatu/satu-tanya/master/data/config.json';

class Config {
  static final key = 'CONFIG';

  final int dbVersion;
  final int appBuildNumber;

  Config(this.dbVersion, this.appBuildNumber);

  Config copyWith({int dbVersion, int appBuildNumber}) {
    return Config(
      dbVersion == null ? this.dbVersion : dbVersion,
      appBuildNumber == null ? this.appBuildNumber : appBuildNumber,
    );
  }

  factory Config.fromJson(Map<String, dynamic> parsedJson) {
    int dbVersion = 1;
    int appBuildNumber = 1;
    if (parsedJson.containsKey('dbVersion'))
      dbVersion = parsedJson['dbVersion'];
    if (parsedJson.containsKey('appBuildNumber'))
      appBuildNumber = parsedJson['appBuildNumber'];
    return Config(dbVersion, appBuildNumber);
  }

  String toJson() {
    return jsonEncode(
      {'dbVersion': dbVersion, 'appBuildNumber': appBuildNumber},
    );
  }
}

final Config dummyConfig = Config(1, 1);
