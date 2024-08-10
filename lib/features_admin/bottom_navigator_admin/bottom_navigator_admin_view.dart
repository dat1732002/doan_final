import 'package:ecommerce_flutter/features_admin/account_management/account_management_view.dart';
import 'package:ecommerce_flutter/features_admin/order_management/order_management_view.dart';
import 'package:ecommerce_flutter/features_admin/product_management/product_management_view.dart';
import 'package:ecommerce_flutter/features_admin/statistical_management/statistical_management_view.dart';
import 'package:ecommerce_flutter/features_member/bottom_navigator_member/notifier/bottom_navigation_notifier.dart';
import 'package:ecommerce_flutter/features_member/profile/profile_view.dart';
import 'package:ecommerce_flutter/utils/assets_utils.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/base_state_delegate/base_state_delegate.dart';

class BottomNavigationAdminView extends ConsumerStatefulWidget {
  const BottomNavigationAdminView({super.key});

  @override
  BaseStateDelegate<BottomNavigationAdminView, BottomNavigationNotifier>
  createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState
    extends BaseStateDelegate<BottomNavigationAdminView, BottomNavigationNotifier> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initNotifier() {
    notifier = ref.read(bottomNavigationNotifierProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: const [
                AccountManagementView(),
                ProductManagementView(),
                OrderManagementView(),
                StatisticalManagementView(),
                ProfileView(),
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final index = ref.watch(
                bottomNavigationNotifierProvider.select((value) => value.currentIndex),
              );
              return Container(
                color: ColorUtils.primaryBackgroundColor,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.manage_accounts_outlined,Icons.manage_accounts,'Account',0,index),
                    _buildNavItemWithSvg(
                        AssetUtils.product, AssetUtils.productActive, "Products", 1, index),
                    _buildNavItemWithSvg(
                        AssetUtils.order, AssetUtils.orderActive, "Orders", 2, index),
                    _buildNavItemWithSvg(
                        AssetUtils.chart, AssetUtils.chartActive, "Statistics", 3, index),
                    _buildNavItemWithSvg(
                        AssetUtils.profile, AssetUtils.profileActive, "Profile", 4, index),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  Widget _buildNavItem(IconData icon, IconData activeIcon, String label, int itemIndex,
      int currentIndex) {
    final isActive = currentIndex == itemIndex;
    return GestureDetector(
      onTap: () {
        _pageController.jumpToPage(itemIndex);
        notifier.setCurrentIndex(itemIndex);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? ColorUtils.blueColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          isActive ? activeIcon : icon,
          color: isActive ? ColorUtils.blueColor : ColorUtils.primaryColor,
          size: 28,
        ),
      ),
    );
  }
  Widget _buildNavItemWithSvg(
      String icon, String activeIcon, String label, int itemIndex, int currentIndex) {
    final isActive = currentIndex == itemIndex;
    return GestureDetector(
      onTap: () {
        _pageController.jumpToPage(itemIndex);
        notifier.setCurrentIndex(itemIndex);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? ColorUtils.blueColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: SvgPicture.asset(
          isActive ? activeIcon : icon,
          colorFilter: ColorFilter.mode(
            isActive ? ColorUtils.blueColor : ColorUtils.primaryColor,
            BlendMode.srcIn,
          ),
          height: 24,
        ),
      ),
    );
  }
}
