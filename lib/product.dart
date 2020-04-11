class Product {
  final String name;
  String imageUrl;
  final String statusCode;

  Product({this.name, this.imageUrl, this.statusCode = "0"});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        name: json['product']['product_name'].toString(),
        imageUrl: json['product']['image_url'].toString() != null
            ? json['product']['image_thumb_url'].toString()
            : "BlankImage.png",
        statusCode: json['status'].toString()
    );
  }
}