import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

int counter;
DatabaseReference counterRef;
DatabaseError error;

void init(FirebaseDatabase database) async {
  counterRef = FirebaseDatabase.instance.reference().child('test/counter');
  counterRef.keepSynced(true);
  database.setPersistenceEnabled(true);
  database.setPersistenceCacheSizeBytes(10000000);
}

Future<int> getCounter() async {
  int value;
  await counterRef.once().then((DataSnapshot snapshot) {
    print('Connected to the database and read ${snapshot.value}');
    value = snapshot.value;
  });
}

Future<Null> setCounter(int value) async {
  final TransactionResult transactionResult = await counterRef.runTransaction((MutableData mutableData) async {
    mutableData.value = value;
    return mutableData;
  });

  if(transactionResult.committed) {
    print('Saved value to the database');
  } else {
    print('Failed to save to the database!');
    if(transactionResult.error != null) {
      print(transactionResult.error.message);
    }
  }
}