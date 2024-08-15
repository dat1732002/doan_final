import 'package:ecommerce_flutter/features_member/order/order_detail_view.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_flutter/models/order_model.dart';
import 'package:ecommerce_flutter/services/order_service.dart';
import 'package:ecommerce_flutter/services/user_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderView extends HookWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderService = useMemoized(() => OrderService());
    final userService = useMemoized(() => UserService());

    final ordersStream = useMemoized(() {
      try {
        final userId = userService.getCurrentUserId();
        return orderService.getUserOrders(userId);
      } catch (e) {
        return Stream.value(<OrderModel>[]);
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryColor,
        title: Text(
          'Lịch sử đơn hàng',
          style: TextStyle(
            color: ColorUtils.whiteColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: ordersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có đơn hàng nào.'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OrderDetailsView(order: order),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Đơn hàng: ${order.items[0].productName}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text('Trạng thái: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                                Text(order.status.toLowerCase() == 'success'
                                    ? 'Thành công'
                                    : order.status.toLowerCase() == 'pending'
                                    ? 'Chờ xác nhận'
                                    : order.status.toLowerCase() == 'accepted'
                                    ?'Đã xác nhận'
                                    :order.status.toLowerCase() == 'fail'
                                    ?'Đã huỷ'
                                    :order.status,
                                    style: TextStyle(
                                        color: order.status.toLowerCase() == 'success'
                                            ? Colors.green
                                            : order.status.toLowerCase() == 'pending'||order.status.toLowerCase() == 'fail'
                                            ? Colors.red
                                            : order.status.toLowerCase() == 'accepted'
                                            ? Colors.black
                                            : Colors.grey
                                    )),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text('Ngày đặt: ${DateFormat('dd/MM/yyyy (HH:mm)').format(order.createdAt)}'),
                            SizedBox(height: 4),
                            Text(
                                'Tổng tiền: ${order.totalAmount.toStringAsFixed(0)}\$'),
                          ],
                        ),
                      ),
                       Icon(Icons.arrow_forward_ios),
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
}
