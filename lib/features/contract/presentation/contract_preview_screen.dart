import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../domain/contract_model.dart';
import '../domain/product_info.dart';
import '../providers/contract_providers.dart';

class ContractPreviewScreen extends ConsumerStatefulWidget {
  final String contractId;

  const ContractPreviewScreen({
    super.key,
    required this.contractId,
  });

  @override
  ConsumerState<ContractPreviewScreen> createState() => _ContractPreviewScreenState();
}

class _ContractPreviewScreenState extends ConsumerState<ContractPreviewScreen> {
  bool _agreedToTerms = false;
  bool _isSigning = false;

  @override
  Widget build(BuildContext context) {
    final contractAsync = ref.watch(contractProvider(widget.contractId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract Preview'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel_outlined, color: Colors.red),
            onPressed: () => _handleCancelContract(context, ref),
          ),
        ],
      ),
      body: contractAsync.when(
        data: (contract) => _buildContent(context, ref, contract),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildError(context, ref, error),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, ContractModel contract) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(contract, context),
          const SizedBox(height: 16),
          _buildPartyCard('Seller Information', contract.seller.fullName, contract.seller.email, context),
          const SizedBox(height: 16),
          _buildPartyCard('Buyer Information', contract.buyer.fullName, contract.buyer.email, context),
          const SizedBox(height: 16),
          _buildProductCard(contract.product, context),
          const SizedBox(height: 16),
          _buildSignaturesCard(contract, context),
          const SizedBox(height: 24),
          if (!contract.signedByBuyer || !contract.signedBySeller) ...[
            _buildAgreementSection(),
            const SizedBox(height: 16),
            _buildSignButton(context, ref, contract),
            const SizedBox(height: 24),
          ],
          _buildDownloadButton(context, ref, contract),
        ],
      ),
    );
  }

  Widget _buildAgreementSection() {
    return Row(
      children: [
        Checkbox(
          value: _agreedToTerms,
          onChanged: (val) {
            setState(() {
              _agreedToTerms = val ?? false;
            });
          },
        ),
        const Expanded(
          child: Text(
            'I agree to all the terms and conditions in this contract',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSignButton(BuildContext context, WidgetRef ref, ContractModel contract) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: _agreedToTerms && !_isSigning
            ? () => _handleSignContract(context, ref)
            : null,
        icon: _isSigning 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.draw),
        label: Text(_isSigning ? 'Signing...' : 'Sign Contract'),
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignContract(BuildContext context, WidgetRef ref) async {
    setState(() => _isSigning = true);
    try {
      await ref.read(contractRepositoryProvider).signContract(widget.contractId);
      ref.invalidate(contractProvider(widget.contractId));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contract signed successfully! Waiting for the other party.'), backgroundColor: Colors.green),
        );
        
        // Wait 5 seconds and go to home
        Future.delayed(const Duration(seconds: 5), () {
          if (context.mounted) {
            context.go('/home');
          }
        });
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign contract: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSigning = false);
    }
  }

  Future<void> _handleCancelContract(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Contract'),
        content: const Text('Are you sure you want to cancel this contract?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await ref.read(contractRepositoryProvider).cancelContract(widget.contractId);
      ref.invalidate(contractProvider(widget.contractId));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contract cancelled')),
        );
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to cancel contract: $e')),
        );
      }
    }
  }

  Widget _buildHeaderCard(ContractModel contract, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Contract ID',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                Text(
                  contract.id,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                _buildStatusChip(contract.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(ContractStatus status) {
    Color color;
    IconData icon;
    String label;

    switch (status) {
      case ContractStatus.pending:
        color = Colors.orange;
        icon = Icons.pending_actions;
        label = 'Pending';
        break;
      case ContractStatus.signed:
        color = Colors.green;
        icon = Icons.check_circle;
        label = 'Signed';
        break;
      case ContractStatus.cancelled:
        color = Colors.red;
        icon = Icons.cancel;
        label = 'Cancelled';
        break;
      case ContractStatus.completed:
        color = Colors.blue;
        icon = Icons.done_all;
        label = 'Completed';
        break;
    }

    return Chip(
      avatar: Icon(icon, color: color, size: 18),
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
      side: BorderSide(color: color.withValues(alpha: 0.2)),
    );
  }

  Widget _buildPartyCard(String title, String name, String email, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Full Name', name, context),
            const SizedBox(height: 8),
            _buildInfoRow('Email', email, context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductInfo product, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            product.map(
              vehicle: (v) => Column(
                children: [
                  _buildInfoRow('Type', 'Vehicle', context),
                  _buildInfoRow('Name', v.name, context),
                  _buildInfoRow('Brand', v.brand, context),
                  _buildInfoRow('Model', v.model, context),
                  _buildInfoRow('Version', v.version, context),
                  _buildInfoRow('Year', '${v.yearManufacture}', context),
                  _buildInfoRow('Battery', '${v.batteryCapacity} kWh', context),
                  _buildInfoRow('ODO', '${v.odo} km', context),
                  _buildInfoRow('Color', v.color, context),
                  const Divider(height: 16),
                  _buildInfoRow('Price', NumberFormat.currency(symbol: '\$').format(v.price), context, isBold: true),
                ],
              ),
              battery: (b) => Column(
                children: [
                  _buildInfoRow('Type', 'Battery', context),
                  _buildInfoRow('Name', b.name, context),
                  _buildInfoRow('Serial', b.serialNumber, context),
                  _buildInfoRow('Capacity', '${b.remainingCapacity} / ${b.originalCapacity} kWh', context),
                  _buildInfoRow('Voltage', '${b.voltage} V', context),
                  _buildInfoRow('Cycles', '${b.cycleCount}', context),
                  _buildInfoRow('Warranty', b.warranty, context),
                  _buildInfoRow('Mileage', '${b.mileageCovered} km', context),
                  const Divider(height: 16),
                  _buildInfoRow('Price', NumberFormat.currency(symbol: '\$').format(b.price), context, isBold: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignaturesCard(ContractModel contract, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Signatures',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSignatureStatus('Seller', contract.signedBySeller, context),
                ),
                Expanded(
                  child: _buildSignatureStatus('Buyer', contract.signedByBuyer, context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureStatus(String role, bool isSigned, BuildContext context) {
    final color = isSigned ? Colors.green : Colors.red;
    final icon = isSigned ? Icons.check_circle : Icons.cancel;
    final text = isSigned ? 'Signed' : 'Not Signed';

    return Column(
      children: [
        Text(role, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, BuildContext context, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context, WidgetRef ref, ContractModel contract) {
    final canDownload = contract.signedBySeller && contract.signedByBuyer;

    return Column(
      children: [
        if (!canDownload) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.lock, color: Theme.of(context).colorScheme.error),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Waiting for both parties to sign',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: canDownload ? () => _handleDownload(context, ref, contract) : null,
            icon: const Icon(Icons.download),
            label: const Text('Download Contract'),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleDownload(BuildContext context, WidgetRef ref, ContractModel contract) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final pdfService = ref.read(contractPdfServiceProvider);
      final pdfDocument = await pdfService.generateContractPdf(contract);
      final pdfBytes = await pdfDocument.save();

      // Hide loading
      if (context.mounted) Navigator.pop(context);

      // Show actions
      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          builder: (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share PDF'),
                  onTap: () {
                    Navigator.pop(context);
                    Printing.sharePdf(bytes: pdfBytes, filename: 'Contract_${contract.id}.pdf');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.print),
                  title: const Text('Print PDF'),
                  onTap: () {
                    Navigator.pop(context);
                    Printing.layoutPdf(onLayout: (_) => pdfBytes, name: 'Contract_${contract.id}.pdf');
                  },
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Hide loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate PDF: $e')),
        );
      }
    }
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Failed to load contract',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(error.toString()),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => ref.invalidate(contractProvider(widget.contractId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
