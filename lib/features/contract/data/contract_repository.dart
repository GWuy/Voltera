import '../../../../core/network/api_client.dart';
import '../domain/contract_model.dart';
import '../domain/product_info.dart';
import '../domain/user_info.dart';

abstract class ContractRepository {
  Future<ContractModel> getContract(String id);
  Future<List<ContractModel>> getContracts();
  Future<ContractModel> createContract(int postId);
  Future<ContractModel> signContract(String contractId);
  Future<ContractModel> cancelContract(String contractId);
  Future<ProductInfo> getProductInfo(int contractId);
}

class ContractRepositoryImpl implements ContractRepository {
  final _dio = ApiClient.instance.dio;

  @override
  Future<ContractModel> getContract(String id) async {
    final response = await _dio.get('/api/contract/$id');
    return _mapResponseToModel(response.data);
  }

  @override
  Future<List<ContractModel>> getContracts() async {
    final response = await _dio.get('/api/contract/list');
    final List list = response.data;
    return list.map((json) => _mapResponseToModel(json)).toList();
  }

  @override
  Future<ContractModel> createContract(int postId) async {
    final response = await _dio.post('/api/contract/create', data: {'postId': postId});
    return _mapResponseToModel(response.data);
  }

  @override
  Future<ContractModel> signContract(String contractId) async {
    final response = await _dio.put('/api/contract/$contractId/sign');
    return _mapResponseToModel(response.data);
  }

  @override
  Future<ContractModel> cancelContract(String contractId) async {
    final response = await _dio.put('/api/contract/$contractId/cancel');
    return _mapResponseToModel(response.data);
  }

  ContractModel _mapResponseToModel(dynamic data) {
    // Mapping backend response to our domain model
    // Note: The backend response has slightly different field names than our initial model
    return ContractModel(
      id: data['contractId'].toString(),
      transactionId: data['transactionId'] ?? 0,
      createdAt: data['signedDate'] != null 
          ? DateTime.parse(data['signedDate']) 
          : DateTime.now(),
      status: _mapStatus(data['contractStatus']),
      seller: UserInfo(
        fullName: data['sellerName'] ?? 'Unknown',
        email: data['sellerEmail'] ?? '',
      ),
      buyer: UserInfo(
        fullName: data['buyerName'] ?? 'Unknown',
        email: data['buyerEmail'] ?? '',
      ),
      // Since backend doesn't return full product info in contract response, 
      // we'd normally fetch it or use a placeholder if the UI only needs the title
      product: ProductInfo.vehicle(
        name: data['postTitle'] ?? 'Product',
        brand: '',
        model: '',
        version: '',
        yearManufacture: 0,
        batteryCapacity: 0,
        odo: 0,
        color: '',
        price: 0,
      ),
      salePrice: 0, // Should be in the response but adding placeholder
      signedBySeller: data['signedBySeller'] ?? false,
      signedByBuyer: data['signedByBuyer'] ?? false,
    );
  }

  @override
  Future<ProductInfo> getProductInfo(int contractId) async {
    final response = await _dio.get('/api/contract/product-infor/$contractId');
    final data = response.data;
    return _mapProductInfo(data);
  }

  ProductInfo _mapProductInfo(dynamic data) {
    final type = (data['type'] as String?)?.toUpperCase();
    if (type == 'VEHICLE') {
      return ProductInfo.vehicle(
        name: data['title'] ?? '',
        brand: data['brand'] ?? '',
        model: data['model'] ?? '',
        version: data['version'] ?? '',
        yearManufacture: data['yearManufacture'] ?? 0,
        batteryCapacity: (data['batteryCapacity'] ?? 0).toDouble(),
        odo: data['odo'] ?? 0,
        color: data['color'] ?? '',
        price: (data['price'] ?? 0).toDouble(),
      );
    } else {
      return ProductInfo.battery(
        name: data['title'] ?? '',
        serialNumber: data['serialNumber'] ?? '',
        originalCapacity: (data['originalCapacity'] ?? 0).toDouble(),
        remainingCapacity: (data['remainingCapacity'] ?? 0).toDouble(),
        voltage: (data['voltage'] ?? 0).toDouble(),
        cycleCount: data['cycleCount'] ?? 0,
        warranty: data['warranty'] ?? '',
        mileageCovered: data['mileageCovered'] ?? 0,
        price: (data['price'] ?? 0).toDouble(),
      );
    }
  }

  ContractStatus _mapStatus(String? status) {
    switch (status?.toUpperCase()) {
      case 'PENDING': return ContractStatus.pending;
      case 'SIGNED': return ContractStatus.signed;
      case 'CANCELLED': return ContractStatus.cancelled;
      case 'COMPLETED': return ContractStatus.completed;
      default: return ContractStatus.pending;
    }
  }
}

class FakeContractRepository implements ContractRepository {
  @override
  Future<ContractModel> getContract(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockContract(id);
  }

  @override
  Future<List<ContractModel>> getContracts() async {
    await Future.delayed(const Duration(seconds: 1));
    return [_mockContract('1'), _mockContract('2')];
  }

  @override
  Future<ContractModel> createContract(int postId) async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockContract('new-id');
  }

  @override
  Future<ContractModel> signContract(String contractId) async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockContract(contractId).copyWith(signedByBuyer: true);
  }

  @override
  Future<ContractModel> cancelContract(String contractId) async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockContract(contractId).copyWith(status: ContractStatus.cancelled);
  }

  @override
  Future<ProductInfo> getProductInfo(int contractId) async {
    await Future.delayed(const Duration(seconds: 1));
    return const ProductInfo.vehicle(
      name: 'VinFast VF e34',
      brand: 'VinFast',
      model: 'VF e34',
      version: 'Standard',
      yearManufacture: 2022,
      batteryCapacity: 42.0,
      odo: 15000,
      color: 'Blue',
      price: 500000000.0,
    );
  }

  ContractModel _mockContract(String id) {
    return ContractModel(
      id: id,
      transactionId: 1,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: ContractStatus.signed,
      seller: const UserInfo(
        fullName: 'Nguyen Van A',
        email: 'seller@example.com',
      ),
      buyer: const UserInfo(
        fullName: 'Tran Thi B',
        email: 'buyer@example.com',
      ),
      product: const ProductInfo.vehicle(
        name: 'VinFast VF e34',
        brand: 'VinFast',
        model: 'VF e34',
        version: 'Standard',
        yearManufacture: 2022,
        batteryCapacity: 42.0,
        odo: 15000,
        color: 'Blue',
        price: 500000000.0,
      ),
      salePrice: 500000000.0,
      signedBySeller: true,
      signedByBuyer: true,
    );
  }
}
