import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/product_card.dart';
import '../product/product_detail_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';
import 'explore_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> get _screens => [
    const HomeContent(),
    const ExploreScreen(),
    FavoritesScreen(onGoShopping: () => setState(() => _selectedIndex = 0)),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Charger les données au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
      context.read<CartProvider>().fetchAndSetCart();
      context.read<OrderProvider>().startOrderListener(); // ACTIVER L'ÉCOUTE
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex != 3
          ? AppBar(
              title: Text(_getTitle()),
              actions: [
                Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    return Badge(
                      label: Text(cart.itemCount.toString()),
                      isLabelVisible: cart.itemCount > 0,
                      child: IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CartScreen()),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            )
          : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0: return 'E-Shop';
      case 1: return 'Explore';
      case 2: return 'My Favorites';
      default: return '';
    }
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(context),
        _buildCategories(),
        Expanded(child: _buildProductGrid(context)),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (val) => context.read<ProductProvider>().setSearchQuery(val),
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ['All', 'Furniture', 'Electronics', 'Shoes', 'Clothing'];
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: categories.map((cat) {
              final isSelected = provider.selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) => provider.setCategory(cat),
                  selectedColor: Colors.deepPurple,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final products = provider.products;
        if (products.isEmpty) {
          return const Center(child: Text('No products found'));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
              ),
            );
          },
        );
      },
    );
  }
}
