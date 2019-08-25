import 'dart:convert';

final filtersRemoteUrl =
    'https://raw.githubusercontent.com/alifgiant/satu-tanya/master/data/filters.json';

class Filter {
  static final key = 'FILTER';

  final String id;
  final String name;
  bool isActive;

  Filter(this.id, this.name, this.isActive);

  Filter copyWith({String id, String name, bool isActive}) {
    return Filter(
      id == null ? this.id : id,
      name == null ? this.name : name,
      isActive == null ? this.isActive : isActive,
    );
  }

  factory Filter.fromJson(Map<String, dynamic> parsedJson) {
    return Filter(
      parsedJson['id'],
      parsedJson['name'],
      parsedJson['isActive'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive,
    };
  }

  static String toJsonOfList(List<Filter> filters) {
    return jsonEncode(filters.map((q) => q.toMap()).toList());
  }
}

final List<Filter> dummyFilters = [
  Filter('0', 'Random', true),
  Filter('1', 'Teman Dekat', true),
  Filter('2', 'Pasangan', true),
  Filter('3', 'Baru Kenal', true),
  Filter('4', 'Karir', true),
  Filter('5', 'Hobi', true),
];
