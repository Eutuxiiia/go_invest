class Startup {
  final String uid;
  final String name;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final String userId;
  final String userName;

  Startup({
    required this.uid,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.videoUrl,
    required this.userId,
    required this.userName,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'user_id': userId,
      'user_name': userName,
    };
  }

  factory Startup.fromMap(Map<String, dynamic> map) {
    return Startup(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['image_url'] ?? '',
      videoUrl: map['video_url'] ?? '',
      userId: map['user_id'] ?? '',
      userName: map['user_name'] ?? '',
    );
  }
}
