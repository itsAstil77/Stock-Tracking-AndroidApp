class ItemModel {
  final String? id;
  final String name;
  final String description;
  final String barcode;
  final int count;
  final String apiId;
  final String qrCode;

  ItemModel({
    this.id,
    required this.name,
    required this.description,
    required this.barcode,
    required this.count,
    required this.apiId,
    required this.qrCode,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] != null
          ? map['id'].toString()
          : null, // Handles both int and String
      apiId: map['api_id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      qrCode: map['qr_code']?.toString() ?? '',
      count: map['count'] is int
          ? map['count']
          : int.tryParse(map['count']?.toString() ?? '0') ?? 0,
      barcode: map['Barcode']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'api_id': apiId,
      'name': name,
      'description': description,
      'qr_code': qrCode,
      'count': count,
    };
  }

  factory ItemModel.fromApi(Map<String, dynamic> json) {
    final fields = json['additionalFields'] ?? {};

    return ItemModel(
      id: null, // This is not received from API, assumed to be generated locally
      apiId: json['id']?.toString() ?? '',
      name: fields['ItemCode']?.toString() ?? '',
      description: fields['Description']?.toString() ?? '',
      qrCode: json['barcode']?.toString() ?? '',
      count: int.tryParse(fields['Quantity']?.toString() ?? '0') ?? 0,
      barcode: json['Barcode']?.toString() ?? '',
    );
  }
}
