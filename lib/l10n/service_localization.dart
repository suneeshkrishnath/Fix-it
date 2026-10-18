import 'generated/app_localizations.dart';

String localizedServiceCategory(AppLocalizations l10n, String category) =>
    switch (category) {
      'Plumbing' => l10n.plumbing,
      'Electrical' => l10n.electrical,
      'Maintenance' => l10n.maintenance,
      'Cleaning' => l10n.cleaning,
      'Installation' => l10n.installation,
      'Home Services' => l10n.homeServices,
      'Electrical Upgrade' => l10n.electricalUpgrade,
      'Additional Services' => l10n.additionalServices,
      _ => category,
    };

String localizedServiceType(AppLocalizations l10n, String service) =>
    switch (service) {
      'Water leakage' => l10n.waterLeakage,
      'Drain blockage' => l10n.drainBlockage,
      'Pipe maintenance' => l10n.pipeMaintenance,
      'Water pressure issue' => l10n.waterPressureIssue,
      'Common area lighting' => l10n.commonAreaLighting,
      'Electrical fault' => l10n.electricalFault,
      'Switch maintenance' => l10n.switchMaintenance,
      'Door repair' => l10n.doorRepair,
      'Window maintenance' => l10n.windowMaintenance,
      'Corridor cleaning' => l10n.corridorCleaning,
      'Common area cleanliness' => l10n.commonAreaCleanliness,
      'Air conditioner installation' => l10n.airConditionerInstallation,
      'Refrigerator installation' => l10n.refrigeratorInstallation,
      'Washing machine installation' => l10n.washingMachineInstallation,
      'Furniture assembly' => l10n.furnitureAssembly,
      'Painting' => l10n.painting,
      'Minor renovation' => l10n.minorRenovation,
      'Additional sockets' => l10n.additionalSockets,
      'Custom wiring' => l10n.customWiring,
      'Housemaid' => l10n.housemaid,
      'Babysitter' => l10n.babysitter,
      'Proxy driver' => l10n.proxyDriver,
      'Deep cleaning' => l10n.deepCleaning,
      _ => service,
    };

String localizedStatus(AppLocalizations l10n, String status) => switch (status) {
      'submitted' => l10n.statusSubmitted,
      'accepted' => l10n.statusAccepted,
      'assigned' => l10n.statusAssigned,
      'appointmentScheduled' => l10n.statusAppointmentScheduled,
      'inProgress' => l10n.statusInProgress,
      'completed' => l10n.statusCompleted,
      'rejected' => l10n.statusRejected,
      'cancelled' => l10n.statusCancelled,
      _ => status,
    };

String localizedPriority(AppLocalizations l10n, String priority) =>
    switch (priority) {
      'low' => l10n.priorityLow,
      'normal' => l10n.priorityNormal,
      'high' => l10n.priorityHigh,
      _ => priority,
    };