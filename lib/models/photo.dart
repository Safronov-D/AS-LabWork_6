class Photo {
  final int id;
  final int sol;
  final Camera camera;
  final String imgSrc;
  final DateTime earthDate; // Изменили на DateTime
  final Rover rover;

  Photo({
    required this.id,
    required this.sol,
    required this.camera,
    required this.imgSrc,
    required this.earthDate,
    required this.rover,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    // Фикс URL изображений
    String imgSrc = json['img_src'];
    if (imgSrc.startsWith('http://')) {
      imgSrc = imgSrc.replaceFirst('http://', 'https://');
    }

    return Photo(
      id: json['id'],
      sol: json['sol'],
      camera: Camera.fromJson(json['camera']),
      imgSrc: imgSrc,
      earthDate: DateTime.parse(json['earth_date']), // Парсим дату
      rover: Rover.fromJson(json['rover']),
    );
  }
}

class Camera {
  final int id;
  final String name;
  final String fullName;

  Camera({required this.id, required this.name, required this.fullName});

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      id: json['id'],
      name: json['name'],
      fullName: json['full_name'],
    );
  }
}

class Rover {
  final int id;
  final String name;
  final String status;
  final DateTime landingDate;
  final DateTime launchDate;

  Rover({
    required this.id,
    required this.name,
    required this.status,
    required this.landingDate,
    required this.launchDate,
  });

  factory Rover.fromJson(Map<String, dynamic> json) {
    return Rover(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      landingDate: DateTime.parse(json['landing_date']),
      launchDate: DateTime.parse(json['launch_date']),
    );
  }
}