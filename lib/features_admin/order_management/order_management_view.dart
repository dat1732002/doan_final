import 'package:ecommerce_flutter/features_admin/order_management/order_management_detail_view.dart';
import 'package:ecommerce_flutter/models/order_model.dart';
import 'package:ecommerce_flutter/services/order_service.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderManagementView extends HookWidget {
  const OrderManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderService = OrderService();

    return Scaffold(
      backgroundColor: ColorUtils.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryColor,
        title: Text(
          'Quản lý đơn hàng',
          style: TextStyle(
            color: ColorUtils.whiteColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: orderService.getAllOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không tìm thấy đơn hàng nào.'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return InkWell(
                onTap: (){
                  _navigateToOrderDetails(context, order);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Đơn hàng: ${order.items[0].productName}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Tổng tiền: ${order.totalAmount.toStringAsFixed(0)}\$',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Khách hàng: ${order.customerName}',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Text(
                                  'Trạng thái: ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Text(
                                  '${order.status}',
                                  style: TextStyle(
                                    color: order.status.toLowerCase() == 'accepted'
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          _navigateToOrderDetails(context, order);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToOrderDetails(BuildContext context, OrderModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderManagementDetailsView(order: order),
      ),
    );
  }
}
