import 'package:flutter/material.dart';

import '../data/repositories/mock_property_repository.dart';
import '../domain/models/property_records.dart';
import '../../../admin_theme.dart';

class PropertyManagementScreen extends StatefulWidget {
  const PropertyManagementScreen({required this.repository, super.key});

  final MockPropertyRepository repository;

  @override
  State<PropertyManagementScreen> createState() =>
      _PropertyManagementScreenState();
}

class _PropertyManagementScreenState extends State<PropertyManagementScreen> {
  String _search = '';
  String? _campusId;
  String? _buildingId;

  MockPropertyRepository get _repository => widget.repository;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Property hierarchy'),
      actions: const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: _LocalDataBadge(),
        ),
      ],
    ),
    body: AnimatedBuilder(
      animation: _repository,
      builder: (context, _) => DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('property-search'),
                      onChanged: (value) => setState(() => _search = value),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search campuses, blocks, buildings, units',
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => setState(() {
                      _search = '';
                      _campusId = null;
                      _buildingId = null;
                    }),
                    icon: const Icon(Icons.filter_alt_off_outlined),
                    label: const Text('Clear filters'),
                  ),
                ],
              ),
            ),
            const TabBar(
              tabs: [
                Tab(text: 'Campuses'),
                Tab(text: 'Buildings / blocks'),
                Tab(text: 'Apartments'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [_campusList(), _buildingList(), _apartmentList()],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _campusList() {
    final campuses = _repository.campuses.where((campus) {
      final query = _search.trim().toLowerCase();
      return query.isEmpty ||
          campus.name.toLowerCase().contains(query) ||
          campus.city.toLowerCase().contains(query);
    }).toList();
    return _RecordList(
      title: 'Campuses',
      count: campuses.length,
      addLabel: 'Add campus',
      onAdd: () => _editCampus(),
      emptyMessage: 'No campuses match this search.',
      children: [
        for (final campus in campuses)
          _RecordTile(
            title: campus.name,
            subtitle:
                '${campus.city} · ${_repository.buildings.where((item) => item.campusId == campus.id).length} buildings/blocks',
            status: campus.status,
            onEdit: () => _editCampus(campus),
            onToggleStatus: () => _toggleCampus(campus),
          ),
      ],
    );
  }

  Widget _buildingList() {
    final buildings = _repository.buildings.where((building) {
      final matchesCampus = _campusId == null || building.campusId == _campusId;
      final campusName = _campusName(building.campusId).toLowerCase();
      final query = _search.trim().toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          building.name.toLowerCase().contains(query) ||
          building.address.toLowerCase().contains(query) ||
          campusName.contains(query);
      return matchesCampus && matchesSearch;
    }).toList();
    return _RecordList(
      title: 'Buildings and blocks',
      count: buildings.length,
      addLabel: 'Add building / block',
      onAdd: _repository.campuses.isEmpty ? null : () => _editBuilding(),
      emptyMessage: 'No buildings or blocks match these filters.',
      toolbar: _campusFilter(),
      children: [
        for (final building in buildings)
          _RecordTile(
            title: '${building.name} · ${_kindLabel(building.kind)}',
            subtitle:
                '${_campusName(building.campusId)} · ${building.address} · ${_repository.apartments.where((item) => item.buildingId == building.id).length} units',
            status: building.status,
            onEdit: () => _editBuilding(building),
            onToggleStatus: () => _toggleBuilding(building),
          ),
      ],
    );
  }

  Widget _apartmentList() {
    final buildings = _repository.buildings
        .where(
          (building) => _campusId == null || building.campusId == _campusId,
        )
        .toList();
    final filteredBuildings = buildings
        .where((building) => _buildingId == null || building.id == _buildingId)
        .toList();
    final apartments = _repository.apartments.where((apartment) {
      final building = _buildingById(apartment.buildingId);
      if (building == null) return false;
      final query = _search.trim().toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          apartment.unitNumber.toLowerCase().contains(query) ||
          apartment.floor.toLowerCase().contains(query) ||
          building.name.toLowerCase().contains(query) ||
          _campusName(building.campusId).toLowerCase().contains(query);
      final matchesCampus = _campusId == null || building.campusId == _campusId;
      final matchesBuilding = _buildingId == null || building.id == _buildingId;
      return matchesCampus && matchesBuilding && matchesSearch;
    }).toList();
    return _RecordList(
      title: 'Apartments / units',
      count: apartments.length,
      addLabel: 'Add apartment',
      onAdd: filteredBuildings.isEmpty ? null : () => _editApartment(),
      emptyMessage: 'No apartments match these filters.',
      toolbar: Row(
        children: [
          Expanded(child: _campusFilter()),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String?>(
              initialValue: _buildingId,
              decoration: const InputDecoration(
                labelText: 'Building / block',
                isDense: true,
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All buildings'),
                ),
                ...filteredBuildings.map(
                  (building) => DropdownMenuItem<String?>(
                    value: building.id,
                    child: Text(building.name),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _buildingId = value),
            ),
          ),
        ],
      ),
      children: [
        for (final apartment in apartments)
          _RecordTile(
            title: apartment.unitNumber,
            subtitle:
                '${_buildingName(apartment.buildingId)} · ${_campusName(_buildingById(apartment.buildingId)?.campusId ?? '')} · Floor ${apartment.floor}',
            status: apartment.status,
            onEdit: () => _editApartment(apartment),
            onToggleStatus: () => _toggleApartment(apartment),
          ),
      ],
    );
  }

  Widget _campusFilter() => DropdownButtonFormField<String?>(
    initialValue: _campusId,
    decoration: const InputDecoration(labelText: 'Campus', isDense: true),
    items: [
      const DropdownMenuItem<String?>(value: null, child: Text('All campuses')),
      ..._repository.campuses.map(
        (campus) => DropdownMenuItem<String?>(
          value: campus.id,
          child: Text(campus.name),
        ),
      ),
    ],
    onChanged: (value) => setState(() {
      _campusId = value;
      _buildingId = null;
    }),
  );

  Future<void> _editCampus([CampusRecord? record]) async {
    var name = record?.name ?? '';
    var city = record?.city ?? '';
    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        scrollable: true,
        title: Text(record == null ? 'Add campus' : 'Edit campus'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const Key('campus-name-field'),
              onChanged: (value) => name = value,
              decoration: const InputDecoration(labelText: 'Campus name'),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (value) => city = value,
              decoration: const InputDecoration(labelText: 'City'),
            ),
          ],
        ),
        actions: _dialogActions(
          dialogContext,
          onSave: () {
            if (name.trim().isEmpty || city.trim().isEmpty) return;
            final next = CampusRecord(
              id: record?.id ?? _repository.nextId('campus'),
              name: name.trim(),
              city: city.trim(),
              status: record?.status ?? PropertyRecordStatus.active,
            );
            _repository.saveCampus(next);
            Navigator.pop(dialogContext, true);
          },
        ),
      ),
    );
    if (save == true && mounted) setState(() {});
  }

  Future<void> _editBuilding([BuildingRecord? record]) async {
    var name = record?.name ?? '';
    var address = record?.address ?? '';
    String? campusId = record?.campusId ?? _repository.campuses.firstOrNull?.id;
    var kind = record?.kind ?? BuildingKind.building;
    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          scrollable: true,
          title: Text(
            record == null ? 'Add building / block' : 'Edit building',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: campusId,
                decoration: const InputDecoration(labelText: 'Campus'),
                items: _repository.campuses
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.id,
                        child: Text(item.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setDialogState(() => campusId = value),
              ),
              TextField(
                onChanged: (value) => name = value,
                decoration: const InputDecoration(labelText: 'Name / number'),
              ),
              TextField(
                onChanged: (value) => address = value,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              DropdownButtonFormField<BuildingKind>(
                initialValue: kind,
                decoration: const InputDecoration(labelText: 'Type'),
                items: BuildingKind.values
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(_kindLabel(item)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setDialogState(() => kind = value);
                },
              ),
            ],
          ),
          actions: _dialogActions(
            dialogContext,
            onSave: () {
              if (campusId == null ||
                  name.trim().isEmpty ||
                  address.trim().isEmpty) {
                return;
              }
              _repository.saveBuilding(
                BuildingRecord(
                  id: record?.id ?? _repository.nextId('building'),
                  campusId: campusId!,
                  name: name.trim(),
                  kind: kind,
                  address: address.trim(),
                  status: record?.status ?? PropertyRecordStatus.active,
                ),
              );
              Navigator.pop(dialogContext, true);
            },
          ),
        ),
      ),
    );
    if (save == true && mounted) setState(() {});
  }

  Future<void> _editApartment([ApartmentRecord? record]) async {
    var unit = record?.unitNumber ?? '';
    var floor = record?.floor ?? '';
    String? buildingId =
        record?.buildingId ?? _repository.buildings.firstOrNull?.id;
    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          scrollable: true,
          title: Text(record == null ? 'Add apartment' : 'Edit apartment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: buildingId,
                decoration: const InputDecoration(
                  labelText: 'Building / block',
                ),
                items: _repository.buildings
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.id,
                        child: Text(
                          '${item.name} · ${_campusName(item.campusId)}',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setDialogState(() => buildingId = value),
              ),
              TextField(
                key: const Key('apartment-unit-field'),
                onChanged: (value) => unit = value,
                decoration: const InputDecoration(labelText: 'Unit number'),
              ),
              TextField(
                onChanged: (value) => floor = value,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Floor'),
              ),
            ],
          ),
          actions: _dialogActions(
            dialogContext,
            onSave: () {
              if (buildingId == null ||
                  unit.trim().isEmpty ||
                  floor.trim().isEmpty) {
                return;
              }
              final duplicate = _repository.apartments.any(
                (item) =>
                    item.id != record?.id &&
                    item.buildingId == buildingId &&
                    item.unitNumber.toLowerCase() == unit.trim().toLowerCase(),
              );
              if (duplicate) return;
              _repository.saveApartment(
                ApartmentRecord(
                  id: record?.id ?? _repository.nextId('apartment'),
                  buildingId: buildingId!,
                  unitNumber: unit.trim(),
                  floor: floor.trim(),
                  status: record?.status ?? PropertyRecordStatus.active,
                ),
              );
              Navigator.pop(dialogContext, true);
            },
          ),
        ),
      ),
    );
    if (save == true && mounted) setState(() {});
  }

  List<Widget> _dialogActions(
    BuildContext context, {
    required VoidCallback onSave,
  }) => [
    TextButton(
      onPressed: () => Navigator.pop(context, false),
      child: const Text('Cancel'),
    ),
    FilledButton(onPressed: onSave, child: const Text('Save')),
  ];

  Future<void> _toggleCampus(CampusRecord campus) async {
    final hasActiveBuildings = _repository.buildings.any(
      (item) =>
          item.campusId == campus.id &&
          item.status == PropertyRecordStatus.active,
    );
    if (campus.status == PropertyRecordStatus.active && hasActiveBuildings) {
      _showMessage('Deactivate or move its active buildings first.');
      return;
    }
    _repository.setCampusStatus(
      campus.id,
      campus.status == PropertyRecordStatus.active
          ? PropertyRecordStatus.inactive
          : PropertyRecordStatus.active,
    );
  }

  Future<void> _toggleBuilding(BuildingRecord building) async {
    final hasActiveApartments = _repository.apartments.any(
      (item) =>
          item.buildingId == building.id &&
          item.status == PropertyRecordStatus.active,
    );
    if (building.status == PropertyRecordStatus.active && hasActiveApartments) {
      _showMessage('Deactivate its active apartments first.');
      return;
    }
    _repository.setBuildingStatus(
      building.id,
      building.status == PropertyRecordStatus.active
          ? PropertyRecordStatus.inactive
          : PropertyRecordStatus.active,
    );
  }

  void _toggleApartment(ApartmentRecord apartment) =>
      _repository.setApartmentStatus(
        apartment.id,
        apartment.status == PropertyRecordStatus.active
            ? PropertyRecordStatus.inactive
            : PropertyRecordStatus.active,
      );

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String _campusName(String id) =>
      _repository.campuses
          .where((item) => item.id == id)
          .map((item) => item.name)
          .firstOrNull ??
      'Unknown campus';

  BuildingRecord? _buildingById(String id) =>
      _repository.buildings.where((item) => item.id == id).firstOrNull;

  String _buildingName(String id) =>
      _buildingById(id)?.name ?? 'Unknown building';
}

