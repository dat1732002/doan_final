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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryColor,
        title: Text('Chi tiết đơn hàng',style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600
        ),),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Thông tin đơn hàng',
              [
                _buildInfoRow('Mã đơn hàng', '#${order.id ?? ''}'),
                _buildInfoRow('Trạng thái', order.status),
                _buildInfoRow('Ngày đặt',
                    DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt)),
                _buildInfoRow(
                    'Tổng tiền', '${order.totalAmount.toStringAsFixed(0)}\$'),
                _buildInfoRow('Phương thức thanh toán',
                    (order.paymentMethod??"Cash on Delivery") == "Cash on Delivery" ? 'Trả khi nhận hàng': 'Trả khi nhận hàng'),
              ],
            ),
            SizedBox(height: 24.h),
            _buildSection(
              'Thông tin khách hàng',
              [
                _buildInfoRow('Tên', order.customerName ?? ''),
                _buildInfoRow('Số điện thoại', order.customerPhone ?? ''),
                _buildInfoRow('Địa chỉ', order.customerAddress ?? ''),
              ],
            ),
            SizedBox(height: 24.h),
            _buildSection(
              'Sản phẩm',
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
            color: Colors.grey.shade100,
            border: Border.all(color: Colors.black),
          ),
          padding: EdgeInsets.fromLTRB(10,10,10,0),
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
          Text(value.toLowerCase() == 'accepted'
              ? 'Thành công'
              : value.toLowerCase() == 'pending'
              ? 'Chờ xác nhận'
              : value,
              style: TextStyle(
                color: value.toLowerCase() == 'accepted'
                    ? Colors.green
                    : value.toLowerCase() == 'pending'
                    ? Colors.red
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
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.fromLTRB(5,0,5,0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                item.imageUrl,
                width: 100.w,
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
                  Text('Size: ${item.size}'),
                  Text('Số lượng: ${item.quantity}'),
                  Text('Giá: ${item.price.toStringAsFixed(0)}\$'),
                  Text(
                    'Tổng tiền: ${(item.price * item.quantity).toStringAsFixed(0)}\$',
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
        title: Text('Bình luận về ${item.productName}'),
        content: TextField(
          controller: commentController,
          decoration: InputDecoration(labelText: 'Viết bình luận'),
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
