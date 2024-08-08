import 'package:ecommerce_flutter/features_admin/statistical_management/statistical_order_view.dart';
import 'package:ecommerce_flutter/features_admin/statistical_management/statistical_product_view.dart';
import 'package:ecommerce_flutter/features_member/profile/widgets/button_settings_widget.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class StatisticalManagementView extends HookWidget {
  const StatisticalManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorUtils.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryBackgroundColor,
        title: Text(
          'Statistical Management',
          style: TextStyle(
            color: ColorUtils.primaryColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          ButtonSettingsWidget(
            icon: SvgPicture.asset(
              'assets/icons/ic_product.svg',
            ),
            title: 'Product statistics',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StatisticalProductView()),
              );
            },
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: ColorUtils.textColor,
          ),
          ButtonSettingsWidget(
            icon: SvgPicture.asset(
              'assets/icons/ic_order.svg',
            ),
            title: 'Order statistics',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StatisticalOrderView()),
              );
            },
          ),
        ]),
      ),
    );
  }
}
