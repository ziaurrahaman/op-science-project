import 'dart:convert';

class User extends Comparable {
  final String userId;
  final String name;
  final String email;
  final String imageUrl;
  final String phoneNumber;
  final String gender;
  final String dob;
  final String website;
  final String bio;
  final List<dynamic> likes;
  final List<dynamic> liked;
  final List<dynamic> subscribers;
  final List<dynamic> subscribed;
  final List<dynamic> favourites;
  final String favourited;
  final String flag;
  final String pinned;
  bool isFavourited;
  User({
    this.userId,
    this.name,
    this.email,
    this.imageUrl,
    this.phoneNumber,
    this.gender,
    this.dob,
    this.website,
    this.bio,
    this.likes,
    this.liked,
    this.subscribers,
    this.subscribed,
    this.favourites,
    this.favourited,
    this.flag,
    this.pinned,
    this.isFavourited,
  });

  User copyWith({
    String userId,
    String name,
    String email,
    String imageUrl,
    String phoneNumber,
    String gender,
    String dob,
    String website,
    String bio,
    List<dynamic> likes,
    List<dynamic> liked,
    List<dynamic> subscribers,
    List<dynamic> subscribed,
    List<dynamic> favourites,
    String favourited,
    String pinned,
  }) {
    return User(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      website: website ?? this.website,
      bio: bio ?? this.bio,
      likes: likes ?? this.likes,
      liked: liked ?? this.liked,
      subscribers: subscribers ?? this.subscribers,
      subscribed: subscribed ?? this.subscribed,
      favourites: favourites ?? this.favourites,
      favourited: favourited ?? this.favourited,
      flag: flag ?? this.flag,
      pinned: pinned ?? this.pinned,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'profile_picture': imageUrl,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dob': dob,
      'website': website,
      'bio': bio,
      'likes': likes,
      'liked': liked,
      'subscribers': subscribers,
      'subscribed': subscribed,
      'favourites': favourites,
      'favourited': favourited,
      'flag': flag,
      'pinned': pinned,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      userId: map['userId'],
      name: map['name'],
      email: map['email'],
      imageUrl: map['profile_picture'],
      phoneNumber: map['phoneNumber'],
      gender: map['gender'],
      dob: map['dob'],
      website: map['website'],
      bio: map['bio'],
      likes: List<dynamic>.from(map['likes']),
      liked: List<dynamic>.from(map['liked']),
      subscribers: List<dynamic>.from(map['subscribers']),
      subscribed: List<dynamic>.from(map['subscribed']),
      favourites: List<dynamic>.from(map['favourites']),
      favourited: map['favourited'],
      flag: map['flag'],
      pinned: map['pinned'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(userId: $userId, name: $name, email: $email, imageUrl: $imageUrl, phoneNumber: $phoneNumber, gender: $gender, dob: $dob, website: $website, bio: $bio, likes: $likes, liked: $liked, subscribers: $subscribers, subscribed: $subscribed, favourites:$favourites, favourited: $favourited, flag: $flag, pinned: $pinned)';
  }

  @override
  int compareTo(other) {
    if (other.isFavourited) {
      return 1;
    }
    return -1;
  }
}
