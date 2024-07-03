import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pagination/dto/book.dart';
import 'package:flutter_pagination/book_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class UpdateBookPage extends StatefulWidget {
  final String token;
  final BookDTO book;

  UpdateBookPage({required this.token, required this.book});

  @override
  _UpdateBookPageState createState() => _UpdateBookPageState();
}

class _UpdateBookPageState extends State<UpdateBookPage> {
  final BookService _bookService = BookService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  File? _image;
  String _status = 'New';

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.book.name ?? '';
    _priceController.text = widget.book.price?.toString() ?? '';
    _descController.text = widget.book.desc ?? '';
    _status = widget.book.status ?? 'New'; // Initialize status
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Book'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(labelText: 'Status'),
                items: ['New', 'Old'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a status';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: _image == null
                    ? widget.book.imagePath != null
                        ? Image.file(File(widget.book.imagePath!), height: 150)
                        : Container(
                            height: 150,
                            color: Colors.grey[300],
                            child: Icon(Icons.add_a_photo, size: 50),
                          )
                    : Image.file(_image!, height: 150),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateBook,
                child: Text('Update Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> _saveImageLocally(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = basename(image.path);
    final localImage = await image.copy('${directory.path}/$fileName');
    return localImage.path;
  }

  Future<void> _updateBook() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? localImagePath;
        if (_image != null) {
          localImagePath = await _saveImageLocally(_image!);
        }

        await _bookService.updateBook(
          widget.token,
          BookDTO(
            id: widget.book.id,
            name: _nameController.text,
            price: int.parse(_priceController.text),
            desc: _descController.text,
            status: _status,
            createdAt: widget.book.createdAt ?? '',
            updatedAt: widget.book.updatedAt ?? '',
            imagePath: localImagePath,
          ),
          _image, // pass the image file if needed
        );
        Navigator.pop(context as BuildContext, true); // navigate back on success
      } catch (e) {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('Failed to update book: $e')),
        );
      }
    }
  }
}
