class Filter {
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
}

final List<Filter> dummyFilters = [
  Filter('0', 'Random', true),
  Filter('1', 'Teman Dekat', true),
  Filter('2', 'Pasangan', true),
  Filter('3', 'Baru Kenal', true),
  Filter('4', 'Karir', true),
  Filter('5', 'Hobi', true),
];
