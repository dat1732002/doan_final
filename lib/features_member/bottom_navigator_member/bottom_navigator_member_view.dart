import 'package:ecommerce_flutter/features_member/bottom_navigator_member/notifier/bottom_navigation_notifier.dart';
import 'package:ecommerce_flutter/features_member/cart/cart_view.dart';
import 'package:ecommerce_flutter/features_member/home/home_view.dart';
import 'package:ecommerce_flutter/features_member/intro/intro_view.dart';
import 'package:ecommerce_flutter/features_member/order/order_view.dart';
import 'package:ecommerce_flutter/features_member/profile/profile_view.dart';
import 'package:ecommerce_flutter/utils/assets_utils.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/base_state_delegate/base_state_delegate.dart';

class BottomNavigationMemberView extends ConsumerStatefulWidget {
  const BottomNavigationMemberView({super.key});

  @override
  BaseStateDelegate<BottomNavigationMemberView, BottomNavigationNotifier>
  createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState
    extends BaseStateDelegate<BottomNavigationMemberView, BottomNavigationNotifier> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initNotifier() {
    notifier = ref.read(bottomNavigationNotifierProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children:  [
                IntroView(),
                HomeView(),
                CartView(),
                OrderView(),
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
                height: 50, // Set your desired height
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.info_outline, Icons.info, "Intro", 0, index),
                    _buildNavItem(Icons.warehouse_outlined, Icons.warehouse_rounded, "Home", 1, index),
                    _buildNavItemWithSvg(
                        AssetUtils.cart, AssetUtils.cartActive, "Cart", 2, index),
                    _buildNavItemWithSvg(
                        AssetUtils.order, AssetUtils.orderActive, "Order", 3, index),
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
        padding: const EdgeInsets.all(10), // Make the clickable area larger
        decoration: BoxDecoration(
          color: isActive ? ColorUtils.blueColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          isActive ? activeIcon : icon,
          color: isActive ? ColorUtils.blueColor : ColorUtils.primaryColor,
          size: 24,
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
        padding: const EdgeInsets.all(10), // Make the clickable area larger
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
          height: 24, // Control the icon size
        ),
      ),
    );
  }
}
