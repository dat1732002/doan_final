import 'package:ecommerce_flutter/models/order_model.dart';
import 'package:ecommerce_flutter/services/product_service.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsView({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: ColorUtils.primaryBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Order Information',
              [
                _buildInfoRow('Order ID', '#${order.id ?? ''}'),
                _buildInfoRow('Status', order.status),
                _buildInfoRow('Date',
                    DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt)),
                _buildInfoRow(
                    'Total', '${order.totalAmount.toStringAsFixed(0)}\$'),
                _buildInfoRow('Payment Method',
                    order.paymentMethod ?? 'Cash on Delivery'),
              ],
            ),
            SizedBox(height: 24.h),
            _buildSection(
              'Customer Information',
              [
                _buildInfoRow('Name', order.customerName ?? ''),
                _buildInfoRow('Phone', order.customerPhone ?? ''),
                _buildInfoRow('Address', order.customerAddress ?? ''),
              ],
            ),
            SizedBox(height: 24.h),
            _buildSection(
              'Order Items',
              order.items
                  .map((item) => _buildOrderItem(context, item, order))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          Text(value,
              style: TextStyle(
                color: value.toLowerCase() == 'accepted'
                    ? Colors.green
                    : Colors.black,
              )),
        ],
      ),
    );
  }

  Widget _buildOrderItem(
      BuildContext context, OrderItem item, OrderModel order) {
    return GestureDetector(
      onTap: () {
        if (order.status.toLowerCase() == 'accepted') {
          _showCommentDialog(context, item, order);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                item.imageUrl,
                width: 80.w,
                height: 80.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.h),
                  Text('Size: ${item.size}'),
                  SizedBox(height: 4.h),
                  Text('Quantity: ${item.quantity}'),
                  SizedBox(height: 4.h),
                  Text('Price: ${item.price.toStringAsFixed(0)}\$'),
                  SizedBox(height: 4.h),
                  Text(
                    'Total: ${(item.price * item.quantity).toStringAsFixed(0)}\$',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentDialog(
      BuildContext context, OrderItem item, OrderModel order) {
    final commentController = TextEditingController();
    final ProductService _productService = ProductService();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Comment for ${item.productName}'),
        content: TextField(
          controller: commentController,
          decoration: InputDecoration(labelText: 'Comment'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final comment = commentController.text;
              if (comment.isNotEmpty) {
                try {
                  String userId = order.userId;
                  await _productService.addComment(
                      item.productId, userId, comment);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Comment added successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error adding comment: $e')),
                  );
                }
              }
              Navigator.pop(context);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
