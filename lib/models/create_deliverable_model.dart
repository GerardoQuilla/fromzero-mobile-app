enum DeliverableState { PENDIENTE, ESPERANDO_REVISION, RECHAZADO, COMPLETADO }

class CreateDeliverableData {
  String _name;
  String _description;
  DateTime _date;
  int _projectId;

  CreateDeliverableData({
    String name = "",
    String description = "",
    DateTime? date,
    int projectId = 0,
  })  : _name = name,
        _description = description,
        _date = date ?? DateTime.now(),
        _projectId = projectId;

  int get projectId => _projectId;

  set projectId(int value) {
    _projectId = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
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
