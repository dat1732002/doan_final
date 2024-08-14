import 'package:ecommerce_flutter/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProductQuantityManager extends HookWidget {
  final String productId;
  final Map<String, int> availableSizes;

  ProductQuantityManager({required this.productId, required this.availableSizes});

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();
    final quantities = useState<Map<String, int>>(availableSizes);

    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý số lượng sản phẩm'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...quantities.value.keys.map((size) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Size $size:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (quantities.value[size]! > 0) {
                            quantities.value[size] = quantities.value[size]! - 1;
                            quantities.value = Map.from(quantities.value); // Trigger rebuild
                          }
                        },
                      ),
                      Text(
                        quantities.value[size].toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          quantities.value[size] = quantities.value[size]! + 1;
                          quantities.value = Map.from(quantities.value); // Trigger rebuild
                        },
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                for (var entry in quantities.value.entries) {
                  await productService.updateProductQuantity(productId, entry.key, entry.value);
                }
                Navigator.pop(context);
              },
              child: Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }
}
