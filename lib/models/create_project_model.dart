enum ProjectType {
  LANDING_PAGE,
  WEB_APPLICATION,
  DESKTOP_APPLICATION,
  MOBILE_APPLICATION
}

enum Languages {
  Javascript,
  Typescript,
  HTML,
  CSS,
  Python,
  PHP,
  Java,
  C_Sharp,
  C_PLUS_PLUS,
  C,
  Kotlin,
  Swift,
  Dart,
  Ruby
}

enum Frameworks {
  Vue_Js,
  Angular,
  React,
  Bootstrap,
  Tailwind_CSS,
  Express,
  Django,
  Flask,
  Laravel,
  Svelte,
  Spring_Boot,
  ASP_NET,
  Flutter,
  Jetpack_Compose,
  React_Native,
  Xamarin,
  Tkinter,
  Qt,
  Swing,
  JavaFX,
  WPF,
  Electron
}

class MethodologyResource {
  String name;
  String description;

  MethodologyResource(this.name, this.description);

  Map<String,dynamic> toJson(){
    return {
      'name':name,
      'description':description
    };
  }
}

enum Currency { PEN, USD }

class CreateProjectData {
  String _name;
  String _description;
  ProjectType _type;
  List<Languages> _languages;
  List<Frameworks> _frameworks;
  double _budget;
  Currency _currency;
  List<MethodologyResource> _methodologies;

  CreateProjectData(
      {String name = "",
      String description = "",
      ProjectType type = ProjectType.LANDING_PAGE,
      List<Languages>? languages,
      List<Frameworks>? frameworks,
      double budget = 0.0,
      Currency currency = Currency.PEN,
      List<MethodologyResource>? methodologies})
      : _name = name,
        _description = description,
        _type = type,
        _languages = languages ?? [],
        _frameworks = frameworks ?? [],
        _budget = budget,
        _currency = currency,
        _methodologies = methodologies ?? [];

  List<MethodologyResource> get methodologies => _methodologies;

  set methodologies(List<MethodologyResource> value) {
    _methodologies = value;
  }

  Currency get currency => _currency;

  set currency(Currency value) {
    _currency = value;
  }

  double get budget => _budget;

  set budget(double value) {
    _budget = value;
  }

  List<Frameworks> get frameworks => _frameworks;

  set frameworks(List<Frameworks> value) {
    _frameworks = value;
  }

  List<Languages> get languages => _languages;

  set languages(List<Languages> value) {
    _languages = value;
  }

  ProjectType get type => _type;

  set type(ProjectType value) {
    _type = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}
