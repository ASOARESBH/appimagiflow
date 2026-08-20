import 'package:flutter/material.dart';

import '../../shared/resource_list_screen.dart';

class FinanceiroScreen extends StatelessWidget {
  const FinanceiroScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Financeiro')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _FinancialEntry(
              title: 'Contas a pagar',
              icon: Icons.call_made_outlined,
              color: Colors.red.shade700,
              onTap: () => _openPayables(context),
            ),
            const SizedBox(height: 10),
            _FinancialEntry(
              title: 'Contas a receber',
              icon: Icons.call_received_outlined,
              color: Colors.green.shade700,
              onTap: () => _openReceivables(context),
            ),
            const SizedBox(height: 24),
            const Text(
                'As baixas são confirmadas no detalhe de cada título conforme suas permissões.'),
          ],
        ),
      );

  void _openPayables(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResourceListScreen(
          title: 'Contas a pagar',
          path: '/api/mobile/v1/financeiro/contas-pagar',
          itemTitle: (item) => "${item['descricao'] ?? 'Conta a pagar'}",
          itemSubtitle: (item) =>
              "R\$ ${item['valor'] ?? '0,00'} · ${item['data_vencimento'] ?? ''} · ${item['status'] ?? ''}",
        ),
      ),
    );
  }

  void _openReceivables(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResourceListScreen(
          title: 'Contas a receber',
          path: '/api/mobile/v1/financeiro/contas-receber',
          itemTitle: (item) => "${item['descricao'] ?? 'Conta a receber'}",
          itemSubtitle: (item) =>
              "R\$ ${item['valor'] ?? '0,00'} · ${item['data_vencimento'] ?? ''} · ${item['status'] ?? ''}",
        ),
      ),
    );
  }
}

class _FinancialEntry extends StatelessWidget {
  const _FinancialEntry(
      {required this.title,
      required this.icon,
      required this.color,
      required this.onTap});

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
              backgroundColor: color.withValues(alpha: .12),
              foregroundColor: color,
              child: Icon(icon)),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
        ),
      );
}
