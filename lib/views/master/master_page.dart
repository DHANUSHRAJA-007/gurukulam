// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../models/master_model.dart';
// import '../../viewModels/master_viewmodel.dart';
// import 'add_edit_master_dialog.dart';

// class MasterPage extends StatelessWidget {
//   final String mastertype;
//   final String title;

//   const MasterPage({Key? key, required this.mastertype, required this.title})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) =>
//           MasterViewModel(tableName: mastertype, title: title)..loadMasters(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('$title Master'),
//           backgroundColor: Colors.blue,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.refresh),
//               onPressed: () {
//                 Provider.of<MasterViewModel>(
//                   context,
//                   listen: false,
//                 ).loadMasters();
//               },
//             ),
//           ],
//         ),
//         body: Consumer<MasterViewModel>(
//           builder: (context, viewModel, child) {
//             if (viewModel.isLoading && viewModel.masters.isEmpty) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (viewModel.errorMessage != null) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
//                     const SizedBox(height: 16),
//                     Text(
//                       viewModel.errorMessage!,
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: () => viewModel.loadMasters(),
//                       child: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             return Column(
//               children: [
//                 _buildHeader(context),
//                 Expanded(
//                   child: viewModel.masters.isEmpty
//                       ? _buildEmptyState(context)
//                       : ListView.builder(
//                           padding: const EdgeInsets.all(16),
//                           itemCount: viewModel.masters.length,
//                           itemBuilder: (context, index) {
//                             final master = viewModel.masters[index];
//                             return _buildMasterCard(context, master, index);
//                           },
//                         ),
//                 ),
//               ],
//             );
//           },
//         ),
//         bottomNavigationBar: _buildFooter(),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () => _showAddDialog(context),
//           backgroundColor: Colors.blue,
//           child: const Icon(Icons.add, color: Colors.white),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
//       ),
//       child: const Row(
//         children: [
//           Expanded(
//             flex: 1,
//             child: Text(
//               'S.NO',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               'NAME',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text(
//               'STATUS',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text(
//               'ACTION',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMasterCard(BuildContext context, MasterModel master, int index) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 8),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 1,
//               child: Text('${index + 1}', style: const TextStyle(fontSize: 14)),
//             ),
//             Expanded(
//               flex: 3,
//               child: Text(
//                 master.name,
//                 style: const TextStyle(fontSize: 14),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: master.status ? Colors.green[100] : Colors.red[100],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       master.status ? Icons.check_circle : Icons.cancel,
//                       color: master.status ? Colors.green : Colors.red,
//                       size: 16,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       master.status ? 'Active' : 'Inactive',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: master.status
//                             ? Colors.green[800]
//                             : Colors.red[800],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(
//                       master.status ? Icons.block : Icons.check_circle,
//                       color: master.status ? Colors.orange : Colors.green,
//                     ),
//                     tooltip: master.status ? 'Deactivate' : 'Activate',
//                     onPressed: () {
//                       final viewModel = Provider.of<MasterViewModel>(
//                         context,
//                         listen: false,
//                       );
//                       _showToggleConfirmation(context, master, viewModel);
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.edit, color: Colors.blue),
//                     tooltip: 'Edit',
//                     onPressed: () => _showEditDialog(context, master),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     tooltip: 'Delete',
//                     onPressed: () => _showDeleteConfirmation(
//                       context,
//                       master,
//                       Provider.of<MasterViewModel>(context, listen: false),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             'No ${title.toLowerCase()}s found',
//             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Tap the + button to add one',
//             style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFooter() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       decoration: BoxDecoration(
//         border: Border(top: BorderSide(color: Colors.grey[300]!)),
//       ),
//       child: const Center(
//         child: Text(
//           '© 2024 Sales Entry. All rights reserved.',
//           style: TextStyle(fontSize: 12, color: Colors.grey),
//         ),
//       ),
//     );
//   }

//   void _showAddDialog(BuildContext context) {
//     final viewModel = Provider.of<MasterViewModel>(context, listen: false);
//     showDialog(
//       context: context,
//       builder: (context) => AddEditMasterDialog(
//         title: title,
//         onSave: (name, [status]) async {
//           await viewModel.addMaster(name);
//         },
//       ),
//     );
//   }

