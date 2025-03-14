import 'package:flutter/material.dart';

import '../../core/constants/images.dart';

class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems = [
    {
      "name": "Washing Machine",
      "price": 10675.00,
      "quantity": 1,
      "image": Images.refrigerators
    },
    {
      "name": "Washing Machine",
      "price": 10675.00,
      "quantity": 1,
      "image": Images.refrigerators
    },
    {
      "name": "Washing Machine",
      "price": 10675.00,
      "quantity": 1,
      "image": Images.refrigerators
    },
    {
      "name": "Refrigerator",
      "price": 22675.00,
      "quantity": 1,
      "image": Images.refrigerators
    },
  ];

  final Map<String, dynamic> proposalItem = {
    "name": "Sensor",
    "price": 900.00,
    "image": Images.refrigerators
  };

  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double subtotal = cartItems.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));
    double deliveryFee = 60.20;
    double totalCost = subtotal + deliveryFee + proposalItem["price"];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Text("Cart",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.blue,
              child: Text(cartItems.length.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return CartItemCard(cartItems[index]);
                },
              ),
            ),
            ProposalSection(proposalItem),
            const SizedBox(height: 15),
            SummarySection(
                subtotal: subtotal,
                delivery: deliveryFee,
                totalCost: totalCost),
            const SizedBox(height: 15),
            CheckoutButton(),
          ],
        ),
      ),
    );
  }
}

// Cart Item Widget
class CartItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const CartItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(item["image"],
                height: 80, width: 80, fit: BoxFit.cover),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Efficient, quiet, and smart washing with advanced technology",
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item["name"],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "EGP ${item["price"].toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {},
                      ),
                      const Spacer(),
                      QuantitySelector(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Quantity Selector Widget
class QuantitySelector extends StatelessWidget {
  const QuantitySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () {}),
        const Text("1", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () {}),
      ],
    );
  }
}

// Proposal Section
class ProposalSection extends StatelessWidget {
  final Map<String, dynamic> proposal;

  const ProposalSection(this.proposal, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("proposal",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text("Sensor to make the device more distinctive. Buy it now"),
            const SizedBox(height: 10),
            Row(
              children: [
                Image.asset(proposal["image"],
                    height: 50, width: 50, fit: BoxFit.cover),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(proposal["name"],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("EGP ${proposal["price"]}",
                          style: const TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                  child: Text("Add sensor"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Summary Section
class SummarySection extends StatelessWidget {
  final double subtotal;
  final double delivery;
  final double totalCost;

  const SummarySection(
      {super.key, required this.subtotal,
      required this.delivery,
      required this.totalCost});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SummaryRow(label: "Sensor", value: 900),
        SummaryRow(label: "Subtotal", value: subtotal),
        SummaryRow(label: "Delivery", value: delivery),
        const Divider(thickness: 1),
        SummaryRow(label: "Total Cost", value: totalCost, isBold: true),
      ],
    );
  }
}

// Summary Row Widget
class SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;

  const SummaryRow({super.key, required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text("EGP ${value.toStringAsFixed(2)}",
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

// Checkout Button
class CheckoutButton extends StatelessWidget {
  const CheckoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.blue),
      child: Text("Checkout"),
    );
  }
}
