import 'package:firstapp/application/connectionCheckerDecorator.dart';
import 'package:firstapp/application/createNoteInServerService.dart';
import 'package:firstapp/application/getAllFoldersFromServerService.dart';
import 'package:firstapp/application/getImageFromCameraService.dart';
import 'package:firstapp/application/getImageFromGalleryService.dart';
import 'package:firstapp/application/getUserCurrentLocation.dart';
import 'package:firstapp/application/imageToTextService.dart';
import 'package:firstapp/application/updateFolderInServerService.dart';
import 'package:firstapp/application/updateNoteInServerService.dart';
import 'package:firstapp/application/widgetToImageService.dart';
import 'package:firstapp/infrastructure/controllers/drawingRoomController.dart';
import 'package:firstapp/infrastructure/controllers/homeController.dart';
import 'package:firstapp/infrastructure/controllers/imageToTextWidgetController.dart';
import 'package:firstapp/infrastructure/controllers/notaNuevaWidgetController.dart';
import 'package:firstapp/infrastructure/controllers/editarNotaWidgetController.dart';
import 'package:firstapp/infrastructure/implementations/getLocationImp.dart';
import 'package:firstapp/infrastructure/controllers/recycleBinHomeController.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPfolderRepository.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPnoteRepositoy.dart';
import 'package:firstapp/infrastructure/implementations/drawingRoomImp/screenshot_imp.dart';
import 'package:firstapp/infrastructure/implementations/connectionCheckerImp.dart';
import 'package:firstapp/infrastructure/implementations/imagePickerImp.dart';
import 'package:firstapp/infrastructure/implementations/imageToTextImp.dart';
import 'package:firstapp/infrastructure/implementations/imagePickerGalleryImp.dart';
import 'application/getAllEliminatedNotes.dart';
import 'application/getAllNotEliminatedNotesFromServerService.dart';
import 'infrastructure/controllers/homeFolderController.dart';
import 'package:firstapp/application/createFolderInServerService.dart';
import 'package:firstapp/infrastructure/controllers/carpetaNuevaWidgetController.dart';
import 'package:firstapp/infrastructure/controllers/editarCarpetaWidgetController.dart';

//fabrica de controladores

class controllerFactory {
  static imageToTextWidgetController imageToTextWidController() {
    imageToTextWidgetController imageToTextController =
        imageToTextWidgetController(
            getImageFromCamaraService(picker: imagePickerImp()),
            imageToTextService(ia: iaTextImp()));
    return imageToTextController;
  }

  static createNoteInServerService createNoInServerService() {
    return createNoteInServerService(noteRepo: httpNoteRepository());
  }

  static notaNuevaWidgetController notaNuevaWidController() {
    return notaNuevaWidgetController(
        imageToText: imageToTextService(ia: iaTextImp()),
        imageService: getImageFromCamaraService(picker: imagePickerImp()),
        galleryService:
            getImageFromGalleryService(picker: imagePickerGalleryImp()),
        createNotaService: 
                createNoteInServerService(noteRepo: httpNoteRepository()),
        locationService:
            GetUserCurrentLocationService(location: GetLocationImp()) );
  }

// Controlador para el widget de esbozado DrawingRoom
  static DrawingRoomController createDrawingRoomController() {
    return DrawingRoomController(
        imageService: WidgetToImageService(converter: ScreenshotImp()));
  }

  static homeController createHomeController() {
    return homeController(
        getAllNotesFromServerService: getAllNotEliminatedNotesFromServerService(
            noteRepo: httpNoteRepository()));
  }

  static editarNotaWidgetController editarNotaWidController() {
    return editarNotaWidgetController(
        imageToText: imageToTextService(ia: iaTextImp()),
        imageService: getImageFromCamaraService(picker: imagePickerImp()),
        galleryService:
            getImageFromGalleryService(picker: imagePickerGalleryImp()),
        updateNotaService:
            updateNoteInServerService(noteRepo: httpNoteRepository()));
  }

  static homeFolderController homefolderController() {
    return homeFolderController(
        getAllFoldersService:
            getAllFoldersFromServerService(folderRepo: HTTPfolderRepository()));
  }

  static carpetaNuevaWidgetController createCarpetaNuevaWidgetController() {
    return carpetaNuevaWidgetController(
        createCarpetaService:
            createFolderInServerService(folderRepo: HTTPfolderRepository()));
  }

  static editarCarpetaWidgetController createEditarCarpetaWidgetController() {
    return editarCarpetaWidgetController(
        updateCarpetaService:
            updateFolderInServerService(folderRepo: HTTPfolderRepository()));
  }

  static recycleBinHomeController recycleBinhomeController() {
    return recycleBinHomeController(
        getAllEliminatedNotesFromServerService:
            getAllEliminatedNotesFromServerService(
                noteRepo: httpNoteRepository()));
  }
}
