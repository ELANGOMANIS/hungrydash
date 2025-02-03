import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../data/user_model.dart';
import '../bloc/home/home_bloc.dart';
import '../database/localdatabase.dart';
import '../utils/shimmer.dart';
import '../utils/tost.dart';
import 'login_screen.dart'; // Import the HomeBloc

class HomeScreen extends StatefulWidget {
  final UserModel user;

  HomeScreen({required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedIndex = 0;
  final DatabaseUser _dbUser = DatabaseUser();

  Future<bool> _isFavorite(String name) async {
    return await _dbUser.isFavorite(name, widget.user.email);
  }

  Future<bool> _isInCart(String name) async {
    return await _dbUser.isInCart(name, widget.user.email);
  }

  Future<void> _toggleFavorite(Map<String, dynamic> item) async {
    final isFavorite = await _dbUser.isFavorite(item['name'], widget.user.email);

    if (isFavorite) {
      await _dbUser.deleteFavorite(item['name'], widget.user.email);
      ToastUtils.showToast("${item['name']} removed from favorites", isSuccess: false);
    } else {
      await _dbUser.insertFavorite(item, widget.user.email);
      ToastUtils.showToast("${item['name']} added to favorites", isSuccess: true);
    }

    setState(() {});
  }

  final List<Map<String, dynamic>> allFoodItems = [
    {'name': 'Paneer', 'category': 'Veg', 'rate': 249.00, 'rating': 4.3, 'price': 199.00, 'image': 'assets/veg.jpg'},
    {'name': 'Chicken Biryani', 'category': 'Non-Veg', 'rate': 349.00, 'rating': 4.2, 'price': 299.00, 'image': 'assets/non_veg.jpg'},
    {'name': 'Manchurian', 'category': 'Chinese Food', 'rate': 249.00, 'rating': 4.6, 'price': 179.00, 'image': 'assets/chinese.jpg'},
    {'name': 'Burger', 'category': 'Fast Food', 'rate': 149.00, 'rating': 4.1, 'price': 99.00, 'image': 'assets/fast_food.jpg'},
    {'name': 'Ice Cream', 'category': 'Desserts', 'rate': 149.00, 'rating': 4.7, 'price': 89.00, 'image': 'assets/desserts.jpg'},
    {'name': 'Cold Drink', 'category': 'Beverages', 'rate': 99.00, 'rating': 4.4, 'price': 49.00, 'image': 'assets/beverages.jpg'},
  ];
  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Exit', style: TextStyle(color: Colors.black)),
          content: const Text('Are you sure you want to exit?', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Don't exit
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Exit', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    ) ??
        false;
  }
  Future<bool> _showLogOutDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Logout', style: TextStyle(color: Colors.black)),
          content: const Text('Are you sure you want to logout?', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Don't exit
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutEvent());  // Dispatch LogoutEvent
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),  // Redirect to login screen
                );
              },
              child: const Text('yes', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {

        return await _showExitDialog(context);
      },
      child: BlocProvider(
        create: (context) => HomeBloc(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 80,
            automaticallyImplyLeading: false,  // Prevents the back button from showing

            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hungerdash",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      "Are you hungry ${widget.user.name} ?",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.user.profilePic),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _showLogOutDialog(context);
                      },
                    )

                  ],
                ),
              ],
            ),
          ),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeInitialState) {
                context.read<HomeBloc>().add(FilterByCategoryEvent(
                  selectedIndex: 0,
                  allFoodItems: allFoodItems,
                ));
              }

              if (state is HomeLoadingState) {
                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: 6, // number of placeholder items
                  itemBuilder: (context, index) {
                    return FoodItemShimmer();
                  },
                );
              }

              if (state is HomeLoadedState) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search",
                                  prefixIcon: Icon(Icons.search),
                                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                ),
                                onChanged: (text) {
                                  context.read<HomeBloc>().add(FilterBySearchEvent(
                                    query: text,
                                    allFoodItems: allFoodItems,
                                  ));
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(CupertinoIcons.slider_horizontal_3, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: context.read<HomeBloc>().categories.map((category) {
                            int index = context.read<HomeBloc>().categories.indexOf(category);
                            bool isSelected = index == selectedIndex;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                  context.read<HomeBloc>().add(FilterByCategoryEvent(
                                    selectedIndex: index,
                                    allFoodItems: allFoodItems,
                                  ));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.red : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<HomeBloc>().add(RefreshDataEvent(allFoodItems: allFoodItems));
                          await Future.delayed(const Duration(seconds: 2));
                        },
                        child: GridView.builder(
                          padding: const EdgeInsets.all(10),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: state.displayedFoodItems.length,
                          itemBuilder: (context, index) {
                            var item = state.displayedFoodItems[index];
                            return FutureBuilder<bool>(
                              future: _isFavorite(item['name']),
                              builder: (context, snapshot) {
                                final isFavorite = snapshot.data ?? false;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        item['image'],
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        cacheWidth: 250, // Adjust based on your needs
                                        cacheHeight: 150, // Adjust based on your needs
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  item['name'],
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(Icons.star, color: Colors.yellow.shade600, size: 16),
                                                    Text(
                                                      "${item['rating']}",
                                                      style: const TextStyle(fontSize: 14, color: Colors.green),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "₹${item['rate']}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                    decoration: TextDecoration.lineThrough,
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "₹${item['price']}",
                                                  style: TextStyle(fontSize: 14, color: Colors.green),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 10, bottom: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                onPressed: () => _toggleFavorite(item),
                                                icon: Icon(
                                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                                  color: isFavorite ? Colors.red : null,
                                                ),
                                              ),
                                              FutureBuilder<bool>(
                                                future: _isInCart(item['name']),
                                                builder: (context, cartSnapshot) {
                                                  final isInCart = cartSnapshot.data ?? false;
                                                  return IconButton(
                                                    onPressed: () async {
                                                      if (isInCart) {
                                                        await _dbUser.deleteCart(item['name'], widget.user.email);
                                                        ToastUtils.showToast("${item['name']} removed from cart", isSuccess: false);
                                                      } else {
                                                        await _dbUser.insertCart(item, widget.user.email);
                                                        ToastUtils.showToast("${item['name']} added to cart", isSuccess: true);
                                                      }
                                                      setState(() {}); // Refresh UI
                                                    },
                                                    icon: Icon(
                                                      isInCart ? CupertinoIcons.check_mark_circled : CupertinoIcons.add_circled,
                                                      color: isInCart ? Colors.green : null,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }

              // Fallback for any other states
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
