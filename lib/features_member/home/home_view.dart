import 'package:ecommerce_flutter/common/widgets/search_form_field.dart';
import 'package:ecommerce_flutter/features_member/home/product_detail_view.dart';
import 'package:ecommerce_flutter/models/product_model.dart';
import 'package:ecommerce_flutter/services/product_service.dart';
import 'package:ecommerce_flutter/services/user_service.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends HookWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();
    final userService = UserService();
    final products = useState<List<ProductModel>>([]);
    final filteredProducts = useState<List<ProductModel>>([]);
    final isLoading = useState<bool>(true);
    final currentUserId = useState<String>('');
    final searchController = useTextEditingController();

    useEffect(() {
      Future<void> fetchCurrentUserId() async {
        try {
          String userId = userService.getCurrentUserId();
          currentUserId.value = userId;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to get user ID: $e'),
          ));
        }
      }

      fetchCurrentUserId();
      return null;
    }, []);

    useEffect(() {
      Future<void> fetchData() async {
        try {
          List<ProductModel> fetchedProducts =
              await productService.fetchProducts();
          products.value = fetchedProducts;
          filteredProducts.value = fetchedProducts;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to load products: $e'),
          ));
        } finally {
          isLoading.value = false;
        }
      }

      fetchData();
      return null;
    }, []);

    void searchProducts(String query) {
      if (query.isEmpty) {
        filteredProducts.value = products.value;
      } else {
        filteredProducts.value = products.value
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    }

    if (isLoading.value) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorUtils.primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: ColorUtils.primaryBackgroundColor,
          title: Text(
            'Home',
            style: TextStyle(
              color: ColorUtils.primaryColor,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorUtils.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryBackgroundColor,
        title: Text(
          'Home',
          style: TextStyle(
            color: ColorUtils.primaryColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: SearchFormField(
              hint: 'Search products',
              controller: searchController,
              onChanged: searchProducts,
              prefixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.value.length,
              itemBuilder: (context, index) {
                final product = filteredProducts.value[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailView(product: product),
                      ),
                    );
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorUtils.whiteColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            product.imageUrl,
                            width: 100.w,
                            height: 80.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                product.description,
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Price: ${product.price} USD',
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            product.favoriteUserIds
                                    .contains(currentUserId.value)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: product.favoriteUserIds
                                    .contains(currentUserId.value)
                                ? Colors.red
                                : null,
                          ),
                          onPressed: () async {
                            await productService.toggleFavorite(
                                product.id, currentUserId.value);
                            final updatedProducts =
                                await productService.fetchProducts();
                            products.value = updatedProducts;
                            searchProducts(searchController.text);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
