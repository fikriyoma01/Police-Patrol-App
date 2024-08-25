class Resource {
  final String id;
  final String name;
  final String type; 
  final String status; 

  Resource({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
  });

  // Convert a Resource object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'status': status,
    };
  }

  // Convert a JSON map into a Resource object
  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      status: json['status'],
    );
  }
}
