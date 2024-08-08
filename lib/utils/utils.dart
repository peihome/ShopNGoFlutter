import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shopngoflutter/activity/cart_activity.dart';
import 'package:shopngoflutter/activity/product_home_page_activity.dart';

class Utils {
  static const String appRoot = "shopNGo";
  static const String province = "$appRoot/province";
  static const String vendorVsRegex = "$appRoot/vendorVsRegex";
  static const String products = "$appRoot/products";
  static const String users = "$appRoot/users";
  static const String fruits = "$products/fruits";
  static const String veggies = "$products/veggies";
  static const String beverages = "$products/beverages";
  static const String flyers = "$appRoot/flyers";
  static const String flyerImages = "$flyers/images";
  static const String TAG = "Utils";
  static int totalQuantity = 0;
  static double taxFloat = 0.0;
  static double discount = 0.0;

  static void addDataToFireStore(
      Map<String, dynamic> obj,
      String? path,
      Function() onCompleteListener) {
    FirebaseFirestore.instance
        .collection(path!)
        .add(obj)
        .then((documentReference) {
      onCompleteListener();
    }).catchError((e) {
      onCompleteListener(); // Handle error
    });
  }

  static void getFireStoreData(String? path, Function(QuerySnapshot?) onCompleteListener) {
    FirebaseFirestore.instance
        .collection(path!)
        .get()
        .then((querySnapshot) {
      onCompleteListener(querySnapshot);
    }).catchError((e) {
      onCompleteListener(null);
    });
  }

  static void getFireStoreDataFromSubCollection(String? path, Function(DocumentSnapshot?) onCompleteListener) {
    FirebaseFirestore.instance
        .doc(path!)
        .get()
        .then((documentSnapshot) {
      onCompleteListener(documentSnapshot);
    }).catchError((e) {
      onCompleteListener(null);
    });
  }

  static void getFireStoreDataById(
      String? path, String? id, Function(DocumentSnapshot?) onCompleteListener) {
    FirebaseFirestore.instance
        .collection(path!)
        .doc(id!)
        .get()
        .then((documentReference) {
      onCompleteListener(documentReference);
    }).catchError((e) {
      onCompleteListener(null);
    });
  }

  static void getFireStoreDataByIds(String? path, List<String?>? documentIds,
      Function(QuerySnapshot?)? onCompleteListener) {
    FirebaseFirestore.instance
        .collection(path!)
        .where(FieldPath.documentId, whereIn: documentIds!)
        .get()
        .then((querySnapshot) {
      onCompleteListener?.call(querySnapshot);
    });
  }

  static void updateFirestoreDataById(String? path, String? id,
      Map<String, dynamic> obj,
      Function()? onCompleteListener) {
    FirebaseFirestore.instance
        .collection(path!)
        .doc(id!)
        .update(obj)
        .then((value) => onCompleteListener?.call());
  }

  static void addMapDataToRealTimeDataBase(
      Map<String?, dynamic>? obj, String? path) {
    FirebaseDatabase.instance.ref(path!).set(obj);
  }

  static void addMapDataToRealTimeDataBaseWithSuccess(
      Map<String?, dynamic>? obj,
      String? path,
      Function() onSuccessListener) {
    FirebaseDatabase.instance.ref(path!).set(obj).then((value) {
      onSuccessListener();
    });
  }

  static void getMapDataFromRealTimeDataBase(
      String? path, Function(Map<String?, dynamic>?) listener) {
    FirebaseDatabase.instance.ref(path!).get().then((dataSnapshot) {
      listener(dataSnapshot.value as Map<String?, dynamic>?);
    }).catchError((databaseError) {
      listener(null);
    });
  }

  static void deleteDataFromRealTimeDatabase(
      String? path, Function() onSuccessListener) {
    FirebaseDatabase.instance.ref(path!).remove().then((value) {
      onSuccessListener();
    });
  }

  void setProductQuantityForUser(
      String userId,
      String? productId,
      bool isIncrease,
      ValueNotifier<String> proceedButton,
      ValueNotifier<String> grandsubtotal,
      BuildContext? context) {
    getMapDataFromRealTimeDataBase(getUserCartItemsPath(userId),
            (productVsQuantity) {
          int quantityFromRemote = (productVsQuantity?.putIfAbsent(productId, () => 0) ?? 0);
          if (isIncrease) {
            quantityFromRemote++;
          } else {
            quantityFromRemote--;
          }
          if (quantityFromRemote <= 0) {
            productVsQuantity?.remove(productId);
          } else if (quantityFromRemote >= 20) {
            quantityFromRemote = 20;
            productVsQuantity![productId] = quantityFromRemote;
          } else {
            productVsQuantity![productId] = quantityFromRemote;
          }
          addMapDataToRealTimeDataBase(productVsQuantity, getUserCartItemsPath(userId));
          handleTotalPriceChange(userId, proceedButton, grandsubtotal, Null as ValueNotifier<String>, Null as ValueNotifier<String>, context, Null as ValueNotifier<String>);
        });
  }

