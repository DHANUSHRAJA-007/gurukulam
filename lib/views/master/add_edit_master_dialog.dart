import 'package:flutter/material.dart';

class AddEditMasterDialog extends StatefulWidget {
  final String title;
  final String? initialName;
  final bool? initialStatus;
  final bool isEdit;
  final Function(String, [bool?]) onSave;

  const AddEditMasterDialog({
    Key? key,
    required this.title,
    this.initialName,
    this.initialStatus,
    this.isEdit = false,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AddEditMasterDialog> createState() => _AddEditMasterDialogState();
}

class _AddEditMasterDialogState extends State<AddEditMasterDialog> {
  final TextEditingController _nameController = TextEditingController();
  bool _status = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null) {
      _nameController.text = widget.initialName!;
    }
    if (widget.initialStatus != null) {
      _status = widget.initialStatus!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.isEdit ? 'Edit' : 'Add'} ${widget.title}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '${widget.title} Name',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.label),
              ),
              autofocus: true,
              onSubmitted: (_) => _save(),
            ),
            if (widget.isEdit) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Status: '),
                  Switch(
                    value: _status,
                    onChanged: (value) {
                      setState(() {
                        _status = value;
                      });
                    },
                    activeThumbColor: Colors.green,
                  ),
                  Text(
                    _status ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: _status ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: Text(widget.isEdit ? 'Update' : 'Save'),
        ),
      ],
    );
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter ${widget.title.toLowerCase()} name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onSave(_nameController.text.trim(), _status);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
