import 'package:flutter/material.dart';

import 'admin_theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 1100 ? 4 : 2;
      return CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AdminTheme.paper,
            title: const Text('Operations overview'),
            actions: [
              const _SampleBadge(),
              const SizedBox(width: 16),
              IconButton(
                tooltip: 'Notifications (sample preview)',
                onPressed: () => _showSampleNotice(context),
                icon: const Icon(Icons.notifications_outlined),
              ),
              const CircleAvatar(
                radius: 17,
                backgroundColor: AdminTheme.tealLight,
                child: Text('A', style: TextStyle(color: AdminTheme.ink)),
              ),
              const SizedBox(width: 20),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            sliver: SliverList.list(
              children: [
                const _Intro(),
                const SizedBox(height: 20),
                _MetricsGrid(columns: columns),
                const SizedBox(height: 24),
                const _SectionHeading(
                  title: 'Requests requiring attention',
                  actionLabel: 'View queue',
                ),
                const SizedBox(height: 12),
                const _AttentionQueue(),
                const SizedBox(height: 24),
                const _SectionHeading(
                  title: 'Technician activity',
                  actionLabel: 'View technicians',
                ),
                const SizedBox(height: 12),
                const _TechnicianActivity(),
              ],
            ),
          ),
        ],
      );
    },
  );
}

void _showSampleNotice(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Sample notification preview'),
      content: const Text(
        'Notifications are example data only. Push delivery and the shared backend are not connected.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tuesday, 20 October',
              style: TextStyle(
                color: AdminTheme.teal,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Good morning, Admin',
              style: TextStyle(
                color: AdminTheme.ink,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Portfolio operations · Dubai Marina Campus',
              style: TextStyle(color: Color(0xFF5D706B)),
            ),
          ],
        ),
      ),
      FilledButton.icon(
        onPressed: null,
        icon: Icon(Icons.add),
        label: Text('New request'),
      ),
    ],
  );
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.columns});

  final int columns;

  @override
  Widget build(BuildContext context) {
    const metrics = [
      _Metric(
        'Open requests',
        '24',
        '6 need assignment',
        Icons.inbox_outlined,
        AdminTheme.teal,
      ),
      _Metric(
        'Awaiting approval',
        '3',
        '2 appointment changes',
        Icons.fact_check_outlined,
        AdminTheme.copper,
      ),
      _Metric(
        'Technicians on duty',
        '8',
        '2 currently travelling',
        Icons.engineering_outlined,
        AdminTheme.ink,
      ),
      _Metric(
        'Closed today',
        '11',
        'Average 46 min work time',
        Icons.task_alt_outlined,
        Color(0xFF648348),
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 148,
      ),
      itemBuilder: (context, index) => _MetricCard(metric: metrics[index]),
    );
  }
}

class _Metric {
  const _Metric(this.label, this.value, this.detail, this.icon, this.color);

  final String label;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _Metric metric;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: metric.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(metric.icon, color: metric.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  metric.label,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  metric.value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AdminTheme.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  metric.detail,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.actionLabel});

  final String title;
  final String actionLabel;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(color: AdminTheme.ink, fontWeight: FontWeight.w700),
        ),
      ),
      TextButton(onPressed: null, child: Text(actionLabel)),
    ],
  );
}

class _AttentionQueue extends StatelessWidget {
  const _AttentionQueue();

  @override
  Widget build(BuildContext context) => Card(
    child: Column(
      children: const [
        _QueueRow(
          number: 'FX-10482',
          issue: 'Water leak · A-302, Tower 3',
          status: 'Unassigned',
          priority: 'Urgent',
          color: AdminTheme.copper,
        ),
        Divider(height: 1, indent: 16, endIndent: 16),
        _QueueRow(
          number: 'FX-10479',
          issue: 'Appointment proposal · B-110, Tower 1',
          status: 'Needs your approval',
          priority: 'Today, 11:30',
          color: AdminTheme.teal,
        ),
        Divider(height: 1, indent: 16, endIndent: 16),
        _QueueRow(
          number: 'FX-10471',
          issue: 'Technician rejection · C-406, Tower 2',
          status: 'Review reason',
          priority: 'Blocked',
          color: Color(0xFF9A503B),
        ),
      ],
    ),
  );
}

class _QueueRow extends StatelessWidget {
  const _QueueRow({
    required this.number,
    required this.issue,
    required this.status,
    required this.priority,
    required this.color,
  });

  final String number;
  final String issue;
  final String status;
  final String priority;
  final Color color;

  @override
  Widget build(BuildContext context) => ListTile(
    minTileHeight: 72,
    leading: Container(
      width: 4,
      height: 42,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    title: Text('$number · $issue'),
    subtitle: Text(status),
    trailing: SizedBox(
      width: 130,
      child: Text(
        priority,
        textAlign: TextAlign.end,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

class _TechnicianActivity extends StatelessWidget {
  const _TechnicianActivity();

  @override
  Widget build(BuildContext context) => Card(
    child: Column(
      children: const [
        _ActivityRow(
          name: 'Rashid Al Mansoori',
          specialty: 'Plumbing',
          activity: 'Travelling · FX-10480',
          initials: 'RA',
        ),
        Divider(height: 1, indent: 16, endIndent: 16),
        _ActivityRow(
          name: 'Imran Qureshi',
          specialty: 'Electrical',
          activity: 'Working · FX-10476',
          initials: 'IQ',
        ),
      ],
    ),
  );
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.name,
    required this.specialty,
    required this.activity,
    required this.initials,
  });

  final String name;
  final String specialty;
  final String activity;
  final String initials;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(
      backgroundColor: AdminTheme.tealLight,
      child: Text(initials, style: const TextStyle(color: AdminTheme.ink)),
    ),
    title: Text(name),
    subtitle: Text('$specialty · $activity'),
    trailing: const Icon(Icons.chevron_right),
  );
}

class _SampleBadge extends StatelessWidget {
  const _SampleBadge();

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(vertical: 14),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: AdminTheme.tealLight,
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Center(
      child: Text(
        'SAMPLE DATA',
        style: TextStyle(
          color: AdminTheme.ink,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}
