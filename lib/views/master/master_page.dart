import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/master_model.dart';
import '../../viewModels/master_viewmodel.dart';
import 'add_edit_master_dialog.dart';

class MasterPage extends StatelessWidget {
  final String tableName;
  final String title;

  const MasterPage({Key? key, required this.tableName, required this.title})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          MasterViewModel(tableName: tableName, title: title)..loadMasters(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('$title Master'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                Provider.of<MasterViewModel>(
                  context,
                  listen: false,
                ).loadMasters();
              },
            ),
          ],
        ),
        body: Consumer<MasterViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading && viewModel.masters.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.errorMessage!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.loadMasters(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: viewModel.masters.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: viewModel.masters.length,
                          itemBuilder: (context, index) {
                            final master = viewModel.masters[index];
                            return _buildMasterCard(context, master, index);
                          },
                        ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: _buildFooter(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddDialog(context),
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'S.NO',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'NAME',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'STATUS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'ACTION',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterCard(BuildContext context, MasterModel master, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text('${index + 1}', style: const TextStyle(fontSize: 14)),
            ),
            Expanded(
              flex: 3,
              child: Text(
                master.name,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: master.status ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      master.status ? Icons.check_circle : Icons.cancel,
                      color: master.status ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      master.status ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 12,
                        color: master.status
                            ? Colors.green[800]
                            : Colors.red[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      master.status ? Icons.block : Icons.check_circle,
                      color: master.status ? Colors.orange : Colors.green,
                    ),
                    tooltip: master.status ? 'Deactivate' : 'Activate',
                    onPressed: () {
                      final viewModel = Provider.of<MasterViewModel>(
                        context,
                        listen: false,
                      );
                      _showToggleConfirmation(context, master, viewModel);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    tooltip: 'Edit',
                    onPressed: () => _showEditDialog(context, master),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete',
                    onPressed: () => _showDeleteConfirmation(
                      context,
                      master,
                      Provider.of<MasterViewModel>(context, listen: false),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No ${title.toLowerCase()}s found',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add one',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: const Center(
        child: Text(
          '© 2024 Sales Entry. All rights reserved.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final viewModel = Provider.of<MasterViewModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AddEditMasterDialog(
        title: title,
        onSave: (name, [status]) async {
          await viewModel.addMaster(name);
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, MasterModel master) {
    final viewModel = Provider.of<MasterViewModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AddEditMasterDialog(
        title: title,
        initialName: master.name,
        initialStatus: master.status,
        isEdit: true,
        onSave: (name, [status]) async {
          await viewModel.updateMaster(master.id, name, status!);
        },
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    MasterModel master,
    MasterViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete $title'),
        content: Text('Are you sure you want to delete "${master.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await viewModel.deleteMaster(master.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showToggleConfirmation(
    BuildContext context,
    MasterModel master,
    MasterViewModel viewModel,
  ) {
    final action = master.status ? 'deactivate' : 'activate';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${master.status ? 'Deactivate' : 'Activate'} $title'),
        content: Text('Are you sure you want to $action "${master.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await viewModel.toggleStatus(master.id, master.status);
            },
            style: TextButton.styleFrom(
              foregroundColor: master.status ? Colors.orange : Colors.green,
            ),
            child: Text(master.status ? 'Deactivate' : 'Activate'),
          ),
        ],
      ),
    );
  }
}

//usage
//Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => MasterPage(
//       tableName: 'industry_master',
//       title: 'Industry',
//     ),
//   ),
// );
