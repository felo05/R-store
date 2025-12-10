import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/faqs/model/faqs_model.dart';
import 'package:flutter/cupertino.dart';


abstract class IFAQSRepository {
  Future<Either<String,List<QuestionsData>>> getFaqs(BuildContext context);
}

