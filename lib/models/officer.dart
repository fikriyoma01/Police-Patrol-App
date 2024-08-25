class Officer {
  final String id;
  final String name;
  final String rank;
  final String patrolUnit; 
  final String status; 

  Officer({
    required this.id,
    required this.name,
    required this.rank,
    required this.patrolUnit,
    required this.status,
  });

  // Convert an Officer object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rank': rank,
      'patrolUnit': patrolUnit,
      'status': status,
    };
  }

  // Convert a JSON map into an Officer object
  factory Officer.fromJson(Map<String, dynamic> json) {
    return Officer(
      id: json['id'],
      name: json['name'],
      rank: json['rank'],
      patrolUnit: json['patrolUnit'],
      status: json['status'],
    );
  }
}
