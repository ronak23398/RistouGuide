class Place {
  final String id;
  final String title;
  final String description;
  final String address;
  final double rating;
  final List<String> images;

  Place({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.rating,
    required this.images,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'address': address,
      'rating': rating,
      'images': images,
    };
  }
}
