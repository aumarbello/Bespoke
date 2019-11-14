import 'dart:math';

import 'package:bespoke/models/order_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersItem extends StatefulWidget {
  final OrderItem order;

  OrdersItem(this.order);

  @override
  _OrdersItemState createState() => _OrdersItemState();
}

class _OrdersItemState extends State<OrdersItem>
    with SingleTickerProviderStateMixin {
  var _isExpanded = false;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _opacityAnimation = Tween<double>(begin: 0, end: 1,).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceInOut,
    ));
    _slideAnimation =
        Tween<Offset>(begin: Offset(0, -1,), end: Offset(0, 0,),).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.bounceInOut,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(
        12,
      ),
      elevation: 5,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "\$${widget.order.amount}",
            ),
            subtitle: Text(
              DateFormat.yMMMEd().format(widget.order.orderTime),
            ),
            trailing: IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                  if (_isExpanded) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                });
              },
            ),
          ),
//          if (_isExpanded)
          AnimatedContainer(
            duration: Duration(
              milliseconds: 200,
            ),
            constraints: BoxConstraints(
                minHeight: _isExpanded ? 20 : 0,
                maxHeight: _isExpanded ? 120 : 0),
            padding: EdgeInsets.all(12),
            height: min(
              (widget.order.products.length * 30.0 + 10),
              120,
            ),
            child: FadeTransition(
              opacity: _opacityAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ListView.builder(
                    itemBuilder: (_, index) {
                      final product = widget.order.products[index];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            product.title,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "${product.quantity} x \$ ${product.amount}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      );
                    },
                    itemCount: widget.order.products.length,
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  }
}
