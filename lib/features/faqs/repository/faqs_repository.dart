import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/faqs/model/faqs_model.dart';
import 'package:flutter/cupertino.dart';

abstract class FAQSRepository {
  Future<Either<Failure,List<QuestionsData>>> getFaqs(BuildContext context);
}