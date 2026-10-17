class ServiceGroup {
  const ServiceGroup({required this.name, required this.services});

  final String name;
  final List<String> services;
}

const freeServiceGroups = [
  ServiceGroup(
    name: 'Plumbing',
    services: [
      'Water leakage',
      'Drain blockage',
      'Pipe maintenance',
      'Water pressure issue',
    ],
  ),
  ServiceGroup(
    name: 'Electrical',
    services: [
      'Common area lighting',
      'Electrical fault',
      'Switch maintenance',
    ],
  ),
  ServiceGroup(
    name: 'Maintenance',
    services: ['Door repair', 'Window maintenance'],
  ),
  ServiceGroup(
    name: 'Cleaning',
    services: ['Corridor cleaning', 'Common area cleanliness'],
  ),
];

const paidServiceGroups = [
  ServiceGroup(
    name: 'Installation',
    services: [
      'Air conditioner installation',
      'Refrigerator installation',
      'Washing machine installation',
    ],
  ),
  ServiceGroup(
    name: 'Home Services',
    services: ['Furniture assembly', 'Painting', 'Minor renovation'],
  ),
  ServiceGroup(
    name: 'Electrical Upgrade',
    services: ['Additional sockets', 'Custom wiring'],
  ),
];

final allServiceGroups = [...freeServiceGroups, ...paidServiceGroups];