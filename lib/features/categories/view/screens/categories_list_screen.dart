import 'package:e_commerce/core/constants/Kcolors.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/widgets/back_appbar.dart';
import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:e_commerce/features/categories/repository/i_categories_repository.dart';
import 'package:e_commerce/features/categories/viewmodel/categories_list/categories_list_cubit.dart';
import 'package:e_commerce/features/home/models/categories_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerce/core/localization/l10n/app_localizations.dart';

import '../../../../core/widgets/skeleton_loaders.dart';
import '../../../home/view/widgets/category_card.dart';

class CategoriesListScreen extends StatelessWidget {
  const CategoriesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoriesListCubit(sl<ICategoriesRepository>())..getCategories(context),
      child: const _CategoriesListContent(),
    );
  }
}

class _CategoriesListContent extends StatefulWidget {
  const _CategoriesListContent();

  @override
  State<_CategoriesListContent> createState() => _CategoriesListContentState();
}

class _CategoriesListContentState extends State<_CategoriesListContent> {
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

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<CategoriesListCubit>().state;
      if (state is CategoriesListSuccessState) {
        if (state.lastDocument != null) {
          setState(() => _isLoadingMore = true);
          context
              .read<CategoriesListCubit>()
              .loadMoreCategories(context, state.categories, state.lastDocument)
              .then((_) {
            if (mounted) setState(() => _isLoadingMore = false);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: BackAppBar(
        title: AppLocalizations.of(context)!.categories,
        color: backgroundColor,
        textColor: Colors.black,
      ),
      body: BlocConsumer<CategoriesListCubit, CategoriesListState>(
        listener: (context, state) {
          if (state is CategoriesListErrorState) {
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
              context.read<CategoriesListCubit>().getCategories(context);
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildCategoriesContent(context, state),
          );
        },
      ),
    );
  }

  Widget _buildCategoriesContent(BuildContext context, CategoriesListState state) {
    if (state is CategoriesListLoadingState) {
      return const CategoryGridSkeleton(itemCount: 10);
    }

    if (state is CategoriesListSuccessState || state is CategoriesListLoadingMoreState) {
      List<CategoriesData> categories;
      bool showLoadingMore = false;

      if (state is CategoriesListSuccessState) {
        categories = state.categories;
      } else {
        categories = (state as CategoriesListLoadingMoreState).currentCategories;
        showLoadingMore = true;
      }

      if (categories.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          children: const [
            SizedBox(height: 100),
            Center(
              child: CustomText(
                text: 'No Categories Available',
                textSize: 20,
                textColor: Colors.black,
                textWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }

      return GridView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.85,
        ),
        itemCount: categories.length + (showLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == categories.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(color: baseColor),
              ),
            );
          }

          final category = categories[index];
          return CategoryCard(category: category);
        },
      );
    }

    // Error or initial state
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      children: const [
        SizedBox(height: 100),
        Center(
          child: CustomText(
            text: 'No Categories Available',
            textSize: 20,
            textColor: Colors.black,
            textWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
