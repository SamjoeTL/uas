class BookDTO {
  final int? id;
  final String? name;
  final int? price;
  final String? desc;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? imagePath;

  BookDTO({
    this.id,
    this.name,
    this.price,
    this.desc,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.imagePath,
  });

  factory BookDTO.fromJson(Map<String, dynamic> json) {
    return BookDTO(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      desc: json['desc'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'desc': desc,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'imagePath': imagePath,
    };
  }
}
