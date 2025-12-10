import 'package:e_commerce/core/constants/Kcolors.dart';
import 'package:e_commerce/core/widgets/back_appbar.dart';
import 'package:e_commerce/features/orders/view/widgets/orders_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/core/localization/l10n/app_localizations.dart';
import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:e_commerce/features/orders/model/orders_model.dart';

import '../../viewmodel/get_orders_cubit.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        title: AppLocalizations.of(context)!.orders,
        color: baseColor,
        textColor: Colors.black,
      ),
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
          return RefreshIndicator(
            color: baseColor,
            onRefresh: () async {
              context.read<GetOrdersCubit>().getOrders(context);
              // Wait for the state to update
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildOrderContent(context, state),
          );
        },
      ),
    );
  }

  Widget _buildOrderContent(BuildContext context, GetOrdersState state) {
    if (state is GetOrdersLoadingState) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 200),
          Center(child: CircularProgressIndicator(color: baseColor)),
        ],
      );
    }

    if (state is GetOrdersSuccessState) {
      List<BaseOrders> orders = state.orders;
      if (orders.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 100),
            Center(
              child: CustomText(
                text: AppLocalizations.of(context)!.no_orders_available,
                textSize: 20,
                textColor: Colors.black,
                textWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }

      return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, index) => OrderDetailsCard(order: orders[index]),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
      );
    }

    // Error or initial state
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 100),
        Center(
          child: CustomText(
            text: AppLocalizations.of(context)!.no_orders_available,
            textSize: 20,
            textColor: Colors.black,
            textWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
