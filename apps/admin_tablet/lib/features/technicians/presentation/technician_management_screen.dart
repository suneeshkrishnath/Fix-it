import 'package:flutter/material.dart';

import '../../../admin_theme.dart';
import '../domain/models/technician_records.dart';
import '../data/repositories/mock_technician_management_repository.dart';

class TechnicianManagementScreen extends StatefulWidget {
  const TechnicianManagementScreen({required this.repository, super.key});

  final MockTechnicianManagementRepository repository;

  @override
  State<TechnicianManagementScreen> createState() =>
      _TechnicianManagementScreenState();
}

class _TechnicianManagementScreenState
    extends State<TechnicianManagementScreen> {
  String _search = '';
  String? _roleId;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.repository,
      builder: (context, _) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Technicians and roles'),
            actions: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: _TechnicianLocalBadge(),
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Technicians'),
                Tab(text: 'Roles and permissions'),
              ],
            ),
          ),
          body: TabBarView(
            children: [_technicianDirectory(), _roleDirectory()],
          ),
        ),
      ),
    );
  }

  Widget _technicianDirectory() {
    final records = widget.repository.technicians.where((technician) {
      final role = _roleFor(technician.roleId)?.name ?? '';
      final query = _search.trim().toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          technician.fullName.toLowerCase().contains(query) ||
          technician.loginId.toLowerCase().contains(query) ||
          technician.phone.toLowerCase().contains(query) ||
          technician.specialty.toLowerCase().contains(query);
      return matchesQuery &&
          (_roleId == null || technician.roleId == _roleId) &&
          role.isNotEmpty;
    }).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Technician accounts',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            FilledButton.icon(
              key: const Key('add-technician-action'),
              onPressed: _editTechnician,
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Add technician'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key('technician-search'),
                onChanged: (value) => setState(() => _search = value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search name, login ID, specialty, or phone',
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 240,
              child: DropdownButtonFormField<String?>(
                initialValue: _roleId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  isDense: true,
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('All roles'),
                  ),
                  ...widget.repository.roles.map(
                    (role) => DropdownMenuItem<String?>(
                      value: role.id,
                      child: Text(role.name),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _roleId = value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (records.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(28),
              child: Center(child: Text('No technicians match this filter.')),
            ),
          )
        else
          Card(
            child: Column(
              children: [
                for (var index = 0; index < records.length; index++) ...[
                  if (index > 0)
                    const Divider(height: 1, indent: 16, endIndent: 16),
                  _TechnicianTile(
                    record: records[index],
                    roleName: _roleFor(records[index].roleId)?.name ?? '',
                    onEdit: () => _editTechnician(records[index]),
                    onToggle: () => _toggleStatus(records[index]),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _roleDirectory() => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              'Role profiles and permissions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          FilledButton.icon(
            key: const Key('add-role-action'),
            onPressed: _addRole,
            icon: const Icon(Icons.add),
            label: const Text('Add role'),
          ),
        ],
      ),
      const SizedBox(height: 4),
      const Text(
        'Sample permissions are local only. Enforce role access in the backend before production.',
      ),
      const SizedBox(height: 14),
      for (final role in widget.repository.roles)
        Card(
          child: ExpansionTile(
            key: Key('role-${role.id}'),
            title: Text(role.name),
            subtitle: Text('${role.permissions.length} permissions'),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              for (final permission in technicianPermissionCatalog)
                CheckboxListTile(
                  key: Key('permission-${role.id}-$permission'),
                  value: role.permissions.contains(permission),
                  onChanged: (selected) =>
                      _setRolePermission(role, permission, selected ?? false),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(permission),
                ),
            ],
          ),
        ),
    ],
  );

  Future<void> _addRole() async {
    var name = '';
    final selectedPermissions = <String>{};
    final formKey = GlobalKey<FormState>();
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          scrollable: true,
          title: const Text('Create role profile'),
          content: SizedBox(
            width: 560,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: const Key('role-name-field'),
                    decoration: const InputDecoration(labelText: 'Role name'),
                    validator: _required,
                    onChanged: (value) => name = value,
                  ),
                  const SizedBox(height: 12),
                  for (final permission in technicianPermissionCatalog)
                    CheckboxListTile(
                      value: selectedPermissions.contains(permission),
                      onChanged: (checked) => setDialogState(() {
                        if (checked == true) {
                          selectedPermissions.add(permission);
                        } else {
                          selectedPermissions.remove(permission);
                        }
                      }),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(permission),
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
              key: const Key('save-role'),
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                final duplicate = widget.repository.roles.any(
                  (role) =>
                      role.name.toLowerCase() == name.trim().toLowerCase(),
                );
                if (duplicate) return;
                widget.repository.saveRole(
                  AdminRoleRecord(
                    id: widget.repository.nextId('role'),
                    name: name.trim(),
                    permissions: Set.of(selectedPermissions),
                  ),
                );
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Save role'),
            ),
          ],
        ),
      ),
    );
    if (saved == true && mounted) setState(() {});
  }

  void _setRolePermission(
    AdminRoleRecord role,
    String permission,
    bool selected,
  ) {
    final permissions = Set<String>.of(role.permissions);
    if (selected) {
      permissions.add(permission);
    } else {
      permissions.remove(permission);
    }
    widget.repository.saveRole(
      AdminRoleRecord(id: role.id, name: role.name, permissions: permissions),
    );
  }

  AdminRoleRecord? _roleFor(String id) =>
      widget.repository.roles.where((role) => role.id == id).firstOrNull;

  Future<void> _editTechnician([TechnicianRecord? record]) async {
    var loginId = record?.loginId ?? '';
    var fullName = record?.fullName ?? '';
    var phone = record?.phone ?? '';
    var specialty = record?.specialty ?? '';
    var roleId = record?.roleId ?? widget.repository.roles.first.id;
    var availability = record?.availability ?? TechnicianAvailability.available;
    final formKey = GlobalKey<FormState>();
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          scrollable: true,
          title: Text(record == null ? 'Add technician' : 'Edit technician'),
          content: SizedBox(
            width: 520,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: const Key('technician-login-id-field'),
                    initialValue: loginId,
                    decoration: const InputDecoration(labelText: 'Login ID'),
                    validator: _required,
                    onChanged: (value) => loginId = value,
                  ),
                  TextFormField(
                    key: const Key('technician-name-field'),
                    initialValue: fullName,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator: _required,
                    onChanged: (value) => fullName = value,
                  ),
                  TextFormField(
                    key: const Key('technician-phone-field'),
                    initialValue: phone,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: _required,
                    onChanged: (value) => phone = value,
                  ),
                  TextFormField(
                    key: const Key('technician-specialty-field'),
                    initialValue: specialty,
                    decoration: const InputDecoration(labelText: 'Specialty'),
                    validator: _required,
                    onChanged: (value) => specialty = value,
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: roleId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Role'),
                    items: widget.repository.roles
                        .map(
                          (role) => DropdownMenuItem(
                            value: role.id,
                            child: Text(role.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setDialogState(() => roleId = value);
                    },
                  ),
                  DropdownButtonFormField<TechnicianAvailability>(
                    initialValue: availability,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Availability',
                    ),
                    items: TechnicianAvailability.values
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(_availabilityLabel(value)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => availability = value);
                      }
                    },
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
              key: const Key('save-technician'),
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                widget.repository.saveTechnician(
                  TechnicianRecord(
                    id: record?.id ?? widget.repository.nextId('technician'),
                    loginId: loginId.trim().toUpperCase(),
                    fullName: fullName.trim(),
                    phone: phone.trim(),
                    specialty: specialty.trim(),
                    roleId: roleId,
                    availability: availability,
                    status: record?.status ?? AccountStatus.active,
                  ),
                );
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Save technician'),
            ),
          ],
        ),
      ),
    );
    if (saved == true && mounted) setState(() {});
  }

  Future<void> _toggleStatus(TechnicianRecord record) async {
    widget.repository.setTechnicianStatus(
      record.id,
      record.status == AccountStatus.active
          ? AccountStatus.inactive
          : AccountStatus.active,
    );
  }
}

