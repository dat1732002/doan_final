import 'package:ecommerce_flutter/models/cart_item_model.dart';
import 'package:ecommerce_flutter/services/cart_service.dart';
import 'package:ecommerce_flutter/models/product_model.dart';
import 'package:ecommerce_flutter/services/user_service.dart';
import 'package:ecommerce_flutter/services/product_service.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailView extends HookWidget {
  final ProductModel product;
  final bool isAdmin;
  const ProductDetailView({
    Key? key,
    required this.product,
    required this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();
    final quantity = useState<int>(1);
    final isLoading = useState<bool>(true);
    final currentUserId = useState<String>('');
    final userService = UserService();
    final productService = ProductService();
    final updatedProduct = useState<ProductModel>(product);
    final selectedSize = useState<Map<String, int>?>(null);

    useEffect(() {
      Future<void> fetchData() async {
        String userId = await userService.getCurrentUserId();
        currentUserId.value = userId;

        ProductModel? latestProduct =
        await productService.fetchProductDetails(product.id);
        if (latestProduct != null) {
          updatedProduct.value = latestProduct;
        }

        isLoading.value = false;
      }

      fetchData();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryColor,
        title: Text(
          'Chi tiết sản phẩm',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
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
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  product.imageUrl,
                  width: double.infinity,
                  height: 200.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                product.name,
                style: TextStyle(
                    fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(
                '${product.price} USD',
                style: TextStyle(fontSize: 20.sp, color: Colors.green),
              ),
              SizedBox(height: 8.h),
              Text(
                product.description,
                style: TextStyle(
                    fontSize: 16.sp, fontStyle: FontStyle.italic),
              ),
              if (!isAdmin)
                Row(
                  children: [
                    Text('Số lượng: ',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500)),
                    IconButton(
                      icon: Icon(
                        Icons.remove,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        if (quantity.value > 1) {
                          quantity.value--;
                        }
                      },
                    ),
                    Text('${quantity.value}'),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        quantity.value++;
                      },
                    ),
                  ],
                ),
              if (!isAdmin)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: selectedSize.value != null
                          ? () async {
                        final cartItem = CartItemModel(
                          productId: product.id,
                          quantity: quantity.value,
                          imageUrl: product.imageUrl,
                          productName: product.name,
                          price: product.price,
                          size: selectedSize.value!.keys.first,
                        );
                        await cartService.addOrUpdateCartItem(
                            currentUserId.value, cartItem);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                          content: Text('Đã thêm vào giỏ hàng!'),
                        ));
                      }
                          : null,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.black12)),
                        child: Text(
                          'Thêm vào giỏ hàng',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: 200, // Adjust width as needed
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                      ),
                      padding: EdgeInsets.only(left: 10, right: 6),
                      child: DropdownButton<Map<String, int>>(
                        value: selectedSize.value,
                        hint: Text('Select Size'),
                        isExpanded: true,
                        underline: SizedBox
                            .shrink(), // This removes the underline
                        items: updatedProduct.value.availableSizes
                            .map((sizeMap) {
                          String size = sizeMap.keys.first;
                          int quantity = sizeMap[size]!;

                          return DropdownMenuItem<Map<String, int>>(
                            value: sizeMap,
                            child: Text('$size - Quantity: $quantity'),
                          );
                        }).toList(),
                        onChanged: (Map<String, int>? newValue) {
                          if (newValue != null) {
                            selectedSize.value = newValue;
                          }
                        },
                      ),
                    )
                  ],
                ),
              SizedBox(height: 16.h),
              Text(
                'Bình luận',
                style: TextStyle(
                    fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              CommentsList(
                comments: updatedProduct.value.commentsList,
                userService: userService,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentsList extends HookWidget {
  final List<Comment> comments;
  final UserService userService;

  const CommentsList({
    Key? key,
    required this.comments,
    required this.userService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return comments.isEmpty
        ? Text('Chưa có bình luận nào.',
        style: TextStyle(fontStyle: FontStyle.italic))
        : ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return FutureBuilder<Map<String, dynamic>>(
          future: userService.fetchUserDetails(comments[index].userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CommentTile(
                  userName: 'Loading...',
                  commentText: comments[index].text);
            }
            if (snapshot.hasError) {
              return CommentTile(
                  userName: 'Error loading user',
                  commentText: comments[index].text);
            }
            String userName = snapshot.data?['name'] ?? 'Unknown User';
            return CommentTile(
                userName: userName, commentText: comments[index].text);
          },
        );
      },
    );
  }
}

class CommentTile extends StatelessWidget {
  final String userName;
  final String commentText;

  const CommentTile({
    Key? key,
    required this.userName,
    required this.commentText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              commentText,
              style: TextStyle(fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}
