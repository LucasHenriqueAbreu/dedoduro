import 'dart:io';

import 'package:dedoduro/dao/reclamacao_dao.dart';
import 'package:dedoduro/repositories/reclamacao_repository.dart';
import 'package:dedoduro/repositories/reclamacao_repository_interface.dart';
import 'package:dedoduro/shared/db/database_helper.dart';
import 'package:dedoduro/shared/geo_location/geo_location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  final ImagePicker _picker = ImagePicker();
  IReclamacaoRepository reclamacaoRepository =
      ReclamacaoRepository(DatabaseHelper());
  ReclamacaoDao reclamacaoDao = ReclamacaoDao();

  final form = fb.group({
    'titulo': ['', Validators.required],
    'descricao': ['', Validators.required],
    'foto': ['', Validators.required],
    'lat': ['', Validators.required],
    'lng': ['', Validators.required],
  });

  Position _position;

  @override
  void initState() {
    _getLoacation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de reclamação'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _imageViewer(),
            ),
            _createForm(),
          ],
        ),
      ),
      floatingActionButton: _createFloatingActionButtom(),
    );
  }

  FutureBuilder _imageViewer() {
    return FutureBuilder<void>(
      future: retrieveLostData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Text(
              'Você ainda não escolheu uma imagem.',
              textAlign: TextAlign.center,
            );
          case ConnectionState.done:
            return _previewImage();
          default:
            if (snapshot.hasError) {
              return Text(
                'Erro: ${snapshot.error}}',
                textAlign: TextAlign.center,
              );
            } else {
              return const Text(
                'Você ainda não escolheu uma imagem.',
                textAlign: TextAlign.center,
              );
            }
        }
      },
    );
  }

  ReactiveForm _createForm() {
    return ReactiveForm(
      formGroup: this.form,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ReactiveTextField(
              formControlName: 'titulo',
              decoration: InputDecoration(
                labelText: 'titulo',
                hintText: 'Informe o titulo',
              ),
              validationMessages: {'required': 'titulo é obrigatório'},
            ),
            ReactiveTextField(
              formControlName: 'descricao',
              decoration: InputDecoration(
                labelText: 'descricao',
                hintText: 'Informe o descricao',
              ),
              validationMessages: {'required': 'descricao é obrigatório'},
            ),
            _position != null
                ? Row(
                    children: [
                      Text('latitude: ${_position.latitude}'),
                      Text('longitude: ${_position.longitude}'),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
            RaisedButton(
              onPressed: () async {
                await _salvar();
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            )
          ],
        ),
      ),
    );
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return Image.file(File(_imageFile.path));
    } else if (_pickImageError != null) {
      return Text(
        'Erro: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'Você ainda não escolheu uma imagem.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _salvar() async {
    form.control('foto').value = _imageFile.path;
    form.control('lat').value = _position.latitude.toString();
    form.control('lng').value = _position.longitude.toString();
    if (form.valid) {
      await reclamacaoRepository.insert(reclamacaoDao.fromMap(form.value));
    } else {
      form.touch();
    }
  }

  Column _createFloatingActionButtom() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          onPressed: () {
            _onImageButtonPressed(ImageSource.gallery, context: context);
          },
          heroTag: 'image0',
          tooltip: 'Escolha uma imagem da galeria',
          child: const Icon(Icons.photo_library),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: FloatingActionButton(
            onPressed: () {
              _onImageButtonPressed(ImageSource.camera, context: context);
            },
            heroTag: 'image1',
            tooltip: 'Tire uma foto',
            child: const Icon(Icons.camera_alt),
          ),
        ),
      ],
    );
  }

  void _getLoacation() async {
    var position = await GeoLocationService.getCurrentPosition();
    setState(() {
      _position = position;
    });
  }
}
