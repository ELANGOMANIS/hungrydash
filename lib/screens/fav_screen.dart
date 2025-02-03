import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorite/favorite_bloc.dart';
import '../bloc/favorite/favorite_event.dart';
import '../bloc/favorite/favorite_state.dart';
import '../data/user_model.dart';
import '../database/localdatabase.dart';
import '../utils/nav_bar.dart';

class FavoriteItemsScreen extends StatelessWidget {
  final String userEmail;
  final UserModel user;

   FavoriteItemsScreen({Key? key,
    required this.userEmail,
     required this.user


  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog when the back button is pressed
        return await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBarPage(user: user)),
        );
      },
      child: BlocProvider(
        create: (context) => FavoriteBloc(DatabaseUser())..add(FetchFavoritesEvent(userEmail)),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: const Row(
              children: [
                Text('Favorite Items', style: TextStyle(color: Colors.white)),
                SizedBox(width: 5),
                Icon(Icons.favorite_border, color: Colors.white),
              ],
            ),
          ),
          body: BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              if (state is FavoriteLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FavoriteError) {
                return const Center(child: Text('Error fetching favorites'));
              } else if (state is FavoriteLoaded) {
                final favoriteItems = state.favorites;

                if (favoriteItems.isEmpty) {
                  return const Center(child: Text('No favorite items found'));
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<FavoriteBloc>().add(FetchFavoritesEvent(userEmail));
                    },
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: favoriteItems.length,
                      itemBuilder: (context, index) {
                        final item = favoriteItems[index];

                        return Card(
                          color: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                      item['image'],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      cacheWidth: 250,
                                      cacheHeight: 150,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          item['name'],
                                          style: const TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
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
                                  icon: const Icon(Icons.close, color: Colors.white),
                                  onPressed: () {
                                    context.read<FavoriteBloc>().add(DeleteFavoriteEvent(item['name'], userEmail));
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