  static String getUserCartItemsPath(String userId) {
    return "$users/$userId/products";
  }

  static String getUserAddressPath(String userId) {
    return "$users/$userId/address";
  }

  static String getUserCardPath(String userId) {
    return "$users/$userId/card";
  }

  static AppBar addHomeIconNavigation(BuildContext context, AppBar menuBar) {
    return AppBar(
      title: menuBar.title,
      actions: menuBar.actions,
      backgroundColor: menuBar.backgroundColor,
      elevation: menuBar.elevation,
      leading: IconButton(
        icon: Icon(Icons.home),
        onPressed: () {
          if (context.runtimeType != ProductHomePageActivity) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => ProductHomePageActivity()));
          }
        },
      ),
    );
  }

  static void handleMenuClick(BuildContext context, String itemId) {
    switch (itemId) {
      case "cartIcon":
        if (context.runtimeType == CartActivity) {
          return;
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CartActivity()));
        break;
    }
  }

  static String getSubtotalStr(int quantity, double price) {
    return (quantity * price).toStringAsFixed(2);
  }

  static double getSubtotalFloat(int quantity, double price) {
    return quantity * price;
  }

  void handleTotalPriceChange(
      String userId,
      ValueNotifier<String> proceedToBuy,
      ValueNotifier<String> total,
      ValueNotifier<String> tax,
      ValueNotifier<String> subTotal,
      BuildContext? context,
      ValueNotifier<String> discountTV) {
    totalQuantity = 0;
    taxFloat = 0.0;
    discount = 0.0;
    getMapDataFromRealTimeDataBase(getUserCartItemsPath(userId),
            (dataMap) {
          List<String?> products = [];
          dataMap?.forEach((key, value) {
            products.add(key);
            totalQuantity += value as int;
          });

          if (products.isNotEmpty) {
            // Fetch fruits
            getFireStoreDataByIds(fruits, products, (task) {
              List<double> subTotals = [];
              task?.docs?.forEach((document) {
                int quantity = dataMap?[document.id] as int;
                Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
                double? price = data?['price'] as double?;
                handleCalculation(document, quantity, price!, subTotals);
              });
              setTotalAmount(subTotals, null, proceedToBuy, total, tax, subTotal, discountTV);
            });
          }
        });
  }

  void handleCalculation(
      QueryDocumentSnapshot document,
      int quantity, // Use int instead of byte in Dart
      double price,
      List<double> subTotals, // Use List<double> instead of ArrayList<Float>
      ) {
    double subTotal = getSubtotalFloat(quantity, price); // Assuming getSubtotal returns a double
    double taxPercent = 0.0;
    double discountPercent = 0.0;

    try {
      // Safely convert tax percent
      taxPercent = double.tryParse(document.get("tax")?.toString() ?? '') ?? 0.0;
    } catch (e) {
      // Handle the exception if needed
    }

    try {
      // Safely convert discount percent
      discountPercent = double.tryParse(document.get("discount")?.toString() ?? '') ?? 0.0;
    } catch (e) {
      // Handle the exception if needed
    }

    final data = document.data() as Map<String, dynamic>?;

    if (data != null) {
      if (data.containsKey("tax")) {
        taxFloat += getSubtotalFloat(1, subTotal * taxPercent); // Assuming taxFloat is defined elsewhere
      }

      if (data.containsKey("discount")) {
        discount += getSubtotalFloat(1, subTotal * discountPercent); // Assuming discount is defined elsewhere
      }
    }

    subTotals.add(subTotal);
  }

  static void setTotalAmount(
      List<double> subTotals,
      void Function()? onProceed,
      ValueNotifier<String> proceedButtonText,
      ValueNotifier<String> totalText,
      ValueNotifier<String> taxText,
      ValueNotifier<String> subTotalViewText,
      [ValueNotifier<String>? discountTVText]) {

    double totalAmount = subTotals.fold(0, (previous, element) => previous + element);
    String itemStr = "(${subTotals.length} items)";
    if (subTotals.length == 1) {
      itemStr = "(${subTotals.length} item)";
    }

    // Update the ValueNotifiers, which will automatically rebuild the UI where they are used
    proceedButtonText.value = "Proceed to checkout $itemStr";
    taxText.value = "\$ ${getSubtotalStr(1, taxFloat)}";
    discountTVText?.value = "\$ ${getSubtotalStr(1, discount)}";
    subTotalViewText.value = "\$ ${getSubtotalStr(1, totalAmount + taxFloat - discount)}";
    totalText.value = "\$ ${getSubtotalStr(1, totalAmount)}";
  }

  static String getMaskedCardNumberForDisplay(String cardNumber) {
    return cardNumber.replaceRange(0, cardNumber.length - 4, '*' * (cardNumber.length - 4));
  }

  static bool isValidEmail(String email) {
    RegExp regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    RegExp regex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{6,}$');
    return regex.hasMatch(password);
  }
}