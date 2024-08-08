import 'package:ecommerce_flutter/features_member/bottom_navigator_member/notifier/bottom_navigation_notifier.dart';
import 'package:ecommerce_flutter/features_member/cart/cart_view.dart';
import 'package:ecommerce_flutter/features_member/home/home_view.dart';
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
      body: Container(
        color: Colors.white,
        child: Consumer(
          builder: (context, ref, child) {
            ref.watch(
              bottomNavigationNotifierProvider.select(
                (value) => value.currentIndex,
              ),
            );
            return PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: const [
                HomeView(),
                CartView(),
                OrderView(),
                ProfileView(),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: ColorUtils.primaryBackgroundColor,
        child: BottomAppBar(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          padding: const EdgeInsets.all(0),
          shape: AutomaticNotchedShape(
            const RoundedRectangleBorder(),
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Consumer(
            builder: (context, ref, child) {
              final index = ref.watch(
                bottomNavigationNotifierProvider.select(
                  (value) => value.currentIndex,
                ),
              );
              return BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AssetUtils.home,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      AssetUtils.homeActive,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.blueColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "home",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AssetUtils.cart,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      AssetUtils.cartActive,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.blueColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "Cart",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AssetUtils.order,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      AssetUtils.orderActive,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.blueColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "Order",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AssetUtils.profile,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      AssetUtils.profileActive,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.blueColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "profile",
                  ),
                ],
                backgroundColor: ColorUtils.whiteColor,
                selectedItemColor: ColorUtils.blueColor,
                unselectedItemColor: ColorUtils.primaryColor,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: index,
                type: BottomNavigationBarType.fixed,
                onTap: (value) => {
                  _pageController.jumpToPage(value),
                  notifier.setCurrentIndex(value),
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
