import 'package:bespoke/providers/product.dart';
import 'package:bespoke/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-prooduct";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formData = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: "",
    description: "",
    imageUrl: "",
    price: 0,
  );
  var _isInit = true;
  var isLoading = false;

  @override
  void initState() {
    super.initState();

    _imageFocusNode.addListener(focusListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final productId = ModalRoute
          .of(context)
          .settings
          .arguments as String;
      if (productId == null) {
        return;
      }

      _editedProduct =
          Provider.of<Products>(context, listen: false).findById(productId);
      _imageUrlController.text = _editedProduct.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveForm,
          ),
        ],
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formData,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _editedProduct.title,
                decoration: InputDecoration(
                  labelText: "Title",
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_priceFocusNode),
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: value,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
                validator: (input) {
                  if (input.isEmpty) {
                    return "Product title can't be empty!";
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _editedProduct.price == 0
                    ? ""
                    : _editedProduct.price.toString(),
                decoration: InputDecoration(
                  labelText: "Price",
                ),
                textInputAction: TextInputAction.next,
                keyboardType:
                TextInputType.numberWithOptions(decimal: true),
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context)
                        .requestFocus(_descriptionFocusNode),
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    price: double.parse(value),
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
                validator: (input) {
                  if (input.isEmpty) {
                    return "Product price not specified!";
                  }

                  if (double.tryParse(input) == null) {
                    return "Please enter a valid number";
                  }

                  if (double.parse(input) <= 0) {
                    return "Invalid amount, Product price must ge greater than \$0";
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _editedProduct.description,
                decoration: InputDecoration(
                  labelText: "Description",
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: value,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
                validator: (input) {
                  if (input.isEmpty) {
                    return "Product description can't be empty!";
                  }

                  if (input.length < 10) {
                    return "Product description too short!";
                  }

                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 4,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Center(
                        child: Text(
                          "Enter Image URL",
                          textAlign: TextAlign.center,
                        ),
                      )
                          : FittedBox(
                        child: Image.network(
                          _imageUrlController.text,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Image URL",
                        ),
                        controller: _imageUrlController,
                        focusNode: _imageFocusNode,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          saveForm();
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: value,
                            price: _editedProduct.price,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Image url can't be empty!";
                          }

                          if (!input.startsWith("http")) {
                            return "Invalid image url format";
                          }

                          return null;
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _imageFocusNode.removeListener(focusListener);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageUrlController.dispose();
  }

  void focusListener() {
    if (!_imageFocusNode.hasFocus && _imageUrlController.text.isNotEmpty) {
      setState(() {});
    }
  }

  void saveForm() async {
    if (!_formData.currentState.validate()) {
      return;
    }

    _formData.currentState.save();
    setState(() {
      isLoading = true;
    });

    try {
      await Provider.of<Products>(context, listen: false)
          .insertOrUpdate(_editedProduct);
    } catch (error) {
      await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                "An error occured",
              ),
              content: Text("Request could not be completed at the moment"),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Okay",
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                )
              ],
            );
          });
    } finally {
      Navigator.of(context).pop();
    }
  }
}
