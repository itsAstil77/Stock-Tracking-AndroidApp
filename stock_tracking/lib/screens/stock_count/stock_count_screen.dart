import 'package:flutter/material.dart';
import '../../models/item_model.dart';
import '../../services/db_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StockCountScreen extends StatefulWidget {
  const StockCountScreen({super.key});

  @override
  State<StockCountScreen> createState() => _StockCountScreenState();
}

class _StockCountScreenState extends State<StockCountScreen> {
  final _qrController = TextEditingController();
  ItemModel? _currentItem;
  final _countController = TextEditingController();

  Future<void> _searchItem() async {
    final qrCode = _qrController.text.trim();
    if (qrCode.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter QR code');
      return;
    }
    final item = await DBService.instance.getItemByQrCode(qrCode);
    if (item == null) {
      Fluttertoast.showToast(msg: 'Item not found');
      setState(() => _currentItem = null);
    } else {
      setState(() {
        _currentItem = item;
        _countController.text = item.count.toString();
      });
    }
  }

  Future<void> _updateCount() async {
    if (_currentItem == null) {
      Fluttertoast.showToast(msg: 'No item selected');
      return;
    }
    final countStr = _countController.text.trim();
    if (countStr.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter count');
      return;
    }
    final count = int.tryParse(countStr);
    if (count == null || count < 0) {
      Fluttertoast.showToast(msg: 'Invalid count');
      return;
    }
    await DBService.instance.updateItemCount(_currentItem!.id!, count);
    Fluttertoast.showToast(msg: 'Count updated successfully');
    setState(() => _currentItem = null);
    _qrController.clear();
    _countController.clear();
  }

  @override
  void dispose() {
    _qrController.dispose();
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Count'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomInputField(
              controller: _qrController,
              labelText: 'Enter QR Code',
            ),
            const SizedBox(height: 10),
            CustomButton(text: 'Search Item', onPressed: _searchItem),
            if (_currentItem != null) ...[
              const SizedBox(height: 20),
              Text(
                'Item: ${_currentItem!.name}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              CustomInputField(
                controller: _countController,
                labelText: 'Enter Count',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              CustomButton(text: 'Update Count', onPressed: _updateCount),
            ],
          ],
        ),
      ),
    );
  }
}
