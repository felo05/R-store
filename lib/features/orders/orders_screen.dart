import 'package:e_commerce/core/constants/Kcolors.dart';
import 'package:e_commerce/core/widgets/back_appbar.dart';
import 'package:e_commerce/features/orders/cubit/get_orders_cubit.dart';
import 'package:e_commerce/features/orders/orders_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/widgets/custom_text.dart';
import 'model/orders_model.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
         context.read<GetOrdersCubit>().getOrders(context);
      },
      child: Scaffold(
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
            if (state is GetOrdersLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GetOrdersSuccessState) {
              List<BaseOrders> orders = state.orders;
              if (orders.isEmpty) {
                return SingleChildScrollView(
                  child: Center(
                    child: CustomText(
                      text: AppLocalizations.of(context)!.no_orders_available,
                      textSize: 20,
                      textColor: Colors.black,
                      textWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (ctx, index) =>
                    OrderDetailsCard(order: orders[index]),
                physics: const AlwaysScrollableScrollPhysics(),
              );
            }
            return const SingleChildScrollView(
              child: SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}
