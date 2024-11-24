import 'package:e_commerce/constants/Kcolors.dart';
import 'package:e_commerce/orders/cubit/get_orders_cubit.dart';
import 'package:e_commerce/orders/orders_card.dart';
import 'package:e_commerce/widgets/back_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/custom_text.dart';
import 'model/orders_model.dart';
class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetOrdersCubit>().getOrders();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
          title: "Orders", color: baseColor, textColor: Colors.black),
      body: BlocConsumer<GetOrdersCubit, GetOrdersState>(
        listener: (context, state) {
          if (state is GetOrdersErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GetOrdersLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetOrdersSuccessState) {
            List<BaseOrders> orders = state.orders;
            if (orders.isEmpty) {
              return const Center(
                child: CustomText(
                  text: "No orders available.",
                  textSize: 20,
                  textColor: Colors.black,
                  textWeight: FontWeight.w600,
                ),
              );
            }
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (ctx, index) => OrderDetailsCard(order: orders[index]),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
