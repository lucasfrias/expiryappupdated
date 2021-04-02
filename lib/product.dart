class Product {
  String name;
  String imageUrl;
  final String statusCode;

  Product({this.name, this.statusCode = "0"});

  factory Product.fromJson(Map<String, dynamic> json) {
    Product product = new Product(
        name: json['product']['product_name'].toString(),
        statusCode: json['status'].toString());

    if (json['product']['image_thumb_url'] != null) {
      product.imageUrl = json['product']['image_thumb_url'].toString();
    } else {
      product.imageUrl = "fork.png";
    }
    return product;
  }

  /*factory Product.fromJsonWithoutImage(Map<String, dynamic> json) {
    return Product(
        name: json['product']['product_name'].toString(),
        imageUrl: "fork.png",
        statusCode: json['status'].toString()
    );
  }
   */

  setName(String name) {
    this.name = name;
  }
}
