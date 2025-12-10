import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/faqs/model/faqs_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/services/i_error_handler_service.dart';
import 'i_faqs_repository.dart';

class FAQSRepository implements IFAQSRepository {
  final IErrorHandlerService _errorHandler;

  FAQSRepository(this._errorHandler);

  @override
  Future<Either<String, List<QuestionsData>>> getFaqs(
      BuildContext context) async {
    try {
      final snapshot = await FirebaseConstants.firestore
          .collection(FirebaseConstants.faqsCollection)
          .get();

      final faqs = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return QuestionsData.fromJson(data);
      }).toList();

      return Right(faqs);
    } catch (e) {
      return Left(_errorHandler.errorHandler(e.toString(), context));
    }
  }
}
