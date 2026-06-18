import '../../../../core/network/api_client.dart';
import '../domain/transaction_model.dart';

abstract class TransactionRepository {
  Future<List<TransactionModel>> getTransactionsByStatus(String status);
  Future<TransactionModel> getTransactionDetail(int id);
}

class TransactionRepositoryImpl implements TransactionRepository {
  final _dio = ApiClient.instance.dio;

  @override
    Future<List<TransactionModel>> getTransactionsByStatus(String status) async {
    final response = await _dio.get('/api/transactions/by-status/$status');
    final List list = response.data;
    return list.map((json) => TransactionModel.fromJson(json)).toList();
  }

  @override
  Future<TransactionModel> getTransactionDetail(int id) async {
    final response = await _dio.get('/api/transactions/detail/$id');
    return TransactionModel.fromJson(response.data);
  }
}
