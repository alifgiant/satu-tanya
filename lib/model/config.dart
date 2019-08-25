import 'dart:convert';

final configRemoteUrl =
    'https://raw.githubusercontent.com/alifgiant/satu-tanya/master/data/config.json';

class Config {
  static final key = 'CONFIG';
  
  final int dbVersion;

  Config(this.dbVersion);

  Config copyWith({String dbVersion}) {
    return Config(dbVersion == null ? this.dbVersion : dbVersion);
  }

  factory Config.fromJson(Map<String, dynamic> parsedJson) {
    return Config(parsedJson['dbVersion']);
  }

  String toJson() {
    return jsonEncode({'dbVersion': dbVersion});
  }
}

final Config dummyConfig = Config(1);
