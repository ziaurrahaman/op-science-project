import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opScienceProject/models/user.dart';
import 'package:opScienceProject/utils/auth_client.dart';

class DatabaseClient {
  DatabaseClient._privateConstructor();
  static final DatabaseClient instance = DatabaseClient._privateConstructor();

  final _db = Firestore.instance;

  Future<void> implementLikeOrDislike(
      User user, User currentUser, String userId) async {
    if (userId == null) {
      return;
    }
    if (!user.likes.contains(userId)) {
      user.likes.add(userId);
      await Firestore.instance
          .collection('users')
          .document(user.userId)
          .updateData({
        'likes': user.likes.length == 0 ? [] : user.likes,
      });
      currentUser.liked.add(user.userId);
      await Firestore.instance.collection('users').document(userId).updateData({
        'liked': currentUser.liked.length == 0 ? [] : currentUser.liked,
      });

      return;
    }
    if (user.likes.contains(userId)) {
      user.likes.remove(userId);
      await Firestore.instance
          .collection('users')
          .document(user.userId)
          .updateData({
        'likes': user.likes.length == 0 ? [] : user.likes,
      });
      currentUser.liked.remove(user.userId);
      await Firestore.instance.collection('users').document(userId).updateData(
          {'liked': currentUser.liked.length == 0 ? [] : currentUser.liked});

      return;
    }
  }

  Future<void> implementSubscribeOrUnsubscribe(
      User user, User currentUser, String userId) async {
    if (userId == null) {
      return;
    }
    if (!user.subscribers.contains(userId)) {
      user.subscribers.add(userId);
      await Firestore.instance
          .collection('users')
          .document(user.userId)
          .updateData({
        'subscribers': user.subscribers.length == 0 ? [] : user.subscribers,
      });
      currentUser.subscribed.add(user.userId);
      await Firestore.instance.collection('users').document(userId).updateData({
        'subscribed':
            currentUser.subscribed.length == 0 ? [] : currentUser.subscribed,
      });
      return;
    }
    if (user.subscribers.contains(userId) && userId != user.userId) {
      user.subscribers.remove(userId);
      await Firestore.instance
          .collection('users')
          .document(user.userId)
          .updateData({
        'subscribers': user.subscribers.length == 0 ? [] : user.subscribers,
      });
      currentUser.subscribed.remove(user.userId);
      await Firestore.instance.collection('users').document(userId).updateData({
        'subscribed':
            currentUser.subscribed.length == 0 ? [] : currentUser.subscribed,
      });
      return;
    }
  }

  Future<User> getFavouriteUser(String currentUserId, User currentUser) async {
    User userWhosFavouritesContainCurrentUserId;

    if (currentUser.favourited != null) {
      var document = await Firestore.instance
          .collection('users')
          .document(currentUser.favourited)
          .get();

      userWhosFavouritesContainCurrentUserId = User.fromMap(document.data);
    }

    return userWhosFavouritesContainCurrentUserId;
  }

  Future<void> implementFavourite(
      User user, User currentUser, String userId) async {
    var document2 =
        await Firestore.instance.collection('users').document(userId).get();
    var currentUser2 = User.fromMap(document2.data);

    if (userId == null) {
      return;
    }

    if (currentUser2.favourited != null) {
      var document = Firestore.instance
          .collection('users')
          .document(currentUser2.favourited);

      print('currentUser.favourited: ${currentUser2.favourited}');

      document.get().then((value) async {
        var userWhosFavouritesContainCurrentUserId = User.fromMap(value.data);

        print(userWhosFavouritesContainCurrentUserId.name);

        if (userWhosFavouritesContainCurrentUserId.favourites
            .contains(userId)) {
          userWhosFavouritesContainCurrentUserId.favourites.remove(userId);
          await Firestore.instance
              .collection('users')
              .document(userWhosFavouritesContainCurrentUserId.userId)
              .updateData({
            'favourites':
                userWhosFavouritesContainCurrentUserId.favourites.length == 0
                    ? []
                    : userWhosFavouritesContainCurrentUserId.favourites,
          });

          return;
        }
      });
    }

    if (!user.favourites.contains(userId)) {
      user.favourites.add(userId);
      await Firestore.instance
          .collection('users')
          .document(user.userId)
          .updateData({
        'favourites': user.favourites.length == 0 ? [] : user.favourites,
      });

      await Firestore.instance
          .collection('users')
          .document(currentUser.userId)
          .updateData({'favourited': user.userId});

      return;
    }
    if (user.favourites.contains(userId)) {
      user.favourites.remove(userId);
      await Firestore.instance
          .collection('users')
          .document(user.userId)
          .updateData({
        'favourites': user.favourites.length == 0 ? [] : user.favourites,
      });
      await Firestore.instance
          .collection('users')
          .document(currentUser.userId)
          .updateData({'favourited': null});

      return;
    }
  }

  bool isFavouritedAlready(User user, String currentUserId, User currentUser) {
    bool isFavourited;
    if (currentUserId == null) {
      return false;
    }
    if (currentUser.favourited == null) {
      isFavourited = false;
    }
    if (!user.favourites.contains(currentUserId)) {
      isFavourited = false;
    }
    if (user.favourites.contains(currentUserId)) {
      isFavourited = true;
    }

    return isFavourited;
  }

  Future<List<User>> sortUsersAccordingToFavourite() async {
    final AuthClient authClient = AuthClient.instance;
    String currentUserId = await authClient.uid();
    User userWhosFavouritesContainCurrentUserId;
    DocumentSnapshot documentSnapshot = await Firestore.instance
        .collection('users')
        .document(currentUserId)
        .get();
    User currentUser = User.fromMap(documentSnapshot.data);
    if (currentUser.favourited != null) {
      var document = await Firestore.instance
          .collection('users')
          .document(currentUser.favourited)
          .get();

      userWhosFavouritesContainCurrentUserId = User.fromMap(document.data);
      print(
          'Favourite User Name: ${userWhosFavouritesContainCurrentUserId.name}');
    }

    List<User> sortedUsers = List();
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection('users').getDocuments();
    querySnapshot.documents.forEach((element) {
      User elementUSer = User.fromMap(element.data);
      if (!sortedUsers.contains(userWhosFavouritesContainCurrentUserId)) {
        print('First index userName: ${elementUSer.name}');
        sortedUsers.insert(0, userWhosFavouritesContainCurrentUserId);
      }
      if (!sortedUsers.contains(element.data) &&
          !sortedUsers
              .contains(userWhosFavouritesContainCurrentUserId.userId)) {
        sortedUsers.add(elementUSer);
      }
    });
    sortedUsers.forEach((element) {
      print(element.name);
    });
    return sortedUsers;
  }
}
