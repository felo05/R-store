// Response wrapper for pagination
class FAQSResponse {
  FAQSResponse({
    this.faqs,
    this.lastDocument,
  });

  List<QuestionsData>? faqs;
  dynamic lastDocument; // For pagination
}

class FAQSModel {
  FAQSModel({
    this.status,
    this.message,
    this.data,
  });

  FAQSModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? status;
  dynamic message;
  Data? data;
}

class Data {
  Data({
    this.questionsData,
  });

  Data.fromJson(dynamic json) {
    if (json['data'] != null) {
      questionsData = [];
      json['data'].forEach((v) {
        questionsData?.add(QuestionsData.fromJson(v));
      });
    }
  }

  List<QuestionsData>? questionsData;
}

class QuestionsData {
  QuestionsData({
    this.question,
    this.answer,
  });

  QuestionsData.fromJson(dynamic json) {
    question = json['question'];
    answer = json['answer'];
  }

  String? question;
  String? answer;
}
