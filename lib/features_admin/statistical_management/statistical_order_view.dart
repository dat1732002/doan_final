import 'package:ecommerce_flutter/models/order_model.dart';
import 'package:ecommerce_flutter/services/order_service.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticalOrderView extends HookWidget {
  const StatisticalOrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderService orderService = OrderService();
    final orders = useState<List<OrderModel>>([]);
    final isLoading = useState(true);

    useEffect(() {
      final subscription = orderService.getAllOrders().listen((event) {
        orders.value = event;
        isLoading.value = false;
      });
      return () => subscription.cancel();
    }, []);

    int getAcceptedOrdersCount() {
      return orders.value.where((order) => order.status == 'Accepted').length;
    }

    int getPendingOrdersCount() {
      return orders.value.where((order) => order.status == 'pending').length;
    }
    int getSuccessOrdersCount() {
      return orders.value.where((order) => order.status == 'Success').length;
    }

    int getFailOrdersCount() {
      return orders.value.where((order) => order.status == 'Fail').length;
    }

    double getTotalExpectedRevenue() {
      return orders.value
          .where((order) =>
              order.status == 'Accepted' || order.status == 'pending')
          .fold(0, (sum, order) => sum + order.totalAmount);
    }

    int getTotalShoesSold() {
      return orders.value
          .where((order) =>
      order.status == 'Accepted' || order.status == 'pending'||order.status == 'Success')
          .fold(0, (sum, order) => sum + order.items.length);
    }
    int getTotalShoesSoldAccepted() {
      int total = 0;
      for (var order in orders.value) {
        if (order.status == 'Success' ) {
          total += order.items.length;
        }
      }
      return total;
    }
    int getTotalShoesSoldFail() {
      int total = 0;
      for (var order in orders.value) {
        if (order.status == 'Fail' ) {
          total += order.items.length;
        }
      }
      return total;
    }

    double getActualRevenue() {
      return orders.value
          .where((order) => order.status == 'Success')
          .fold(0, (sum, order) => sum + order.totalAmount);
    }

    return Scaffold(
      backgroundColor: ColorUtils.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Thống kê đơn hàng',
          style: TextStyle(
            color: ColorUtils.whiteColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading.value
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng quan',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorUtils.primaryColor,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: StatBox(
                                title: 'Đã xác nhận',
                                value: getAcceptedOrdersCount().toString(),
                                color: Colors.blue,
                                icon: Icons.check_circle,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: StatBox(
                                title: 'Chờ xác nhận',
                                value: getPendingOrdersCount().toString(),
                                color: Colors.orange,
                                icon: Icons.timer,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child: StatBox(
                                title: 'Thành công',
                                value: getSuccessOrdersCount().toString(),
                                color: Colors.green,
                                icon: Icons.check_circle,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: StatBox(
                                title: 'Thất bại',
                                value: getFailOrdersCount().toString(),
                                color: Colors.red,
                                icon: Icons.cancel,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Doanh thu',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorUtils.primaryColor,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    RevenueBox(
                      expectedRevenue: getTotalExpectedRevenue(),
                      actualRevenue: getActualRevenue(),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Sản phẩm bán ra',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorUtils.primaryColor,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade300, Colors.blue.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tổng số sản phẩm đã được đặt',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '${getTotalShoesSold()}',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Số sản phẩm bán thành công',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '${getTotalShoesSoldAccepted()}',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Số sản phẩm hoàn trả',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '${getTotalShoesSoldFail()}',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                  ],
                ),
              ),
            ),
    );
  }
}

class StatBox extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const StatBox({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: ColorUtils.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class RevenueBox extends StatelessWidget {
  final double expectedRevenue;
  final double actualRevenue;

  const RevenueBox({
    Key? key,
    required this.expectedRevenue,
    required this.actualRevenue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Doanh thu kỳ vọng',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '${expectedRevenue.toStringAsFixed(0)}\$',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Doanh thu thực tế',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '${actualRevenue.toStringAsFixed(0)}\$',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
