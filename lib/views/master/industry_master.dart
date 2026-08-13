// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../models/master_model.dart';
// import '../../viewModels/master_viewmodel.dart';
// import 'add_edit_master_dialog.dart';
//
// class IndustryMaster extends StatefulWidget {
//   const IndustryMaster({Key? key}) : super(key: key);
//
//   @override
//   State<IndustryMaster> createState() => _IndustryMasterState();
// }
//
// class _IndustryMasterState extends State<IndustryMaster> {
//   final TextEditingController _industryController = TextEditingController();
//   final TextEditingController _searchController = TextEditingController();
//
//   String _searchText = '';
//
//   @override
//   void dispose() {
//     _industryController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => MasterViewModel(tableName: 'industry', title: 'Industry')
//         ..loadMasters(),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         // ============================================================
//         // TEAL HEADER - EXACT DESIGN FROM IMAGE
//         // ============================================================
//         appBar: AppBar(
//           backgroundColor: const Color(0xFF1B9E8E),
//           elevation: 0,
//           title: Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: Row(
//               children: [
//                 // Logo/Icon
//                 Container(
//                   width: 32,
//                   height: 32,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: const Icon(
//                     Icons.school,
//                     color: Color(0xFF1B9E8E),
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 // Logo Text
//                 const Text(
//                   'Gurukulam',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         body: Consumer<MasterViewModel>(
//           builder: (context, viewModel, child) {
//             if (viewModel.isLoading && viewModel.masters.isEmpty) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             if (viewModel.errorMessage != null) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
//                     const SizedBox(height: 15),
//                     Text(
//                       viewModel.errorMessage!,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontSize: 14, color: Colors.red),
//                     ),
//                     const SizedBox(height: 18),
//                     ElevatedButton.icon(
//                       onPressed: viewModel.loadMasters,
//                       icon: const Icon(Icons.refresh),
//                       label: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               );
//             }
//
//             final filteredIndustries = _getFilteredIndustries(viewModel.masters);
//
//             return Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ============================================================
//                   // TITLE - Industry Master
//                   // ============================================================
//                   const Text(
//                     'Industry Master',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // ============================================================
//                   // ADD INDUSTRY CARD - EXACT IMAGE DESIGN
//                   // ============================================================
//                   Card(
//                     color: Colors.white,
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Industry Label
//                           const Text(
//                             'Industry *',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           // Input + Button Row
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: TextField(
//                                   controller: _industryController,
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(6),
//                                       borderSide: const BorderSide(
//                                         color: Color(0xFFE0E0E0),
//                                       ),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(6),
//                                       borderSide: const BorderSide(
//                                         color: Color(0xFFE0E0E0),
//                                       ),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(6),
//                                       borderSide: const BorderSide(
//                                         color: Color(0xFF7C3AED),
//                                         width: 2,
//                                       ),
//                                     ),
//                                     contentPadding:
//                                     const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 12,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               // PURPLE ADD BUTTON
//                               ElevatedButton.icon(
//                                 onPressed: () {
//                                   _addIndustry(context, viewModel);
//                                 },
//                                 icon: const Icon(Icons.add, size: 18),
//                                 label: const Text('Add Industry'),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xFF7C3AED),
//                                   foregroundColor: Colors.white,
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 20,
//                                     vertical: 12,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//
//                   // ============================================================
//                   // INDUSTRY LIST CARD - EXACT IMAGE DESIGN
//                   // ============================================================
//                   Card(
//                     color: Colors.white,
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Industry List Heading + Search Row
//                           Row(
//                             mainAxisAlignment:
//                             MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 'Industry list:',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 200,
//                                 child: TextField(
//                                   controller: _searchController,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _searchText = value.toLowerCase();
//                                     });
//                                   },
//                                   decoration: InputDecoration(
//                                     hintText: 'Search Industry...',
//                                     hintStyle: TextStyle(
//                                       color: Colors.grey[400],
//                                       fontSize: 13,
//                                     ),
//                                     prefixIcon: Icon(
//                                       Icons.search,
//                                       color: Colors.grey[400],
//                                       size: 18,
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(6),
//                                       borderSide: const BorderSide(
//                                         color: Color(0xFFE0E0E0),
//                                       ),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(6),
//                                       borderSide: const BorderSide(
//                                         color: Color(0xFFE0E0E0),
//                                       ),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(6),
//                                       borderSide: const BorderSide(
//                                         color: Color(0xFF7C3AED),
//                                         width: 2,
//                                       ),
//                                     ),
//                                     contentPadding:
//                                     const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 10,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20),
//
//                           // ============================================================
//                           // TABLE HEADER
//                           // ============================================================
//                           Container(
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                             decoration: BoxDecoration(
//                               border: Border(
//                                 bottom: BorderSide(
//                                   color: Colors.grey[300]!,
//                                   width: 1,
//                                 ),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   flex: 1,
//                                   child: Text(
//                                     'S.NO',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.grey[600],
//                                       letterSpacing: 0.5,
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 3,
//                                   child: Text(
//                                     'INDUSTRY',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.grey[600],
//                                       letterSpacing: 0.5,
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 1,
//                                   child: Text(
//                                     'ACTIONS',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.grey[600],
//                                       letterSpacing: 0.5,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           // ============================================================
//                           // TABLE BODY
//                           // ============================================================
//                           if (filteredIndustries.isEmpty)
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 40),
//                               child: Center(
//                                 child: Text(
//                                   _searchText.isEmpty
//                                       ? 'No industries found'
//                                       : 'No matching industries',
//                                   style: TextStyle(
//                                     color: Colors.grey[500],
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           else
//                             ...List.generate(
//                               filteredIndustries.length,
//                                   (index) {
//                                 final master = filteredIndustries[index];
//                                 return Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 12,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     border: Border(
//                                       bottom: BorderSide(
//                                         color: Colors.grey[200]!,
//                                         width: 1,
//                                       ),
//                                     ),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       // S.NO
//                                       Expanded(
//                                         flex: 1,
//                                         child: Text(
//                                           '${index + 1}',
//                                           style: const TextStyle(
//                                             fontSize: 13,
//                                             color: Colors.black87,
//                                           ),
//                                         ),
//                                       ),
//                                       // INDUSTRY NAME
//                                       Expanded(
//                                         flex: 3,
//                                         child: Text(
//                                           master.name,
//                                           style: const TextStyle(
//                                             fontSize: 13,
//                                             color: Colors.black87,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                       // ACTIONS - Edit + Delete
//                                       Expanded(
//                                         flex: 1,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                           children: [
//                                             // EDIT ICON - PURPLE
//                                             IconButton(
//                                               icon: const Icon(
//                                                 Icons.edit,
//                                                 size: 18,
//                                                 color: Color(0xFF7C3AED),
//                                               ),
//                                               onPressed: () {
//                                                 _showEditDialog(
//                                                   context,
//                                                   master,
//                                                 );
//                                               },
//                                               constraints:
//                                               const BoxConstraints(),
//                                               padding: EdgeInsets.zero,
//                                             ),
//                                             const SizedBox(width: 8),
//                                             // DELETE ICON - RED
//                                             IconButton(
//                                               icon: const Icon(
//                                                 Icons.delete,
//                                                 size: 18,
//                                                 color: Color(0xFFEF4444),
//                                               ),
//                                               onPressed: () {
//                                                 _showDeleteConfirmation(
//                                                   context,
//                                                   master,
//                                                   viewModel,
//                                                 );
//                                               },
//                                               constraints:
//                                               const BoxConstraints(),
//                                               padding: EdgeInsets.zero,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // ============================================================
//                   // FOOTER
//                   // ============================================================
//                   const Center(
//                     child: Text(
//                       '© 2024 Sales Entry. All rights reserved.',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   // ============================================================
//   // FILTER INDUSTRIES BY SEARCH
//   // ============================================================
//   List<MasterModel> _getFilteredIndustries(List<MasterModel> industries) {
//     if (_searchText.isEmpty) {
//       return industries;
//     }
//     return industries
//         .where((industry) =>
//         industry.name.toLowerCase().contains(_searchText))
//         .toList();
//   }
//
//   // ============================================================
//   // ADD INDUSTRY
//   // ============================================================
//   Future<void> _addIndustry(
//       BuildContext context,
//       MasterViewModel viewModel,
//       ) async {
//     final name = _industryController.text.trim();
//
//     if (name.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter industry name'),
//           backgroundColor: Colors.orange,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }
//
//     try {
//       await viewModel.addMaster(name);
//       _industryController.clear();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Industry added successfully'),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString().replaceFirst('Exception: ', '')),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }
//
//   // ============================================================
//   // EDIT DIALOG
//   // ============================================================
//   void _showEditDialog(BuildContext context, MasterModel master) {
//     final viewModel = context.read<MasterViewModel>();
//
//     showDialog(
//       context: context,
//       builder: (dialogContext) {
//         return AddEditMasterDialog(
//           title: 'Industry',
//           initialName: master.name,
//           initialStatus: master.status,
//           isEdit: true,
//           onSave: (name, [status]) async {
//             await viewModel.updateMaster(
//               master.id,
//               name,
//               status ?? master.status,
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // ============================================================
//   // DELETE CONFIRMATION
//   // ============================================================
//   void _showDeleteConfirmation(
//       BuildContext context,
//       MasterModel master,
//       MasterViewModel viewModel,
//       ) {
//     showDialog(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           title: const Text('Delete Industry'),
//           content: Text(
//             'Are you sure you want to delete "${master.name}"?',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext);
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 Navigator.pop(dialogContext);
//                 await viewModel.deleteMaster(master.id);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }