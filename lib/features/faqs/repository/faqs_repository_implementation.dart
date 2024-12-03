import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/features/faqs/model/faqs_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/constants/kapi.dart';
import '../../../core/errors/api_errors.dart';
import '../../../core/helpers/dio_helper.dart';
import 'faqs_repository.dart';

class FAQSRepositoryImplementation implements FAQSRepository {
  @override
  Future<Either<Failure, List<QuestionsData>>> getFaqs(
      BuildContext context) async {
    try {
      final response = await DioHelpers.getData(path: Kapi.faqs);
      if(response.data["status"] == false) return Left(ServerFailure(response.data["message"]));
      return Right(FAQSModel.fromJson(response.data).data!.questionsData!);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e, context));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
