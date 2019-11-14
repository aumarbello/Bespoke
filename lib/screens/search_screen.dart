import 'package:bespoke/providers/products.dart';
import 'package:bespoke/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/search-products";

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _isSearching = true;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(),
        actions: _buildActions(),
      ),
      body: Consumer<Products>(
        builder: (ctx, data, _) => ListView.builder(
          itemBuilder: (_, index) {
            final product = data.searchResults[index];
            return ListTile(
              onTap: () => Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              ),
              leading: Hero(
                tag: product.id,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(product.imageUrl),
                ),
              ),
              title: Text(product.title),
              subtitle: Text(product.description),
            );
          },
          itemCount: data.searchResults.length,
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _controller,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: "Search Products",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16),
      textInputAction: TextInputAction.done,
      onSubmitted: (query) {
        if (query.isEmpty) {
          return;
        }

        Provider.of<Products>(context, listen: false).searchProducts(query);
      },
    );
  }

  Widget _buildTitle() {
    // Check if search results are back and alternatively set title to "Search Products"
    return Text("Search Results");
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (_controller.text == null || _controller.text.isEmpty) {
              Navigator.of(context).pop();
              setState(() {
                _isSearching = false;
              });
              return;
            } else {
              setState(() {
                _controller.clear();
              });
            }
          },
        )
      ];
    } else {
      return [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        )
      ];
    }
  }
}
