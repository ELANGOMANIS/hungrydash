import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';

import '../data/user_model.dart';
import '../utils/nav_bar.dart';
import '../utils/tost.dart';

class AddCartScreen extends StatefulWidget {
  final String userEmail;
  final UserModel user;
   AddCartScreen({Key? key,
    required this.userEmail,
    required this.user
  }) : super(key: key);

  @override
  _AddCartScreenState createState() => _AddCartScreenState();
}

class _AddCartScreenState extends State<AddCartScreen> {
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  bool isAddressEntered = false;

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(FetchCartEvent(widget.userEmail));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Row(
          children: [
            Text('My Cart', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavBarPage(user: widget.user)),
          );
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartError) {
              return Center(child: Text(state.message));
            } else if (state is CartLoaded) {
              final cartItems = state.cartItems;
              final totalAmount = state.totalAmount;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<CartBloc>().add(FetchCartEvent(widget.userEmail));
                  },
                  child: Stack(
                    children: [
                      ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];

                          return Card(
                            color: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        item['image'],
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                        cacheWidth: 250,
                                        cacheHeight: 150,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['name'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text('Price: ₹${item['price']}'),
                                            Text('Rating: ${item['rating']} ★'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        context.read<CartBloc>().add(DeleteCartEvent(item['name'], widget.userEmail));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total : ₹$totalAmount',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (areaController.text.isEmpty ||
                                      cityController.text.isEmpty ||
                                      districtController.text.isEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          title: const Text('Enter Address'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                controller: areaController,
                                                decoration: const InputDecoration(labelText: 'Area'),
                                              ),
                                              TextField(
                                                controller: cityController,
                                                decoration: const InputDecoration(labelText: 'City'),
                                              ),
                                              TextField(
                                                controller: districtController,
                                                decoration: const InputDecoration(labelText: 'District'),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                if (areaController.text.isEmpty ||
                                                    cityController.text.isEmpty ||
                                                    districtController.text.isEmpty) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('Please fill in all the fields'),
                                                      backgroundColor: Colors.red,
                                                    ),
                                                  );
                                                } else {
                                                  setState(() {
                                                    isAddressEntered = true;
                                                  });
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Text('Save'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                areaController.clear();
                                                cityController.clear();
                                                districtController.clear();
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    context.read<CartBloc>().add(
                                      PlaceOrderEvent(
                                        widget.userEmail,
                                        areaController.text,
                                        cityController.text,
                                        districtController.text,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow.shade700,
                                ),
                                child: Text(
                                  isAddressEntered ? 'Place Order' : 'Add Address',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is OrderPlaced) {
              ToastUtils.showToast('Order Placed Successfully');
              return SizedBox.shrink();
            } else {
              return const Center(child: Text('No Cart items found'));
            }
          },
        ),
      ),
    );
  }
}