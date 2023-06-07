class Player {
  final String? nickname;
  final String? socketID;
  final double? points;
  final String? playerType;
  Player({
    required this.nickname,
    required this.socketID,
    required this.points,
    required this.playerType,
  });

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nickname': nickname,
      'socketID': socketID,
      'points': points,
      'playerType': playerType,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      nickname: map['nickname'] != null ? map['nickname'] as String : null,
      socketID: map['socketID'] != null ? map['socketID'] as String : null,
      points: map['points'] != null ? map['points'] as double : null,
      playerType: map['playerType'] != null ? map['playerType'] as String : null,
    );
  }

  Player copyWith({
    String? nickname,
    String? socketID,
    double? points,
    String? playerType,
  }) {
    return Player(
      nickname: nickname ?? this.nickname,
      socketID: socketID ?? this.socketID,
      points: points ?? this.points,
      playerType: playerType ?? this.playerType,
    );
  }
}
