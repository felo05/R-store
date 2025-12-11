import 'package:e_commerce/core//constants/Kcolors.dart';
import 'package:e_commerce/core//widgets/back_appbar.dart';
import 'package:e_commerce/core/widgets/skeleton_loaders.dart';
import 'package:e_commerce/features/faqs/repository/i_faqs_repository.dart';
import 'package:e_commerce/features/faqs/viewmodel/faqs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/localization/l10n/app_localizations.dart';

import '../../model/faqs_model.dart';
import '../widgets/faqs_card.dart';

class FAQSScreen extends StatelessWidget {
  const FAQSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FAQSCubit(sl<IFAQSRepository>())..getFAQS(context),
      child: const _FAQSScreenContent(),
    );
  }
}

class _FAQSScreenContent extends StatefulWidget {
  const _FAQSScreenContent();

  @override
  State<_FAQSScreenContent> createState() => _FAQSScreenContentState();
}

class _FAQSScreenContentState extends State<_FAQSScreenContent> {
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
      final cubit = context.read<FAQSCubit>();
      final state = cubit.state;
      if (state is FAQSSuccessState) {
        if (state.lastDocument != null) {
          setState(() => _isLoadingMore = true);
          cubit.loadMoreFAQS(context, state.questionsData, state.lastDocument).then((_) {
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
          title: AppLocalizations.of(context)!.faqs,
          color: baseColor,
          textColor: Colors.black),
      body: BlocConsumer<FAQSCubit, FAQSState>(
        listener: (context, state) {
          if (state is FAQSErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FAQSSuccessState || state is FAQSLoadingMoreState) {
            List<QuestionsData> questionsData;
            bool showLoadingMore = false;

            if (state is FAQSSuccessState) {
              questionsData = state.questionsData;
            } else {
              questionsData = (state as FAQSLoadingMoreState).currentFaqs;
              showLoadingMore = true;
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: questionsData.length + (showLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == questionsData.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(color: baseColor),
                      ),
                    );
                  }
                  return FAQCard(questionsData: questionsData[index]);
                },
              ),
            );
          } else if (state is FAQSLoadingState) {
            return const FAQListSkeleton(itemCount: 8);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
