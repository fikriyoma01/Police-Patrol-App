class PatrolReport {
  final String id;
  final String officerId;
  final DateTime warrantDateTime;
  final String typeOfPatrol;
  final String natureOfPatrol;
  final bool isFootPatrol;
  final int numberOfPersonnel;
  final String patrolRouteId; 

  PatrolReport({
    required this.id,
    required this.officerId,
    required this.warrantDateTime,
    required this.typeOfPatrol,
    required this.natureOfPatrol,
    required this.isFootPatrol,
    required this.numberOfPersonnel,
    required this.patrolRouteId, 
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'officerId': officerId,
      'warrantDateTime': warrantDateTime.toIso8601String(),
      'typeOfPatrol': typeOfPatrol,
      'natureOfPatrol': natureOfPatrol,
      'isFootPatrol': isFootPatrol,
      'numberOfPersonnel': numberOfPersonnel,
      'patrolRouteId': patrolRouteId, 
    };
  }

  static PatrolReport fromMap(Map<String, dynamic> map) {
    return PatrolReport(
      id: map['id'],
      officerId: map['officerId'],
      warrantDateTime: DateTime.parse(map['warrantDateTime']),
      typeOfPatrol: map['typeOfPatrol'],
      natureOfPatrol: map['natureOfPatrol'],
      isFootPatrol: map['isFootPatrol'],
      numberOfPersonnel: map['numberOfPersonnel'],
      patrolRouteId: map['patrolRouteId'],
    );
  }
}
