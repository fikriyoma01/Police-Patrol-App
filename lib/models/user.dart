enum UserRole { Officer, CommandCenter, Public }

class User {
  final String id;
  final String email;
  final String? name;
  final String? patrolUnit; 
  final String? profileImageUrl;
  final DateTime?
      lastOnlineTimestamp; 
  final UserRole role; 
  final double? latitude; 
  final double? longitude; 

  User({
    required this.id,
    required this.email,
    this.name,
    this.patrolUnit,
    this.profileImageUrl,
    this.lastOnlineTimestamp,
    required this.role, 
    this.latitude, 
    this.longitude, 
  });

  // Convert a User object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'patrolUnit': patrolUnit,
      'profileImageUrl': profileImageUrl,
      'lastOnlineTimestamp': lastOnlineTimestamp?.millisecondsSinceEpoch,
      'role': role.index, 
      'latitude': latitude, 
      'longitude': longitude, 
    };
  }

  // Convert a JSON map into a User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '', 
      email: json['email'] ?? '', 
      name: json['name'],
      patrolUnit: json['patrolUnit'],
      profileImageUrl: json['profileImageUrl'],
      lastOnlineTimestamp: json['lastOnlineTimestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastOnlineTimestamp'])
          : null,
      role: json['role'] != null
          ? UserRole.values[json['role']]
          : UserRole.Public, 
      latitude: json['latitude'], 
      longitude: json['longitude'], 
    );
  }
}
