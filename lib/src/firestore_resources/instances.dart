import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'constants.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

CollectionReference get colUsers => _firestore.collection(kdbusers);
CollectionReference get colAdmins => _firestore.collection(kdbadmins);
CollectionReference get colAccounts => _firestore.collection(kdbaccounts);
CollectionReference get colPushs => _firestore.collection(kdbpushs);
CollectionReference get colKeyPremiums => _firestore.collection(kdbkeyPremiums);

final _storage = FirebaseStorage.instance;
Reference refByUrl(String url) => _storage.refFromURL(url);
Reference get refProducts => _storage.ref().child('products');
Reference get refUserAvatars => _storage.ref().child('user_avatars');
