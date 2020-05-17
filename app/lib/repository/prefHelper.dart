import 'dart:convert' as convert;

import 'package:satu_tanya/model/config.dart';
import 'package:satu_tanya/model/filter.dart';
import 'package:satu_tanya/model/question.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  // config pref
  static Future<Config> loadConfigFromDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(Config.key)) {
      final configString = prefs.getString(Config.key);
      final configJson = convert.jsonDecode(configString);
      final config = Config.fromJson(configJson);
      return config;
    }
    return null;
  }

  static Future<void> storeConfigToDB(Config config) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String enconded = config.toJson();
    await prefs.setString(Config.key, enconded);
  }
  // end config

  // filter pref
  static Future<List<Filter>> loadFiltersFromDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(Filter.key)) {
      final filtersString = prefs.getString(Filter.key);
      final filtersJson = convert.jsonDecode(filtersString) as List;
      final filters =
          filtersJson.map((content) => Filter.fromJson(content)).toList();
      return filters;
    }
    return [];
  }

  static Future<void> storeFiltersToDB(List<Filter> filters) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String enconded = Filter.toJsonOfList(filters);
    await prefs.setString(Filter.key, enconded);
  }
  // end filter

  // question pref
  static Future<List<Question>> loadQuestionsFromDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(Question.key)) {
      final questionsString = prefs.getString(Question.key);
      final questionsJson = convert.jsonDecode(questionsString) as List;
      final questions =
          questionsJson.map((content) => Question.fromJson(content)).toList();
      return questions;
    }
    return [];
  }

  static Future<void> storeQuestionsToDB(List<Question> questions) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String enconded = Question.toJsonOfList(questions);
    await prefs.setString(Question.key, enconded);
  }
  // end question

  // ads pref
  static Future<bool> loadAdsState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('ads')) {
      bool shouldShow = prefs.getBool('ads');
      return shouldShow;
    }
    return false;
  }

  static Future<void> storeAdsState(bool shouldShow) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ads', shouldShow);
  }
  // end ads
}