class _RecordList extends StatelessWidget {
  const _RecordList({
    required this.title,
    required this.count,
    required this.addLabel,
    required this.onAdd,
    required this.emptyMessage,
    required this.children,
    this.toolbar,
  });

  final String title;
  final int count;
  final String addLabel;
  final VoidCallback? onAdd;
  final String emptyMessage;
  final List<Widget> children;
  final Widget? toolbar;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
    children: [
      Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          Text('$count records'),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(addLabel),
          ),
        ],
      ),
      if (toolbar != null) ...[const SizedBox(height: 12), toolbar!],
      const SizedBox(height: 12),
      if (children.isEmpty)
        Padding(
          padding: const EdgeInsets.all(32),
          child: Center(child: Text(emptyMessage)),
        )
      else
        Card(child: Column(children: _withDividers(children))),
    ],
  );

  List<Widget> _withDividers(List<Widget> items) => [
    for (var index = 0; index < items.length; index++) ...[
      if (index > 0) const Divider(height: 1, indent: 16, endIndent: 16),
      items[index],
    ],
  ];
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.onEdit,
    required this.onToggleStatus,
  });

  final String title;
  final String subtitle;
  final PropertyRecordStatus status;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(title),
    subtitle: Text(subtitle),
    leading: Icon(
      status == PropertyRecordStatus.active
          ? Icons.check_circle_outline
          : Icons.pause_circle_outline,
      color: status == PropertyRecordStatus.active
          ? AdminTheme.teal
          : AdminTheme.copper,
    ),
    trailing: Wrap(
      spacing: 4,
      children: [
        IconButton(
          tooltip: 'Edit $title',
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          tooltip: status == PropertyRecordStatus.active
              ? 'Deactivate $title'
              : 'Activate $title',
          onPressed: onToggleStatus,
          icon: Icon(
            status == PropertyRecordStatus.active
                ? Icons.pause_circle_outline
                : Icons.play_circle_outline,
          ),
        ),
      ],
    ),
  );
}

class _LocalDataBadge extends StatelessWidget {
  const _LocalDataBadge();

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

String _kindLabel(BuildingKind kind) => switch (kind) {
  BuildingKind.block => 'Block',
  BuildingKind.tower => 'Tower',
  BuildingKind.building => 'Building',
};
