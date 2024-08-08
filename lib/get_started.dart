import 'package:ecommerce_flutter/common/widgets/text_button_widget.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:ecommerce_flutter/utils/routes/routes.dart';
import 'package:ecommerce_flutter/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetStarted extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/icon.png',
          width: 150,),
          Text('Welcome To Shoes World',
            style: TextStyle(
                color: ColorUtils.primaryColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold),),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButtonWidget(
              label: 'Get Started',
              onPressed: (){
                Routes.goToSignInScreen(context);
              },
            ),
          ),
        ],),);
  }
}
