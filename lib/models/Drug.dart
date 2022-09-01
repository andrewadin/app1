import 'dart:convert';

// Converting data in JSON format to dart object (similar to associative array or dictionary)
List<Drug> drugFromJson(String str) => List<Drug>.from(json.decode(str).map((x) => Drug.fromJson(x)));

// Converting data in dart object to JSON format
String drugToJson(List<Drug> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// Model class to interpret table column in database
class Drug {
  // Mimicing the table column in dart object format
    Drug({
        required this.id,
        required this.name,
        required this.brand,
        required this.price,
        required this.stocks,
        required this.createdAt,
        required this.updatedAt,
    });

    int id;
    String name;
    String brand;
    String price;
    String stocks;
    DateTime createdAt;
    DateTime updatedAt;

    // Mapping each key-value pair in JSON to Map object
    factory Drug.fromJson(Map<String, dynamic> json) => Drug(
        id: json["id"],
        name: json["name"],
        brand: json["brand"],
        price: json["price"],
        stocks: json["stocks"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    // Mapping dart object to JSON key-value pair
    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "brand": brand,
        "price": price,
        "stocks": stocks,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
