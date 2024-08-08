import 'package:ecommerce_flutter/models/order_model.dart';
import 'package:ecommerce_flutter/services/order_service.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderManagementDetailsView extends StatelessWidget {
  final OrderModel order;

  const OrderManagementDetailsView({Key? key, required this.order})
      : super(key: key);

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
                    'Total', '${order.totalAmount.toStringAsFixed(0)} \$'),
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
              order.items.map((item) => _buildOrderItem(item)).toList(),
            ),
            SizedBox(height: 24.h),
            _buildActionButtons(context),
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
          Text(value),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Container(
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
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => _showCancelDialog(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: ColorUtils.whiteColor),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () => _showAcceptDialog(context),
          child: Text(
            'Accept',
            style: TextStyle(color: ColorUtils.whiteColor),
          ),
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Order'),
        content: Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              await OrderService().deleteOrder(order.id!);
              Navigator.pop(context);
              Navigator.pop(context); // Close details view
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showAcceptDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Accept Order'),
        content: Text('Are you sure you want to accept this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              await OrderService().updateOrderStatus(order.id!, 'Accepted');
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