//   void _showEditDialog(BuildContext context, MasterModel master) {
//     final viewModel = Provider.of<MasterViewModel>(context, listen: false);
//     showDialog(
//       context: context,
//       builder: (context) => AddEditMasterDialog(
//         title: title,
//         initialName: master.name,
//         initialStatus: master.status,
//         isEdit: true,
//         onSave: (name, [status]) async {
//           await viewModel.updateMaster(master.id, name, status!);
//         },
//       ),
//     );
//   }

//   void _showDeleteConfirmation(
//     BuildContext context,
//     MasterModel master,
//     MasterViewModel viewModel,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Delete $title'),
//         content: Text('Are you sure you want to delete "${master.name}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await viewModel.deleteMaster(master.id);
//             },
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showToggleConfirmation(
//     BuildContext context,
//     MasterModel master,
//     MasterViewModel viewModel,
//   ) {
//     final action = master.status ? 'deactivate' : 'activate';
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('${master.status ? 'Deactivate' : 'Activate'} $title'),
//         content: Text('Are you sure you want to $action "${master.name}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await viewModel.toggleStatus(master.id, master.status);
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: master.status ? Colors.orange : Colors.green,
//             ),
//             child: Text(master.status ? 'Deactivate' : 'Activate'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// //usage
// //Navigator.push(
// //   context,
// //   MaterialPageRoute(
// //     builder: (context) => MasterPage(
// //       tableName: 'industry_master',
// //       title: 'Industry',
// //     ),
// //   ),
// // );

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/master_model.dart';
import '../../viewModels/master_viewmodel.dart';
import 'add_edit_master_dialog.dart';

// class MasterPage extends StatelessWidget {
//   final String tableName;
//   final String title;
//
//   const MasterPage({super.key, required this.tableName, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) =>
//           MasterViewModel(tableName: tableName, title: title)..loadMasters(),
//       child: _MasterPageContent(title: title),
//     );
//   }
// }
class MasterPage extends StatelessWidget {
  final String tableName;
  final String title;

  const MasterPage({super.key, required this.tableName, required this.title});

  @override
  Widget build(BuildContext context) {
    // 🔥 Use a unique key based on tableName to force recreation
    return ChangeNotifierProvider(
      key: ValueKey(tableName), // ← This forces recreation
      create: (_) =>
      MasterViewModel(tableName: tableName, title: title)..loadMasters(),
      child: _MasterPageContent(title: title),
    );
  }
}
// ============================================================
// MASTER PAGE CONTENT
// ============================================================

class _MasterPageContent extends StatefulWidget {
  final String title;

  const _MasterPageContent({required this.title});

  @override
  State<_MasterPageContent> createState() => _MasterPageContentState();
}

class _MasterPageContentState extends State<_MasterPageContent> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: _buildAppBar(context),

      body: Consumer<MasterViewModel>(
        builder: (context, viewModel, child) {
          return _buildBody(context, viewModel);
        },
      ),
    );
  }

  // ==========================================================
  // APP BAR
  // ==========================================================

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0D9488),
      foregroundColor: Colors.white,
      elevation: 0,

      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 22),
        onPressed: () {
          Navigator.pop(context);
        },
      ),

      title: Text(
        '${widget.title} Master',
        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
      ),

      actions: [
        IconButton(
          tooltip: 'Refresh',
          icon: const Icon(Icons.refresh, size: 21),
          onPressed: () {
            context.read<MasterViewModel>().loadMasters();
          },
        ),

        const SizedBox(width: 8),
      ],
    );
  }

  // ==========================================================
  // BODY
  // ==========================================================

  Widget _buildBody(BuildContext context, MasterViewModel viewModel) {
    if (viewModel.isLoading && viewModel.masters.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF3869EB)),
      );
    }

    if (viewModel.errorMessage != null) {
      return _buildErrorState(context, viewModel);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 700;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 32),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // =================================================
              // MASTER FORM
              // =================================================
              _buildMasterForm(context, viewModel, isMobile),

              const SizedBox(height: 24),

              // =================================================
              // MASTER LIST
              // =================================================
              _buildMasterList(context, viewModel, isMobile),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================
  // MASTER FORM CARD
  // ==========================================================

  Widget _buildMasterForm(
      BuildContext context,
      MasterViewModel viewModel,
      bool isMobile,
      ) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(isMobile ? 20 : 32),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),

            blurRadius: 25,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // TITLE
          Text(
            '${widget.title} Master',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF313131),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Add and manage ${widget.title.toLowerCase()} records',
            style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
          ),

          const SizedBox(height: 28),

          const Text(
            'Name *',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF313131),
            ),
          ),

          const SizedBox(height: 8),

          // DESKTOP / MOBILE
          if (isMobile)
            Column(
              children: [
                _buildNameInput(),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: _buildAddButton(context),
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Expanded(child: _buildNameInput()),

                const SizedBox(width: 16),

                SizedBox(
                  width: 170,
                  height: 46,
                  child: _buildAddButton(context),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // NAME INPUT
  // ==========================================================

  Widget _buildNameInput() {
    return TextField(
      controller: _nameController,

      decoration: InputDecoration(
        hintText: 'Enter ${widget.title.toLowerCase()} name',

        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),

        filled: true,
        fillColor: const Color(0xFFFAFAFC),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFFE2E5EC)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFFE2E5EC)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFF3869EB), width: 1.3),
        ),
      ),

      onSubmitted: (_) {
        _addMaster();
      },
    );
  }

  // ==========================================================
  // ADD BUTTON
  // ==========================================================

  Widget _buildAddButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        _addMaster();
        _nameController.clear();
      },

      icon: const Icon(Icons.add, size: 18),

      label: Text(
        'Add ${widget.title}',
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),

      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3869EB),
        foregroundColor: Colors.white,
        elevation: 0,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
    );
  }

  Future<void> _addMaster() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      _showMessage(
        'Please enter ${widget.title.toLowerCase()} name',
        Colors.orange,
      );
      return;
    }

    final viewModel = context.read<MasterViewModel>();

    try {
      await viewModel.addMaster(name);

      // Clear input immediately after successful insert
      _nameController.clear();

      _showMessage('${widget.title} added successfully', Colors.green);
    } catch (e) {
      _showMessage(e.toString().replaceFirst('Exception: ', ''), Colors.red);
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================================
  // MASTER LIST CARD
  // ==========================================================

  Widget _buildMasterList(
      BuildContext context,
      MasterViewModel viewModel,
      bool isMobile,
      ) {
    final masters = _filteredMasters(viewModel.masters);

    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(isMobile ? 20 : 32),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),

            blurRadius: 25,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // =================================================
          // LIST HEADER
          // =================================================
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                _buildListTitle(),

                const SizedBox(height: 14),

                _buildSearchBox(isMobile),
              ],
            )
          else
            Row(
              children: [
                Expanded(child: _buildListTitle()),

                _buildSearchBox(isMobile),
              ],
            ),

          const SizedBox(height: 22),

          // =================================================
          // LIST
          // =================================================
          if (masters.isEmpty)
            _buildEmptyList()
          else
            _buildTable(context, viewModel, masters, isMobile),
        ],
      ),
    );
  }

  // ==========================================================
  // LIST TITLE
  // ==========================================================

  Widget _buildListTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          '${widget.title} List',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF313131),
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'Manage existing records',
          style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
        ),
      ],
    );
  }

  // ==========================================================
  // SEARCH
  // ==========================================================

  Widget _buildSearchBox(bool isMobile) {
    return SizedBox(
      width: isMobile ? double.infinity : 250,

      height: 42,

      child: TextField(
        controller: _searchController,

        onChanged: (value) {
          setState(() {
            _searchText = value.trim().toLowerCase();
          });
        },

        decoration: InputDecoration(
          hintText: 'Search ${widget.title.toLowerCase()}...',

          hintStyle: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),

          prefixIcon: const Icon(
            Icons.search,
            size: 18,
            color: Color(0xFF999999),
          ),

          suffixIcon: _searchText.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, size: 17),
            onPressed: () {
              _searchController.clear();

              setState(() {
                _searchText = '';
              });
            },
          )
              : null,

          filled: true,

          fillColor: const Color(0xFFFAFAFC),

          contentPadding: const EdgeInsets.symmetric(vertical: 10),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),

            borderSide: const BorderSide(color: Color(0xFFE2E5EC)),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),

            borderSide: const BorderSide(color: Color(0xFFE2E5EC)),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),

            borderSide: const BorderSide(color: Color(0xFF3869EB)),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // FILTER
  // ==========================================================

  List<MasterModel> _filteredMasters(List<MasterModel> masters) {
    if (_searchText.isEmpty) {
      return masters;
    }

    return masters.where((master) {
      return master.name.toLowerCase().contains(_searchText);
    }).toList();
  }

  // ==========================================================
  // TABLE
  // ==========================================================

  Widget _buildTable(
      BuildContext context,
      MasterViewModel viewModel,
      List<MasterModel> masters,
      bool isMobile,
      ) {
    if (isMobile) {
      return Column(
        children: List.generate(masters.length, (index) {
          return _buildMobileCard(context, viewModel, masters[index], index);
        }),
      );
    }

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE7E9EF)),

        borderRadius: BorderRadius.circular(8),
      ),

      child: Column(
        children: [
          _buildTableHeader(),

          ...List.generate(masters.length, (index) {
            return _buildTableRow(context, viewModel, masters[index], index);
          }),
        ],
      ),
    );
  }

  // ==========================================================
  // TABLE HEADER
  // ==========================================================

  Widget _buildTableHeader() {
    return Container(
      height: 48,

      padding: const EdgeInsets.symmetric(horizontal: 16),

      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FC),

        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),

      child: const Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              'S.NO',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: .5,
                color: Color(0xFF888888),
              ),
            ),
          ),

          Expanded(
            child: Text(
              'NAME',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: .5,
                color: Color(0xFF888888),
              ),
            ),
          ),

          SizedBox(
            width: 100,
            child: Text(
              'STATUS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: .5,
                color: Color(0xFF888888),
              ),
            ),
          ),

          SizedBox(
            width: 150,
            child: Text(
              'ACTIONS',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: .5,
                color: Color(0xFF888888),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TABLE ROW
  // ==========================================================

  Widget _buildTableRow(
      BuildContext context,
      MasterViewModel viewModel,
      MasterModel master,
      int index,
      ) {
    return Container(
      height: 62,

      padding: const EdgeInsets.symmetric(horizontal: 16),

      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF0F1F4))),
      ),

      child: Row(
        children: [
          // S.NO
          SizedBox(
            width: 70,
            child: Text(
              '${index + 1}',
              style: const TextStyle(fontSize: 13, color: Color(0xFF777777)),
            ),
          ),

          // NAME
          Expanded(
            child: Text(
              master.name,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF313131),
              ),
            ),
          ),

          // STATUS
          SizedBox(width: 100, child: _buildStatusBadge(master)),

          // ACTIONS
          SizedBox(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,

              children: [
                _buildActionButton(
                  icon: master.status
                      ? Icons.block_outlined
                      : Icons.check_circle_outline,

                  color: master.status
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF16A34A),

                  tooltip: master.status ? 'Deactivate' : 'Activate',

                  onPressed: () {
                    _showToggleConfirmation(context, master, viewModel);
                  },
                ),

                const SizedBox(width: 6),

                _buildActionButton(
                  icon: Icons.edit_outlined,

                  color: const Color(0xFF3869EB),

                  tooltip: 'Edit',

                  onPressed: () {
                    _showEditDialog(context, master);
                  },
                ),

                const SizedBox(width: 6),

                _buildActionButton(
                  icon: Icons.delete_outline,

                  color: const Color(0xFFEF4444),

                  tooltip: 'Delete',

                  onPressed: () {
                    _showDeleteConfirmation(context, master, viewModel);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // STATUS
  // ==========================================================

  Widget _buildStatusBadge(MasterModel master) {
    final bool active = master.status;

    return Align(
      alignment: Alignment.centerLeft,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),

        decoration: BoxDecoration(
          color: active ? const Color(0xFFECFDF3) : const Color(0xFFFEF2F2),

          borderRadius: BorderRadius.circular(20),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: 6,
              height: 6,

              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFF16A34A)
                    : const Color(0xFFEF4444),

                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: 6),

            Text(
              active ? 'Active' : 'Inactive',

              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,

                color: active
                    ? const Color(0xFF15803D)
                    : const Color(0xFFDC2626),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // ACTION BUTTON
  // ==========================================================

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,

      child: InkWell(
        onTap: onPressed,

        borderRadius: BorderRadius.circular(6),

        child: Container(
          width: 34,
          height: 34,

          decoration: BoxDecoration(
            color: Colors.white,

            border: Border.all(color: const Color(0xFFE2E5EC)),

            borderRadius: BorderRadius.circular(6),
          ),

          child: Icon(icon, size: 17, color: color),
        ),
      ),
    );
  }

  // ==========================================================
  // MOBILE CARD
  // ==========================================================

  Widget _buildMobileCard(
      BuildContext context,
      MasterViewModel viewModel,
      MasterModel master,
      int index,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        border: Border.all(color: const Color(0xFFE7E9EF)),

        borderRadius: BorderRadius.circular(10),
      ),

      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,

            alignment: Alignment.center,

            decoration: const BoxDecoration(
              color: Color(0xFFEEF2FF),
              shape: BoxShape.circle,
            ),

            child: Text(
              '${index + 1}',

              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3869EB),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  master.name,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 7),

                _buildStatusBadge(master),
              ],
            ),
          ),

          Row(
            children: [
              _buildActionButton(
                icon: Icons.edit_outlined,
                color: const Color(0xFF3869EB),
                tooltip: 'Edit',
                onPressed: () {
                  _showEditDialog(context, master);
                },
              ),

              const SizedBox(width: 5),

              _buildActionButton(
                icon: Icons.delete_outline,
                color: const Color(0xFFEF4444),
                tooltip: 'Delete',
                onPressed: () {
                  _showDeleteConfirmation(context, master, viewModel);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // EMPTY
  // ==========================================================

  Widget _buildEmptyList() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(vertical: 50),

      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 50, color: Colors.grey.shade300),

          const SizedBox(height: 12),

          Text(
            _searchText.isEmpty
                ? 'No ${widget.title.toLowerCase()}s found'
                : 'No matching records found',

            style: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ERROR
  // ==========================================================

  Widget _buildErrorState(BuildContext context, MasterViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),

          const SizedBox(height: 15),

          Text(
            viewModel.errorMessage ?? 'Something went wrong',

            textAlign: TextAlign.center,

            style: const TextStyle(fontSize: 14, color: Colors.red),
          ),

          const SizedBox(height: 18),

          ElevatedButton.icon(
            onPressed: viewModel.loadMasters,

            icon: const Icon(Icons.refresh),

            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ADD DIALOG
  // ==========================================================

  void _showAddDialog(BuildContext context) {
    final viewModel = context.read<MasterViewModel>();

    showDialog(
      context: context,

      builder: (dialogContext) {
        return AddEditMasterDialog(
          title: widget.title,

          onSave: (name, [status]) async {
            await viewModel.addMaster(name);
          },
        );
      },
    );
  }

  // ==========================================================
  // EDIT DIALOG
  // ==========================================================

  void _showEditDialog(BuildContext context, MasterModel master) {
    final viewModel = context.read<MasterViewModel>();

    showDialog(
      context: context,

      builder: (dialogContext) {
        return AddEditMasterDialog(
          title: widget.title,

          initialName: master.name,

          initialStatus: master.status,

          isEdit: true,

          onSave: (name, [status]) async {
            await viewModel.updateMaster(
              master.id,
              name,
              status ?? master.status,
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // DELETE CONFIRMATION
  // ==========================================================

  void _showDeleteConfirmation(
      BuildContext context,
      MasterModel master,
      MasterViewModel viewModel,
      ) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Delete ${widget.title}'),

          content: Text(
            'Are you sure you want to delete '
                '"${master.name}"?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await viewModel.deleteMaster(master.id);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),

              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // TOGGLE STATUS
  // ==========================================================

  void _showToggleConfirmation(
      BuildContext context,
      MasterModel master,
      MasterViewModel viewModel,
      ) {
    final bool active = master.status;

    final String action = active ? 'deactivate' : 'activate';

    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            '${active ? 'Deactivate' : 'Activate'} '
                '${widget.title}',
          ),

          content: Text(
            'Are you sure you want to '
                '$action "${master.name}"?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await viewModel.toggleStatus(master.id, master.status);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: active ? Colors.orange : Colors.green,

                foregroundColor: Colors.white,
              ),

              child: Text(active ? 'Deactivate' : 'Activate'),
            ),
          ],
        );
      },
    );
  }
}
