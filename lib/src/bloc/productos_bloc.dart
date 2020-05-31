import 'dart:io';

import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/provider/productos_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc {
final _productosController = new BehaviorSubject<List<ProductoModel>>();
final _cargandoController = new BehaviorSubject<bool>();

final _productProvider = new ProductosProvider();

Stream<List<ProductoModel>> get productosStream => _productosController.stream;
Stream<bool> get cargando => _cargandoController.stream;

cargarProductos () async {
  final productos = await _productProvider.cargarProductos();
  _productosController.sink.add(productos);
}

agregarProducto (ProductoModel producto) async {
  
  _cargandoController.sink.add(true);
  await _productProvider.crearProducto(producto);
  _cargandoController.sink.add(false);
}

Future<String> subirFoto (File foto) async {
  
  _cargandoController.sink.add(true);
    final fotoUrl = await _productProvider.subirImagen(foto);
  _cargandoController.sink.add(false);

return fotoUrl;

}

editarProducto (ProductoModel producto) async {
  
  _cargandoController.sink.add(true);
  await _productProvider.editarProducto(producto);
  _cargandoController.sink.add(false);
}

borrarProducto (String id) async {
  
  await _productProvider.borrarProducto(id);

}





dispose() {
  _productosController?.close();
  _cargandoController?.close();
}



}