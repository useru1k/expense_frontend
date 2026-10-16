import 'package:flutter/material.dart';

import '../models/currency.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_logo.dart';
import '../widgets/section_header.dart';
import '../widgets/surface_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth > 680 ? 32.0 : 20.0;
          return ListView(
            padding: EdgeInsets.fromLTRB(
                horizontalPadding, 22, horizontalPadding, 30),
            children: [
              Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Make Lumen feel like yours.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 22),
              SurfaceCard(
                child: Row(
                  children: [
                    const BrandLogo(size: 58, padding: 8),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alex Smith',
                              style: TextStyle(fontWeight: FontWeight.w800)),
                          SizedBox(height: 4),
                          Text('Personal finance workspace'),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const SectionHeader(title: 'Preferences'),
              const SizedBox(height: 10),
              SurfaceCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      value: isDark,
                      onChanged: state.toggleTheme,
                      secondary: Icon(isDark
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined),
                      title: const Text('Dark appearance'),
                      subtitle: Text(isDark
                          ? 'Easy on the eyes at night'
                          : 'Bright and clear during the day'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.payments_outlined),
                      title: const Text('Currency'),
                      subtitle: Text(state.selectedCurrency.displayName),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _showCurrencyPicker(context, state),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.notifications_none_rounded),
                      title: const Text('Notifications'),
                      subtitle: const Text('Budget alerts are on'),
                      trailing: Switch.adaptive(value: true, onChanged: (_) {}),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const SectionHeader(title: 'About'),
              const SizedBox(height: 10),
              SurfaceCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.auto_awesome_outlined),
                      title: const Text('Lumen Finance'),
                      subtitle: const Text('Version 1.0.0 · UI preview'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline_rounded),
                      title: const Text('About this preview'),
                      subtitle: const Text(
                          'Transactions are stored in your connected finance database.'),
                      onTap: () => showAboutDialog(
                        context: context,
                        applicationName: 'Lumen Finance',
                        applicationVersion: '1.0.0',
                        applicationLegalese: 'Phase 1 UI preview',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static void _showCurrencyPicker(BuildContext context, AppState state) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose currency',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'Amounts are shown with your selected local symbol.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: CurrencyOption.all.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final currency = CurrencyOption.all[index];
                    final isSelected =
                        currency.code == state.selectedCurrency.code;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text(currency.flag,
                          style: const TextStyle(fontSize: 24)),
                      title: Text(currency.name),
                      subtitle: Text('${currency.code}  •  ${currency.symbol}'),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded,
                              color: AppColors.green)
                          : null,
                      onTap: () {
                        state.setCurrency(currency);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
