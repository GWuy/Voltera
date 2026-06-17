import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/contract_repository.dart';
import '../domain/contract_model.dart';
import '../services/contract_pdf_service.dart';

final contractRepositoryProvider = Provider<ContractRepository>((ref) {
  return ContractRepositoryImpl(); 
});

final contractPdfServiceProvider = Provider<ContractPdfService>((ref) {
  return ContractPdfService();
});

final contractProvider = FutureProvider.family<ContractModel, String>((ref, id) {
  final repository = ref.watch(contractRepositoryProvider);
  return repository.getContract(id);
});

final contractsListProvider = FutureProvider<List<ContractModel>>((ref) {
  final repository = ref.watch(contractRepositoryProvider);
  return repository.getContracts();
});
