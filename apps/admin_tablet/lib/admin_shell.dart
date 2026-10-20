import 'package:flutter/material.dart';

import 'admin_dashboard.dart';
import 'admin_theme.dart';
import 'features/properties/data/repositories/mock_property_repository.dart';
import 'features/properties/presentation/property_management_screen.dart';
import 'features/tenants/data/repositories/mock_tenant_repository.dart';
import 'features/tenants/presentation/tenant_management_screen.dart';
import 'features/technicians/data/repositories/mock_technician_management_repository.dart';
import 'features/technicians/presentation/technician_management_screen.dart';

enum AdminSection { overview, requests, properties, residents, technicians }

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  AdminSection _section = AdminSection.overview;
  final _propertyRepository = MockPropertyRepository();
  final _tenantRepository = MockTenantRepository();
  final _technicianRepository = MockTechnicianManagementRepository();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (isWide)
              NavigationRail(
                extended: MediaQuery.sizeOf(context).width >= 1180,
                selectedIndex: _section.index,
                onDestinationSelected: (index) =>
                    setState(() => _section = AdminSection.values[index]),
                leading: const _BrandBlock(),
                destinations: [
                  for (final section in AdminSection.values)
                    NavigationRailDestination(
                      icon: Icon(_iconFor(section)),
                      label: Text(_labelFor(section)),
                    ),
                ],
              )
            else
              _CompactNavigation(
                section: _section,
                onSelected: (section) => setState(() => _section = section),
              ),
            const VerticalDivider(width: 1),
            Expanded(child: _sectionContent(_section)),
          ],
        ),
      ),
    );
  }

  Widget _sectionContent(AdminSection section) => switch (section) {
    AdminSection.overview => const AdminDashboard(),
    AdminSection.requests => const AdminPlaceholder(
      title: 'Request queue',
      description: 'Review, assign, and follow work orders. Shared request data is planned for Stage 9.',
      icon: Icons.assignment_outlined,
      key: Key('requests-section'),
    ),
    AdminSection.properties => PropertyManagementScreen(
      key: const Key('properties-section'),
      repository: _propertyRepository,
    ),
    AdminSection.residents => TenantManagementScreen(
      key: const Key('residents-section'),
      properties: _propertyRepository,
      tenants: _tenantRepository,
    ),
    AdminSection.technicians => TechnicianManagementScreen(
      key: const Key('technicians-section'),
      repository: _technicianRepository,
    ),
  };
}

class _BrandBlock extends StatelessWidget {
  const _BrandBlock();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AdminTheme.ink,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.home_repair_service, color: Colors.white),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FIX-IT', style: TextStyle(fontWeight: FontWeight.w800)),
            Text('OPERATIONS', style: TextStyle(fontSize: 10)),
          ],
        ),
      ],
    ),
  );
}

class _CompactNavigation extends StatelessWidget {
  const _CompactNavigation({required this.section, required this.onSelected});

  final AdminSection section;
  final ValueChanged<AdminSection> onSelected;

  @override
  Widget build(BuildContext context) => NavigationRail(
    selectedIndex: section.index,
    onDestinationSelected: (index) => onSelected(AdminSection.values[index]),
    labelType: NavigationRailLabelType.all,
    destinations: [
      for (final item in AdminSection.values)
        NavigationRailDestination(
          icon: Icon(_iconFor(item)),
          label: Text(_labelFor(item)),
        ),
    ],
  );
}

class AdminPlaceholder extends StatelessWidget {
  const AdminPlaceholder({
    required this.title,
    required this.description,
    required this.icon,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 620),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AdminTheme.teal),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(description, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            const Chip(
              avatar: Icon(Icons.construction_outlined, size: 16),
              label: Text('Planned'),
            ),
          ],
        ),
      ),
    ),
  );
}

IconData _iconFor(AdminSection section) => switch (section) {
  AdminSection.overview => Icons.space_dashboard_outlined,
  AdminSection.requests => Icons.assignment_outlined,
  AdminSection.properties => Icons.apartment_outlined,
  AdminSection.residents => Icons.people_outline,
  AdminSection.technicians => Icons.engineering_outlined,
};

String _labelFor(AdminSection section) => switch (section) {
  AdminSection.overview => 'Overview',
  AdminSection.requests => 'Requests',
  AdminSection.properties => 'Properties',
  AdminSection.residents => 'Tenants',
  AdminSection.technicians => 'Technicians',
};
