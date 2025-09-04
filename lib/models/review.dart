class Review {
  final String username;
  final int rating; // 1-5
  final String? text;
  final DateTime date;

  Review({
    required this.username,
    required this.rating,
    this.text,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      username: json['username'],
      rating: json['rating'],
      text: json['text'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'rating': rating,
        'text': text,
        'date': date.toIso8601String(),
      };
}

