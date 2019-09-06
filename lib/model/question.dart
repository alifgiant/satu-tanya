import 'dart:convert';

final questionsRemoteUrl =
    'https://raw.githubusercontent.com/alifgiant/satu-tanya/master/data/questions.json';

class Question {
  static final key = 'QUESTION';

  final String id;
  final String content;
  final String writer;
  final String categoryId;
  bool isLoved;

  Question(this.id, this.content, this.writer, this.categoryId,
      {this.isLoved = false});

  Question copyWith(
      {String id,
      String content,
      String writer,
      String categoryId,
      bool isLoved}) {
    return Question(
      id == null ? this.id : id,
      content == null ? this.content : content,
      writer == null ? this.writer : writer,
      categoryId == null ? this.categoryId : categoryId,
      isLoved: isLoved == null ? this.isLoved : isLoved,
    );
  }

  factory Question.fromJson(Map<String, dynamic> parsedJson) {
    return Question(
      parsedJson['id'],
      parsedJson['content'],
      parsedJson['writer'],
      parsedJson['categoryId'],
      isLoved: parsedJson['isLoved'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'writer': writer,
      'categoryId': categoryId,
      'isLoved': isLoved,
    };
  }

  static String toJsonOfList(List<Question> questions) {
    return jsonEncode(questions.map((q) => q.toMap()).toList());
  }
}

final List<Question> dummyQuestions = [
  Question('0', 'Siapa orang paling kamu sayang?', 'SatuTanya', '1'),
  Question('1', 'Seberapa berharga uang bagi kamu?', 'SatuTanya', '1'),
  Question('2', 'Dimana saja daerah sensitif pasangan kamu?', 'SatuTanya', '2'),
  Question('3', 'Berapa banyak kamu habiskan uang hari ini?', 'SatuTanya', '1'),
  Question('4', 'Hal apa yang ingin kamu lupakan?', 'SatuTanya', '3'),
  Question('5', 'Mengapa kamu menyukai hobi mu sekarang?', 'SatuTanya', '3'),
  Question('6', 'Siapa artis paling jorok menurut mu?', 'SatuTanya', '0'),
  Question('7', 'Siapa tokoh kartun favorite mu?', 'SatuTanya', '4'),
];
