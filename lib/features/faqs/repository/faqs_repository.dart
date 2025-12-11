import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/features/faqs/model/faqs_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/services/i_error_handler_service.dart';
import 'i_faqs_repository.dart';

class FAQSRepository implements IFAQSRepository {
  final IErrorHandlerService _errorHandler;

  FAQSRepository(this._errorHandler);

  @override
  Future<Either<String, FAQSResponse>> getFaqs(
      BuildContext context, {int? limit, dynamic lastDocument}) async {
    try {
      // Build query with pagination
      Query query = FirebaseConstants.firestore
          .collection(FirebaseConstants.faqsCollection);

      // Apply pagination if limit is provided
      if (limit != null) {
        query = query.limit(limit);
      }

      // If lastDocument is provided, start after it
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();

      final faqs = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return QuestionsData.fromJson(data);
      }).toList();

      return Right(FAQSResponse(
        faqs: faqs,
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      ));
    } catch (e) {
      return Left(_errorHandler.errorHandler(e.toString(), context));
    }
  }
}
