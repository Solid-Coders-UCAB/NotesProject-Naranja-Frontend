# NotesProyect-Naranja-Frontend
NotesApp
<p align= "center">
  <img src= "https://github.com/Solid-Coders-UCAB/NotesProject-Naranja-Frontend/assets/129233285/c2f83f81-7640-4a27-a37d-beb827ef1fac" />
</p>

## Descripción
NoteApp es una aplicación de gestión de notas que te permite crear y organizar tus ideas de manera fácil y eficiente. Con NoteApp, puedes crear notas con texto, imágenes y esbozos a mano, y además, puedes utilizar el reconocimiento de voz a texto y el reconocimiento óptico de caracteres para transformar tus notas de audio o imágenes en texto.

También puedes agregar una lista de tareas en tus notas para mantenerte organizado y asegurarte de que no se te olvide nada importante. Además, puedes agregar la geolocalización donde fue creada la nota, lo que te permite recordar fácilmente dónde y cuándo tuviste una idea o inspiración.

NoteApp te permite organizar tus notas por carpetas, etiquetas y otras funcionalidades, para que puedas encontrar fácilmente lo que necesitas cuando lo necesites. Con NoteApp, nunca perderás una idea o inspiración importante, y podrás acceder a tus notas e ideas en cualquier momento y lugar.

## Instalación de las dependencias
```bash
# Limpiar las dependencias
$ flutter clean

# Instalar las dependencias
$ flutter pub get
```
## Instalación de la aplicación
Se ejecuta los siguientes comandos:
```bash
# Seleccionar dispositivo
$ Ctrl + Shift + P

# Seleccionar la opción preferida:
$ Flutter: Select Device
```
  Se selecciona el dispositivo al que se le va a instalar la aplicación
 ```bash
# Correr la aplicación
$ flutter run
```
## Actividades más significativas de cada integrante:
### Douglas Rojas
Actividades:
- Arquitectura inicial de la aplicación, con la distribución en carpetas.
- Implemetación de la geolocalización
- Implementación del editor de texto
- Implementación de "Imagen a Texto" (OCR)
- Implementación de agregar etiquetas en una nota
- Desarrollo de la vista de la papelera de notas
- Conexión del FrontEnd con el BackEnd

### Mayra Ramírez
Actividades:
- Implementación de la funcionalidad de esbozado
- Implementación de la barra de búqueda. Búsqueda por palabras claves
- Desarrollo de la lista tareas en una nota
- Desarrollo de vista de crear etiqueta
- Desarrollo de vista de editar etiqueta
- Desarrollo de vista de carpetas
- Desarrollo de vista de crear carpeta
- Desarrollo de vista de editar carpeta

### Jian Liu
Actividades:
- Implementación de la funcionalidad de "voz a texto"
- Desarrollo de vista de registro de usuario
- Desarrollo de vista de inicio de sesión
- Conexión de Flutter con Firebase
- Implementación de las notificaciones push con Firebase
- Implementación de la librería Geolocator para la geolocalización
- Desarrollo de la vista de perfil de usuario

## Librerías usadas:
- [flutter_image_compress 2.0.3](https://pub.dev/packages/flutter_image_compress)
- [flutter_map 5.0.0](https://pub.dev/packages/flutter_map)
- [flutter_tags_x](https://pub.dev/packages/flutter_tags_x)
- [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi)
- [sqflite](https://pub.dev/packages/sqflite)
- [html 0.15.4](https://pub.dev/packages/html/versions)
- [html_editor_enhanced 2.5.1](https://pub.dev/packages/html_editor_enhanced)
- [internet_connection_checker 1.0.0+1](https://pub.dev/packages/internet_connection_checker)
- [http](https://pub.dev/packages/http)
- [either_dart](https://pub.dev/packages/either_dart)
- [image_picker 0.8.1](https://pub.dev/packages/image_picker)
- [google_ml_kit 0.11.0](https://pub.dev/packages/google_ml_kit/versions/0.11.0)
- [screenshot 2.1.0](https://pub.dev/packages/screenshot)
- [path_provider 2.0.15](https://pub.dev/packages/path_provider)
- [speech_to_text 6.1.1](https://pub.dev/packages/speech_to_text)
- [avatar_glow 2.0.2](https://pub.dev/packages/avatar_glow/changelog)
- [geolocator 9.0.2](https://pub.dev/packages/geolocator)
- [geocoding 2.1.0](https://pub.dev/packages/geocoding)
- [cupertino_icons 1.0.2](https://pub.dev/packages/cupertino_icons/versions/1.0.2/changelog)
- [latlong2 0.9.0](https://pub.dev/packages/latlong2)
- [firebase_core 2.15.0](https://pub.dev/packages/firebase_core)
- [firebase_messaging 14.6.5](https://pub.dev/packages/firebase_messaging)
- [flutter_launcher_icons 0.13.1](https://pub.dev/packages/flutter_launcher_icons)
