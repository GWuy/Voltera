import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CarFilterScreen extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;
  const CarFilterScreen({super.key, this.initialFilters});

  @override
  State<CarFilterScreen> createState() => _CarFilterScreenState();
}

class _CarFilterScreenState extends State<CarFilterScreen> {
  // General
  late final TextEditingController _keywordController;
  late final TextEditingController _locationController;

  // Vehicle Details
  String? _selectedBrand;
  String? _selectedStyle;
  String? _selectedColor;
  String? _selectedOrigin;
  late final TextEditingController _versionController;

  // Performance
  late final TextEditingController _minOdoController;
  late final TextEditingController _maxOdoController;
  late final TextEditingController _minRangeController;
  late final TextEditingController _maxRangeController;
  late final TextEditingController _minYearController;
  late final TextEditingController _maxYearController;

  // Conditions
  bool _bodyInsurance = false;
  bool _vehicleInspection = false;

  // Pricing
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    final f = widget.initialFilters;
    _keywordController = TextEditingController(text: f?['keyword']);
    _locationController = TextEditingController(text: f?['address']);
    _selectedBrand = f?['brand'];
    _selectedStyle = f?['style'];
    _versionController = TextEditingController(text: f?['version']);
    _selectedColor = f?['color'];
    _selectedOrigin = f?['origin'];
    _minOdoController = TextEditingController(text: f?['minOdo']?.toString());
    _maxOdoController = TextEditingController(text: f?['maxOdo']?.toString());
    _minRangeController = TextEditingController(text: f?['minRange']?.toString());
    _maxRangeController = TextEditingController(text: f?['maxRange']?.toString());
    _minYearController = TextEditingController(text: f?['minYearManufacture']?.toString());
    _maxYearController = TextEditingController(text: f?['maxYearManufacture']?.toString());
    _bodyInsurance = f?['bodyInsurance'] ?? false;
    _vehicleInspection = f?['vehicleInspection'] ?? false;
    _minPriceController = TextEditingController(text: f?['minPrice']?.toString());
    _maxPriceController = TextEditingController(text: f?['maxPrice']?.toString());
  }

  @override
  void dispose() {
    _keywordController.dispose();
    _locationController.dispose();
    _versionController.dispose();
    _minOdoController.dispose();
    _maxOdoController.dispose();
    _minRangeController.dispose();
    _maxRangeController.dispose();
    _minYearController.dispose();
    _maxYearController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _keywordController.clear();
      _locationController.clear();
      _selectedBrand = null;
      _selectedStyle = null;
      _selectedColor = null;
      _selectedOrigin = null;
      _versionController.clear();
      _minOdoController.clear();
      _maxOdoController.clear();
      _minRangeController.clear();
      _maxRangeController.clear();
      _minYearController.clear();
      _maxYearController.clear();
      _bodyInsurance = false;
      _vehicleInspection = false;
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  Map<String, dynamic> _collectFilters() {
    return {
      'keyword': _keywordController.text.isEmpty ? null : _keywordController.text,
      'address': _locationController.text.isEmpty ? null : _locationController.text,
      'brand': _selectedBrand,
      'style': _selectedStyle,
      'version': _versionController.text.isEmpty ? null : _versionController.text,
      'color': _selectedColor,
      'origin': _selectedOrigin,
      'minOdo': int.tryParse(_minOdoController.text),
      'maxOdo': int.tryParse(_maxOdoController.text),
      'minRange': int.tryParse(_minRangeController.text),
      'maxRange': int.tryParse(_maxRangeController.text),
      'minYearManufacture': int.tryParse(_minYearController.text),
      'maxYearManufacture': int.tryParse(_maxYearController.text),
      'bodyInsurance': _bodyInsurance,
      'vehicleInspection': _vehicleInspection,
      'minPrice': double.tryParse(_minPriceController.text),
      'maxPrice': double.tryParse(_maxPriceController.text),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text('Filter', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text('Reset', style: TextStyle(color: Color(0xFF3D3DC6), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _buildSection(
              title: 'GENERAL',
              children: [
                _buildTextField(
                  controller: _keywordController,
                  hintText: 'Search title, description...',
                  prefixIcon: Icons.search,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _locationController,
                  hintText: 'Location',
                  prefixIcon: Icons.location_on_outlined,
                ),
              ],
            ),
            _buildSection(
              title: 'VEHICLE DETAILS',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        hint: 'Brand',
                        value: _selectedBrand,
                        items: ['Tesla', 'Toyota', 'Honda', 'Nissan', 'Hyundai', 'Kia', 'Mercedes-Benz', 'BMW', 'Audi', 'Volkswagen', 'Porsche', 'Ford', 'Chevrolet', 'Volvo', 'Lexus', 'Jaguar', 'Land Rover', 'BYD', 'VinFast', 'MG'],
                        onChanged: (val) => setState(() => _selectedBrand = val),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdownField(
                        hint: 'Style',
                        value: _selectedStyle,
                        items: ['SUV', 'Sedan', 'Hatchback', 'Crossover (CUV)', 'Pickup Truck', 'MPV', 'Sports Car'],
                        onChanged: (val) => setState(() => _selectedStyle = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _versionController,
                        hintText: 'Version',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdownField(
                        hint: 'Color',
                        value: _selectedColor,
                        items: ['White', 'Black', 'Gray', 'Silver', 'Blue', 'Red', 'Green', 'Yellow', 'Orange', 'Brown', 'Gold', 'Beige', 'Purple', 'Other'],
                        onChanged: (val) => setState(() => _selectedColor = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDropdownField(
                  hint: 'Origin',
                  value: _selectedOrigin,
                  items: ['United States', 'Germany', 'Japan', 'South Korea', 'China', 'Vietnam', 'Sweden', 'United Kingdom', 'Italy', 'France', 'India', 'Czech Republic', 'Spain', 'Romania', 'Croatia', 'Turkey', 'Russia', 'Malaysia'],
                  onChanged: (val) => setState(() => _selectedOrigin = val),
                ),
              ],
            ),
            _buildSection(
              title: 'PERFORMANCE',
              children: [
                _buildRangeHeader('Odometer (mi)'),
                _buildRangeInputs(
                  minController: _minOdoController,
                  maxController: _maxOdoController,
                  minHint: 'Min Odo',
                  maxHint: 'Max Odo',
                ),
                const SizedBox(height: 16),
                _buildRangeHeader('Range (mi)'),
                _buildRangeInputs(
                  minController: _minRangeController,
                  maxController: _maxRangeController,
                  minHint: 'Min Range',
                  maxHint: 'Max Range',
                ),
                const SizedBox(height: 16),
                _buildRangeHeader('Year'),
                _buildRangeInputs(
                  minController: _minYearController,
                  maxController: _maxYearController,
                  minHint: 'Min Year',
                  maxHint: 'Max Year',
                ),
              ],
            ),
            _buildSection(
              title: 'CONDITIONS',
              children: [
                _buildSwitchTile(
                  label: 'Body Insurance',
                  value: _bodyInsurance,
                  onChanged: (val) => setState(() => _bodyInsurance = val),
                ),
                _buildSwitchTile(
                  label: 'Vehicle Inspection',
                  value: _vehicleInspection,
                  onChanged: (val) => setState(() => _vehicleInspection = val),
                ),
              ],
            ),
            _buildSection(
              title: 'PRICING',
              children: [
                _buildRangeInputs(
                  minController: _minPriceController,
                  maxController: _maxPriceController,
                  minHint: '\$ Min Price',
                  maxHint: '\$ Max Price',
                ),
              ],
            ),
            const SizedBox(height: 100), // Space for fixed button
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF4F5F7))),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => context.pop(_collectFilters()),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3D3DC6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('Apply Filter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1),
            ),
            const Icon(Icons.keyboard_arrow_up, size: 18, color: Colors.grey),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey, size: 20) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildRangeHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
    );
  }

  Widget _buildRangeInputs({
    required TextEditingController minController,
    required TextEditingController maxController,
    required String minHint,
    required String maxHint,
  }) {
    return Row(
      children: [
        Expanded(child: _buildTextField(controller: minController, hintText: minHint)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('-', style: TextStyle(color: Colors.grey)),
        ),
        Expanded(child: _buildTextField(controller: maxController, hintText: maxHint)),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF3D3DC6),
          activeTrackColor: const Color(0xFF3D3DC6).withOpacity(0.2),
        ),
      ],
    );
  }
}
