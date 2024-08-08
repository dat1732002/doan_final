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
          product.category == selectedCategory.value!.name;
      return matchesSearch && matchesCategory;
    }).toList();

    if (isLoading.value) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorUtils.primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: ColorUtils.primaryBackgroundColor,
          title: Text(
            'Product Management',
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
          'Product Management',
          style: TextStyle(
            color: ColorUtils.primaryColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showProductDialog(context, null, categories.value, refresh);
            },
          ),
          IconButton(
            icon: Icon(Icons.category),
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
                      labelText: 'Search Products',
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
                  child: Text('Filter'),
                  style: ElevatedButton.styleFrom(
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
                return Container(
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
                                width: 100.w,
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
          title: Text('Filter by Category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: categories.map((category) {
                return ListTile(
                  title: Text(category.name),
                  onTap: () {
                    selectedCategory.value = category;
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Clear Filter'),
              onPressed: () {
                selectedCategory.value = null;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
          title: Text(product == null ? 'Add Product' : 'Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Category'),
                DropdownButtonFormField<String>(
                  hint: Text('Select Category'),
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
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                  readOnly: true,
                ),
                SizedBox(height: 10.h),
                selectedImage != null
                    ? Image.file(
                        selectedImage!,
                        height: 100.h,
                        width: 100.w,
                        fit: BoxFit.cover,
                      )
                    : Container(),
                SizedBox(height: 10.h),
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      selectedImage = File(image.path);
                      String imageUrl =
                          await productService.uploadImage(selectedImage!);
                      imageUrlController.text = imageUrl;
                    }
                  },
                  child: Text('Select Image'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
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
              child: Text(product == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  void _showCategoryManagementDialog(BuildContext context,
      List<CategoryModel> categories, ValueNotifier<int> refresh) {
    final categoryNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Manage Categories'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return ListTile(
                        title: Text(category.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: category.isUsed
                                  ? null
                                  : () {
                                      _showEditCategoryDialog(
                                          context, category, refresh);
                                    },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: category.isUsed
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
                      );
                    },
                  ),
                  TextField(
                    controller: categoryNameController,
                    decoration: InputDecoration(labelText: 'New Category Name'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
              TextButton(
                onPressed: () async {
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
                },
                child: Text('Add Category'),
              ),
            ],
          ),
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
          title: Text('Edit Category'),
          content: TextField(
            controller: categoryNameController,
            decoration: InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (category.isUsed) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Cannot edit a category that is in use'),
                  ));
                  return;
                }
                final updatedCategory = category.copyWith(
                  name: categoryNameController.text,
                );
                await CategoryService().updateCategory(updatedCategory);
                refresh.value++;
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
