import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/user_model.dart';
import '../bloc/home_bloc.dart'; // Import the HomeBloc

class HomeScreen extends StatefulWidget {
  final UserModel user;

  HomeScreen({required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedIndex = 0;

  // Static food items list (sample data)
  final List<Map<String, dynamic>> allFoodItems = [
    {'name': 'Paneer', 'category': 'Veg', 'rate': 249.00, 'rating': 4.3, 'price': 199.00, 'image': 'assets/veg.jpg'},
    {'name': 'Chicken Biryani', 'category': 'Non-Veg', 'rate': 349.00, 'rating': 4.2, 'price': 299.00, 'image': 'assets/non_veg.jpg'},
    {'name': 'Manchurian', 'category': 'Chinese Food', 'rate': 249.00, 'rating': 4.6, 'price': 179.00, 'image': 'assets/chinese.jpg'},
    {'name': 'Burger', 'category': 'Fast Food', 'rate': 149.00, 'rating': 4.1, 'price': 99.00, 'image': 'assets/fast_food.jpg'},
    {'name': 'Ice Cream', 'category': 'Desserts', 'rate': 149.00, 'rating': 4.7, 'price': 89.00, 'image': 'assets/desserts.jpg'},
    {'name': 'Cold Drink', 'category': 'Beverages', 'rate': 99.00, 'rating': 4.4, 'price': 49.00, 'image': 'assets/beverages.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 80,
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
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(widget.user.profilePic),
              ),
            ],
          ),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeInitialState) {
              // Initial state: Show all items
              context.read<HomeBloc>().add(FilterByCategoryEvent(
                selectedIndex: 0,
                allFoodItems: allFoodItems,
              ));
            }

            if (state is HomeLoadingState) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is HomeLoadedState) {
              return Column(
                children: [
                  // Search & Filter Row
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
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
                            icon: Icon(CupertinoIcons.slider_horizontal_3, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Category Selection Chips
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

                  // GridView of Food Items
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: state.displayedFoodItems.length,
                      itemBuilder: (context, index) {
                        var item = state.displayedFoodItems[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
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
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(item['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.yellow.shade600, size: 16),
                                            Text("${item['rating']}", style: TextStyle(fontSize: 14, color: Colors.green)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "\₹${item['rate']}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text("\₹${item['price']}", style: TextStyle(fontSize: 14, color: Colors.green)),
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
                                        onPressed: () {},
                                        icon: Icon(Icons.favorite_border),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(CupertinoIcons.add_circled),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            return Container(); // Fallback
          },
        ),
      ),
    );
  }
}