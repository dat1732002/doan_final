import 'package:ecommerce_flutter/features_member/home/product_detail_view.dart';
import 'package:ecommerce_flutter/models/product_model.dart';
import 'package:ecommerce_flutter/models/category_model.dart';
import 'package:ecommerce_flutter/services/product_service.dart';
import 'package:ecommerce_flutter/services/category_service.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductManagementView extends HookWidget {
  const ProductManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();
    final categoryService = CategoryService();
    final products = useState<List<ProductModel>>([]);
    final categories = useState<List<CategoryModel>>([]);
    final isLoading = useState<bool>(true);
    final refresh = useState<int>(0);
    final searchQuery = useState<String>('');
    final selectedCategory = useState<CategoryModel?>(null);

    useEffect(() {
      Future<void> fetchData() async {
        try {
          List<ProductModel> fetchedProducts =
              await productService.fetchProducts();
          products.value = fetchedProducts;

          List<CategoryModel> fetchedCategories =
              await categoryService.fetchCategories();
          categories.value = fetchedCategories;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to load products or categories: $e'),
          ));
        } finally {
          isLoading.value = false;
        }
      }

      fetchData();
      return null;
    }, [refresh.value]);

    List<ProductModel> filteredProducts = products.value.where((product) {
      bool matchesSearch =
          product.name.toLowerCase().contains(searchQuery.value.toLowerCase());
      bool matchesCategory = selectedCategory.value == null ||
          product.category == selectedCategory.value!.id;
      return matchesSearch && matchesCategory;
    }).toList();

    if (isLoading.value) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorUtils.primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: ColorUtils.primaryColor,
          title: Text(
            'Quản lý sản phẩm',
            style: TextStyle(
              color: ColorUtils.whiteColor,
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
        backgroundColor: ColorUtils.primaryColor,
        title: Text(
          'Quản lý sản phẩm',
          style: TextStyle(
            color: ColorUtils.whiteColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add,color: Colors.white,),
            onPressed: () {
              _showProductDialog(context, null, categories.value, refresh);
            },
          ),
          IconButton(
            icon: Icon(Icons.category,color: Colors.white,),
            onPressed: () {
              _showCategoryManagementDialog(context, categories.value, refresh);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      searchQuery.value = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Tìm kiếm',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: () {
                    _showCategoryFilterDialog(
                        context, categories.value, selectedCategory);
                  },
                  child: Text('Filter',style: TextStyle(
                    fontSize: 15,
                    color: Colors.white
                  ),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
          if (selectedCategory.value != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text('Filtered by: ${selectedCategory.value!.name}'),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      selectedCategory.value = null;
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailView(product: product,isAdmin: true,),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: product.imageUrl.isNotEmpty
                              ? Image.network(
                                  product.imageUrl,
                                  width: 120.w,
                                  height: 100.h,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 100.w,
                                  height: 100.h,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.image, color: Colors.grey),
                                ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                    fontSize: 18.sp, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                '${product.price} USD',
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.grey),
                              ),
                              Text(
                                'Category: ${product.category}',
                                style: TextStyle(
                                    fontSize: 14.sp, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showProductDialog(
                                    context, product, categories.value, refresh);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await productService.deleteProduct(product.id);
                                products.value.remove(product);
                                products.value = List.from(products.value);
                              },
                            ),
                          ],
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

  void _showCategoryFilterDialog(
      BuildContext context,
      List<CategoryModel> categories,
      ValueNotifier<CategoryModel?> selectedCategory) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          actionsAlignment: MainAxisAlignment.center,
          title: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              color: ColorUtils.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Lọc theo danh mục',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          content: Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: categories.map((category) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorUtils.primaryColor),
                    ),
                    child: ListTile(
                      title: Text(
                        category.name,
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        selectedCategory.value = category;
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                selectedCategory.value = null;
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorUtils.primaryColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Clear Filter',
                  style: TextStyle(color: ColorUtils.primaryColor),
                ),
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorUtils.primaryColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Close',
                  style: TextStyle(color: ColorUtils.primaryColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showProductDialog(BuildContext context, ProductModel? product,
      List<CategoryModel> categories, ValueNotifier<int> refresh) async {
    final nameController = TextEditingController(text: product?.name ?? '');
    final descriptionController =
    TextEditingController(text: product?.description ?? '');
    final priceController = TextEditingController(
        text: product != null ? product.price.toString() : '');
    final imageUrlController =
    TextEditingController(text: product?.imageUrl ?? '');
    File? selectedImage;
    final productService = ProductService();
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(10),
          actionsAlignment: MainAxisAlignment.center,
          title: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only( topRight:  Radius.circular(15),topLeft: Radius.circular(15)),
              color: ColorUtils.primaryColor,
            ),
            child: Text(
              product == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm',
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên sản phẩm',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text('Danh mục'),
                DropdownButtonFormField<String>(
                  hint: Text('Chọn danh mục'),
                  value: product?.category,
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.name,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedCategory = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Mô tả',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Giá',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffix: Text('USD')
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: imageUrlController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        readOnly: true,
                      ),
                    ),
                    SizedBox(width: 2),
                    InkWell(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          selectedImage = File(image.path);
                          String imageUrl = await productService.uploadImage(selectedImage!);
                          imageUrlController.text = imageUrl;
                        }
                      },
                      child: Icon(
                        Icons.image,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                selectedImage != null
                    ? Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(selectedImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                    : Container(),
                SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorUtils.primaryColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Hủy',
                  style: TextStyle(color: ColorUtils.primaryColor),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                if (product == null) {
                  final newProduct = ProductModel(
                    id: '',
                    name: nameController.text,
                    category: selectedCategory ?? '',
                    description: descriptionController.text,
                    price: double.tryParse(priceController.text) ?? 0.0,
                    imageUrl: imageUrlController.text,
                  );
                  await productService.createProduct(newProduct);
                } else {
                  final updatedProduct = ProductModel(
                    id: product.id,
                    name: nameController.text,
                    category: selectedCategory ?? product.category,
                    description: descriptionController.text,
                    price: double.tryParse(priceController.text) ?? 0.0,
                    imageUrl: imageUrlController.text,
                  );
                  await productService.updateProduct(updatedProduct);
                }
                refresh.value++;
                Navigator.of(context).pop();
              },
              child:  Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorUtils.primaryColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(product == null ? 'Thêm' : 'Cập nhật',
                  style: TextStyle(color: ColorUtils.primaryColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCategoryManagementDialog(
      BuildContext context,
      List<CategoryModel> categories,
      ValueNotifier<int> refresh) {
    final categoryNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(15),
          actionsPadding: EdgeInsets.zero,
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Colors.white,
          title: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              color: ColorUtils.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Quản lý danh mục',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ColorUtils.primaryColor),
                          ),
                          child: ListTile(
                            title: Text(category.name),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit,color: category.isUsed
                                      ? Colors.grey
                                      : Colors.black),
                                  onPressed:  () {
                                    _showEditCategoryDialog(
                                        context, category, refresh);
                                  },
                                ),
                                InkWell(
                                  child: Icon(Icons.delete,color: category.isUsed
                                      ? Colors.grey
                                      : Colors.black),
                                  onTap: category.isUsed
                                      ? null
                                      : () async {
                                    try {
                                      await CategoryService()
                                          .deleteCategory(category.id);
                                      categories.removeAt(index);
                                      categories = List.from(categories);
                                      Navigator.pop(context);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(e.toString()),
                                      ));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorUtils.primaryColor),
                    ),
                    child: TextField(
                      controller: categoryNameController,
                      decoration: InputDecoration(
                        labelText: 'Tên danh mục mới',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorUtils.primaryColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Đóng',
                  style: TextStyle(color: ColorUtils.primaryColor),
                ),
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () async {
                debugPrint(categoryNameController.text);
                if(categoryNameController.text != '')
                  {
                    final newCategory = CategoryModel(
                      id: '',
                      name: categoryNameController.text,
                      isUsed: false,
                    );
                    await CategoryService().createCategory(newCategory);
                    categories.add(newCategory);
                    categories = List.from(categories);
                    refresh.value++;
                    Navigator.of(context).pop();
                  }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorUtils.primaryColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Thêm danh mục',
                  style: TextStyle(color: ColorUtils.primaryColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditCategoryDialog(BuildContext context, CategoryModel category,
      ValueNotifier<int> refresh) {
    final categoryNameController = TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chỉnh sửa danh mục'),
          content: TextField(
            controller: categoryNameController,
            decoration: InputDecoration(labelText: 'Tên danh mục'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                // if (category.isUsed) {
                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //     content: Text('Cannot edit a category that is in use'),
                //   ));
                //   return;
                // }
                final updatedCategory = category.copyWith(
                  name: categoryNameController.text,
                );
                await CategoryService().updateCategory(updatedCategory);
                refresh.value++;
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Cập nhật'),
            ),
          ],
        );
      },
    );
  }
}
