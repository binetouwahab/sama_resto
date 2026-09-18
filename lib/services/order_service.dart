import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> placeOrder(OrderModel order) {
    return _db.collection('orders').doc().set(order.toMap());
  }

  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => OrderModel.fromMap(d.data(), d.id))
            .toList());
  }
}