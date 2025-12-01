import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/faqs/model/faqs_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/errors/api_errors.dart';
import '../../../core/helpers/firebase_helper.dart';
import 'faqs_repository.dart';

class FAQSRepositoryImplementation implements FAQSRepository {
  @override
  Future<Either<Failure, List<QuestionsData>>> getFaqs(
      BuildContext context) async {
    try {
      final snapshot = await FirebaseHelper.firestore
          .collection(FirebaseHelper.faqsCollection)
          .get();

      final faqs = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return QuestionsData.fromJson(data);
      }).toList();

      return Right(faqs);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
