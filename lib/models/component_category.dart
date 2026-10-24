/// The five shelves in the catalogue.
enum ComponentCategory {
  buttons('buttons'),
  inputs('inputs'),
  navigation('navigation'),
  display('display'),
  states('states');

  const ComponentCategory(this.id);

  final String id;

  static ComponentCategory? fromId(String? id) {
    for (final category in values) {
      if (category.id == id) return category;
    }
    return null;
  }
}
