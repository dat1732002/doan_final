import 'package:ecommerce_flutter/features_admin/account_management/account_management_view.dart';
import 'package:ecommerce_flutter/features_admin/order_management/order_management_view.dart';
import 'package:ecommerce_flutter/features_admin/product_management/product_management_view.dart';
import 'package:ecommerce_flutter/features_admin/statistical_management/statistical_management_view.dart';
import 'package:ecommerce_flutter/features_member/bottom_navigator_member/notifier/bottom_navigation_notifier.dart';
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

class _BottomNavigationViewState extends BaseStateDelegate<
    BottomNavigationAdminView, BottomNavigationNotifier> {
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
                AccountManagementView(),
                ProductManagementView(),
                OrderManagementView(),
                StatisticalManagementView(),
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
                    label: "account_management_view",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AssetUtils.product,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      AssetUtils.productActive,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.blueColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "product_management_view",
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
                      AssetUtils.chart,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      AssetUtils.chartActive,
                      colorFilter: ColorFilter.mode(
                        ColorUtils.blueColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "chart",
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
