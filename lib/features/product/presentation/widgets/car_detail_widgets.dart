import 'package:flutter/material.dart';

const _kPrimary = Color(0xFF3D3DC6);

class CarInfoCard extends StatelessWidget {
  final dynamic car;
  final double? price;
  final String? location;
  final String Function(double) formatPrice;

  const CarInfoCard({
    super.key,
    required this.car,
    required this.price,
    required this.location,
    required this.formatPrice,
  });

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${car?.brand} ${car?.model}\n${car?.version}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formatPrice(price ?? 0),
            style: const TextStyle(
              color: _kPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 4),
              Text(
                location ?? 'N/A',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 4),
              Text(
                'Posted Jun 10, 2026',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            children: [
              _ConditionBadge(label: 'Body Insurance'),
              const SizedBox(width: 12),
              _ConditionBadge(label: 'Vehicle Inspection'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SpecIcon(
                icon: Icons.speed,
                value: '155 mph',
                label: 'Top Speed',
              ),
              _SpecIcon(
                icon: Icons.timer_outlined,
                value: '2.5 sec',
                label: '0-60mph',
              ),
              _SpecIcon(
                icon: Icons.electric_car,
                value: '${car?.range ?? 0} km',
                label: 'Range',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CarSpecificationsCard extends StatelessWidget {
  final dynamic car;

  const CarSpecificationsCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      title: 'Specifications',
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 3,
        children: [
          _SpecRow('Make', car?.brand ?? 'N/A'),
          _SpecRow('Model', car?.model ?? 'N/A'),
          _SpecRow('Color', car?.color ?? 'N/A'),
          _SpecRow('Style', car?.style ?? 'N/A'),
          _SpecRow('Battery', '${car?.batteryCapacity ?? 0}kWh'),
          _SpecRow('Seats', '${car?.numberOfSeat ?? 0}'),
          _SpecRow('Odometer', '${car?.odo ?? 0}km'),
          _SpecRow('Charging', '${car?.chargingTime ?? 0}h'),
        ],
      ),
    );
  }
}

class CarLocationCard extends StatelessWidget {
  final String? location;

  const CarLocationCard({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      title: 'Location',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: _kPrimary, size: 18),
              const SizedBox(width: 8),
              Text(
                location ?? 'N/A',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class CarDescriptionCard extends StatelessWidget {
  final String? description;

  const CarDescriptionCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      title: 'Vehicle Details',
      child: Text(
        description ?? 'No description provided.',
        style: TextStyle(color: Colors.grey.shade600, height: 1.6),
      ),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const _WhiteCard({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }
}

class _ConditionBadge extends StatelessWidget {
  final String label;
  const _ConditionBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _kPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: _kPrimary, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: _kPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecIcon extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _SpecIcon({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade400, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
        ),
      ],
    );
  }
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;
  const _SpecRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
