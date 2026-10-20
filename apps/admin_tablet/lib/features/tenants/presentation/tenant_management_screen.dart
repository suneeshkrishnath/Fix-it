import 'package:flutter/material.dart';

import '../../../admin_theme.dart';
import '../../properties/data/repositories/mock_property_repository.dart';
import '../../properties/domain/models/property_records.dart';
import '../data/repositories/mock_tenant_repository.dart';
import '../domain/models/tenant_records.dart';

class TenantManagementScreen extends StatefulWidget {
  const TenantManagementScreen({
    required this.properties,
    required this.tenants,
    super.key,
  });

  final MockPropertyRepository properties;
  final MockTenantRepository tenants;

  @override
  State<TenantManagementScreen> createState() => _TenantManagementScreenState();
}

class _TenantManagementScreenState extends State<TenantManagementScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Residents and tenancy'),
      actions: const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: _LocalBadge(),
        ),
      ],
    ),
    body: AnimatedBuilder(
      animation: widget.tenants,
      builder: (context, _) {
        final visibleTenants = widget.tenants.tenants.where((tenant) {
          final query = _search.trim().toLowerCase();
          if (query.isEmpty) return true;
          final tenancy = _tenancyFor(tenant.id);
          final apartment = tenancy == null
              ? null
              : _apartmentFor(tenancy.apartmentId);
          return tenant.fullName.toLowerCase().contains(query) ||
              tenant.phone.toLowerCase().contains(query) ||
              tenant.email.toLowerCase().contains(query) ||
              (apartment?.unitNumber.toLowerCase().contains(query) ?? false);
        }).toList();
        final activeCount = widget.tenants.tenants
            .where((tenant) => tenant.status == TenantStatus.active)
            .length;
        return ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tenant directory',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: AdminTheme.ink),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$activeCount active tenants · local sample records',
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  key: const Key('add-tenant-action'),
                  onPressed: _activeApartments.isEmpty ? null : _addTenant,
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Add tenant'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            TextField(
              key: const Key('tenant-search'),
              onChanged: (value) => setState(() => _search = value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search name, phone, email, or apartment',
                isDense: true,
              ),
            ),
            const SizedBox(height: 16),
            if (visibleTenants.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(28),
                  child: Center(child: Text('No tenants match this search.')),
                ),
              )
            else
              Card(
                child: Column(
                  children: [
                    for (
                      var index = 0;
                      index < visibleTenants.length;
                      index++
                    ) ...[
                      if (index > 0)
                        const Divider(height: 1, indent: 16, endIndent: 16),
                      _TenantTile(
                        tenant: visibleTenants[index],
                        tenancy: _tenancyFor(visibleTenants[index].id),
                        apartment: _apartmentFor(
                          _tenancyFor(visibleTenants[index].id)?.apartmentId,
                        ),
                        building: _buildingFor(
                          _apartmentFor(
                            _tenancyFor(visibleTenants[index].id)?.apartmentId,
                          )?.buildingId,
                        ),
                        campus: _campusFor(
                          _buildingFor(
                            _apartmentFor(
                              _tenancyFor(visibleTenants[index].id)
                                  ?.apartmentId,
                            )?.buildingId,
                          )?.campusId,
                        ),
                        onToggle: () => _toggleStatus(visibleTenants[index]),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        );
      },
    ),
  );

  List<ApartmentRecord> get _activeApartments =>
      widget.properties.apartments.where((apartment) {
        final building = _buildingFor(apartment.buildingId);
        final campus = _campusFor(building?.campusId);
        return apartment.status == PropertyRecordStatus.active &&
            building?.status == PropertyRecordStatus.active &&
            campus?.status == PropertyRecordStatus.active;
      }).toList();

  Future<void> _addTenant() async {
    final formKey = GlobalKey<FormState>();
    var fullName = '';
    var phone = '';
    var email = '';
    String? apartmentId = _activeApartments.firstOrNull?.id;
    var startDate = DateTime.now();
    var endDate = DateTime(startDate.year + 1, startDate.month, startDate.day);
    var agreementPlaceholderAcknowledged = false;

    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add tenant'),
          scrollable: true,
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: const Key('tenant-name-field'),
                    onChanged: (value) => fullName = value,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator: _required,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    key: const Key('tenant-phone-field'),
                    onChanged: (value) => phone = value,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone number',
                    ),
                    validator: _required,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    key: const Key('tenant-email-field'),
                    onChanged: (value) => email = value,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: _validEmail,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    key: const Key('tenant-apartment-field'),
                    initialValue: apartmentId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Apartment / unit',
                    ),
                    items: _activeApartments.map((apartment) {
                      final building = _buildingFor(apartment.buildingId);
                      final campus = _campusFor(building?.campusId);
                      return DropdownMenuItem(
                        value: apartment.id,
                        child: Text(
                          '${campus?.name ?? ''} · ${building?.name ?? ''} · ${apartment.unitNumber}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setDialogState(() => apartmentId = value),
                    validator: (value) =>
                        value == null ? 'Select an active apartment.' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _DateButton(
                          label: 'Tenancy start',
                          value: startDate,
                          onTap: () async {
                            final date = await _pickDate(
                              dialogContext,
                              startDate,
                              endDate,
                            );
                            if (date != null) {
                              setDialogState(() => startDate = date);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _DateButton(
                          label: 'Tenancy end',
                          value: endDate,
                          onTap: () async {
                            final date = await _pickDate(
                              dialogContext,
                              endDate,
                              DateTime(startDate.year + 5),
                            );
                            if (date != null) {
                              setDialogState(() => endDate = date);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AdminTheme.paper,
                      border: Border.all(color: AdminTheme.line),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.attach_file, color: AdminTheme.teal),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Tenancy agreement attachment placeholder',
                          ),
                        ),
                        OutlinedButton(
                          key: const Key('agreement-placeholder'),
                          onPressed: () => setDialogState(
                            () => agreementPlaceholderAcknowledged = true,
                          ),
                          child: Text(
                            agreementPlaceholderAcknowledged
                                ? 'Upload planned'
                                : 'Attach file',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Placeholder only. File selection and storage are not enabled.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF667975)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: const Key('save-tenant'),
              onPressed: () {
                if (!formKey.currentState!.validate() ||
                    apartmentId == null ||
                    !endDate.isAfter(startDate) ||
                    fullName.trim().isEmpty ||
                    phone.trim().isEmpty ||
                    email.trim().isEmpty) {
                  return;
                }
                final tenantId = widget.tenants.nextId('tenant');
                widget.tenants.addTenant(
                  tenant: TenantRecord(
                    id: tenantId,
                    fullName: fullName.trim(),
                    phone: phone.trim(),
                    email: email.trim(),
                  ),
                  tenancy: TenancyRecord(
                    id: widget.tenants.nextId('tenancy'),
                    tenantId: tenantId,
                    apartmentId: apartmentId!,
                    startDate: startDate,
                    endDate: endDate,
                  ),
                );
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Save tenant'),
            ),
          ],
        ),
      ),
    );
    if (created == true && mounted) setState(() {});
  }

  Future<DateTime?> _pickDate(
    BuildContext context,
    DateTime initial,
    DateTime last,
  ) => showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(2020),
    lastDate: last.isBefore(initial) ? initial : last,
  );

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Required' : null;

  String? _validEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return value.contains('@') ? null : 'Enter a valid email.';
  }

  Future<void> _toggleStatus(TenantRecord tenant) async {
    widget.tenants.setTenantStatus(
      tenant.id,
      tenant.status == TenantStatus.active
          ? TenantStatus.inactive
          : TenantStatus.active,
    );
  }

  TenancyRecord? _tenancyFor(String tenantId) => widget.tenants.tenancies
      .where((tenancy) => tenancy.tenantId == tenantId)
      .firstOrNull;

  ApartmentRecord? _apartmentFor(String? id) => id == null
      ? null
      : widget.properties.apartments.where((item) => item.id == id).firstOrNull;

  BuildingRecord? _buildingFor(String? id) => id == null
      ? null
      : widget.properties.buildings.where((item) => item.id == id).firstOrNull;

  CampusRecord? _campusFor(String? id) => id == null
      ? null
      : widget.properties.campuses.where((item) => item.id == id).firstOrNull;
}

