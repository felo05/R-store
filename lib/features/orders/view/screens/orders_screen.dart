import 'package:e_commerce/core/constants/Kcolors.dart';
import 'package:e_commerce/core/widgets/back_appbar.dart';
import 'package:e_commerce/core/widgets/skeleton_loaders.dart';
import 'package:e_commerce/features/orders/view/widgets/orders_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/core/localization/l10n/app_localizations.dart';
import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:e_commerce/features/orders/model/orders_model.dart';

import '../../viewmodel/get_orders_cubit.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<GetOrdersCubit>().state;
      if (state is GetOrdersSuccessState) {
        if (state.lastDocument != null) {
          setState(() => _isLoadingMore = true);
          context.read<GetOrdersCubit>().loadMoreOrders(context, state.orders, state.lastDocument).then((_) {
            if (mounted) setState(() => _isLoadingMore = false);
          });
        }
      }
    }
  }

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
      return const OrderListSkeleton(itemCount: 5);
    }

    if (state is GetOrdersSuccessState || state is GetOrdersLoadingMoreState) {
      List<BaseOrders> orders;
      bool showLoadingMore = false;

      if (state is GetOrdersSuccessState) {
        orders = state.orders;
      } else {
        orders = (state as GetOrdersLoadingMoreState).currentOrders;
        showLoadingMore = true;
      }

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
        controller: _scrollController,
        itemCount: orders.length + (showLoadingMore ? 1 : 0),
        itemBuilder: (ctx, index) {
          if (index == orders.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(color: baseColor),
              ),
            );
          }
          return OrderDetailsCard(order: orders[index]);
        },
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
