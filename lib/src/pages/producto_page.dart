

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/provider/productos_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _guardando = false;

  final productoProvider = new ProductosProvider();

  ProductoModel producto = new ProductoModel();

  File foto;

  @override
  Widget build(BuildContext context) {

final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
if (prodData != null) {
  producto =prodData;
}
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () => _procesarImagen(ImageSource.gallery),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => _procesarImagen(ImageSource.camera),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _crearNombre() {
    return TextFormField(
      onSaved: (value) => producto.titulo = value,
      initialValue: producto.titulo,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
    );
  }

  _crearPrecio() {
    return TextFormField(
      onSaved: (value) => producto.valor = double.parse(value),
      initialValue: producto.valor.toString(),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Solo números';
        }
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Precio'),
    );
  }

  _crearBoton() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.deepPurple,
        label: Text('Guardar'),
        icon: Icon(Icons.save),
        onPressed: (_guardando ) ? null :_submit,
      ),
    );
  }

   Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    
    setState(() {
    _guardando = true;
      
    });

    if (foto != null ) {
   producto.fotoUrl = await  productoProvider.subirImagen(foto);
    }

    if(producto.id == null) {
productoProvider.crearProducto(producto);
    } else { productoProvider.editarProducto(producto);}

mostrarSnackbar('Registro guardado');

Navigator.pop(context);

  }

void mostrarSnackbar (String mensaje) {
 final snackBar = SnackBar(
content: Text(mensaje),
duration: Duration(milliseconds: 1500),
 );

scaffoldKey.currentState.showSnackBar(snackBar);

}

_mostrarFoto () {

    if (producto.fotoUrl != null) {
 
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/original.gif'),
        height: 300,
        fit: BoxFit.contain,
      );
 
    } else {
 
      if( foto != null ){
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/original.png');
    }
}



_procesarImagen (ImageSource origen) async {
  foto = await  ImagePicker.pickImage(source: origen);
if (foto != null) {
producto.fotoUrl = null;

}
setState(() {});

}
 
}
