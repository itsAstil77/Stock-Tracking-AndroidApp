class StockCountModel {
  final int? id;
  final String itemId;
  final String? barcode; // Added barcode field
  final String? description; // Added description field
  final int count;
  final String CreatedDate;

  StockCountModel({
    this.id,
    required this.itemId,
    this.barcode,
    this.description,
    required this.count,
    required this.CreatedDate,
  });

  factory StockCountModel.fromMap(Map<String, dynamic> json) => StockCountModel(
        id: json['id'] as int?,
        itemId: json['item_id'].toString(),
        barcode: json['barcode'] as String?,
        description: json['description'] as String?,
        count: json['count'] as int,
        CreatedDate: json['last_updated'] as String,
      );

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'item_id': itemId,
      if (barcode != null) 'barcode': barcode,
      if (description != null) 'description': description,
      'count': count,
      'last_updated': CreatedDate,
    };
  }
}