String? _required(String? value) =>
    value == null || value.trim().isEmpty ? 'Required' : null;

String _availabilityLabel(TechnicianAvailability availability) =>
    switch (availability) {
      TechnicianAvailability.available => 'Available',
      TechnicianAvailability.onJob => 'On job',
      TechnicianAvailability.offDuty => 'Off duty',
    };

class _TechnicianTile extends StatelessWidget {
  const _TechnicianTile({
    required this.record,
    required this.roleName,
    required this.onEdit,
    required this.onToggle,
  });

  final TechnicianRecord record;
  final String roleName;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => ListTile(
    key: Key('tech-${record.id}'),
    leading: CircleAvatar(
      backgroundColor: AdminTheme.tealLight,
      child: const Icon(Icons.engineering_outlined, color: AdminTheme.ink),
    ),
    title: Text('${record.fullName} · ${record.loginId}'),
    subtitle: Text(
      '${record.specialty} · ${record.phone} · $roleName · ${_availabilityLabel(record.availability)}',
    ),
    trailing: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Chip(
          label: Text(
            record.status == AccountStatus.active ? 'Active' : 'Inactive',
          ),
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
          tooltip: 'Edit ${record.fullName}',
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          tooltip: record.status == AccountStatus.active
              ? 'Deactivate ${record.fullName}'
              : 'Activate ${record.fullName}',
          onPressed: onToggle,
          icon: Icon(
            record.status == AccountStatus.active
                ? Icons.pause_circle_outline
                : Icons.play_circle_outline,
          ),
        ),
      ],
    ),
  );
}

class _TechnicianLocalBadge extends StatelessWidget {
  const _TechnicianLocalBadge();

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
