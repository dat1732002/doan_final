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

    double getTotalExpectedRevenue() {
      return orders.value
          .where((order) =>
              order.status == 'Accepted' || order.status == 'pending')
          .fold(0, (sum, order) => sum + order.totalAmount);
    }

    double getActualRevenue() {
      return orders.value
          .where((order) => order.status == 'Accepted')
          .fold(0, (sum, order) => sum + order.totalAmount);
    }

    return Scaffold(
      backgroundColor: ColorUtils.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryBackgroundColor,
        elevation: 0,
        title: Text(
          'Order Statistics',
          style: TextStyle(
            color: ColorUtils.primaryColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading.value
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorUtils.primaryColor,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: StatBox(
                            title: 'Accepted',
                            value: getAcceptedOrdersCount().toString(),
                            color: Colors.green,
                            icon: Icons.check_circle,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: StatBox(
                            title: 'Pending',
                            value: getPendingOrdersCount().toString(),
                            color: Colors.orange,
                            icon: Icons.timer,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Revenue',
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
            'Expected Revenue',
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
            'Actual Revenue',
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
