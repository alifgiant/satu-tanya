import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:satu_tanya/model/config.dart';

import 'package:satu_tanya/model/filter.dart';
import 'package:satu_tanya/model/question.dart';

class RemoteRepoHelper {
  static Future<List<Filter>> getFilters() async {
    final response = await http.get(filtersRemoteUrl);
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body) as List;
      final filters =
          jsonResponse.map((content) => Filter.fromJson(content)).toList();
      return filters;
    } else {
      return null;
    }
  }

  static Future<List<Question>> getQuestions() async {
    final response = await http.get(questionsRemoteUrl);
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body) as List;
      final question =
          jsonResponse.map((content) => Question.fromJson(content)).toList();
      return question;
    } else {
      return null;
    }
  }

  static Future<Config> getRemoteConfig() async {
    final response = await http.get(configRemoteUrl);
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      final config = Config.fromJson(jsonResponse);
      return config;
    } else {
      return null;
    }
  }
}