class _TenantTile extends StatelessWidget {
  const _TenantTile({
    required this.tenant,
    required this.tenancy,
    required this.apartment,
    required this.building,
    required this.campus,
    required this.onToggle,
  });

  final TenantRecord tenant;
  final TenancyRecord? tenancy;
  final ApartmentRecord? apartment;
  final BuildingRecord? building;
  final CampusRecord? campus;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => ListTile(
    key: Key('tenant-${tenant.id}'),
    leading: CircleAvatar(
      backgroundColor: AdminTheme.tealLight,
      child: Text(
        tenant.fullName
            .split(' ')
            .where((part) => part.isNotEmpty)
            .take(2)
            .map((part) => part[0])
            .join(),
        style: const TextStyle(color: AdminTheme.ink),
      ),
    ),
    title: Text(tenant.fullName),
    subtitle: Text(
      '${tenant.phone} · ${tenant.email}\n${campus?.name ?? 'No campus'} · ${building?.name ?? 'No building'} · ${apartment?.unitNumber ?? 'No apartment'} · ${tenancy == null ? 'No tenancy' : '${_shortDate(tenancy!.startDate)} - ${_shortDate(tenancy!.endDate)}'}',
    ),
    isThreeLine: true,
    trailing: Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Chip(
          label: Text(
            tenant.status == TenantStatus.active ? 'Active' : 'Inactive',
          ),
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
          tooltip: tenant.status == TenantStatus.active
              ? 'Deactivate tenant'
              : 'Activate tenant',
          onPressed: onToggle,
          icon: Icon(
            tenant.status == TenantStatus.active
                ? Icons.pause_circle_outline
                : Icons.play_circle_outline,
          ),
        ),
      ],
    ),
  );
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final DateTime value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onTap,
    icon: const Icon(Icons.calendar_month_outlined),
    label: Text(
      '$label\n${MaterialLocalizations.of(context).formatMediumDate(value)}',
      textAlign: TextAlign.start,
    ),
  );
}

String _shortDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

class _LocalBadge extends StatelessWidget {
  const _LocalBadge();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: AdminTheme.tealLight,
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Text(
      'LOCAL SAMPLE DATA',
      style: TextStyle(
        color: AdminTheme.ink,
        fontSize: 10,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}
