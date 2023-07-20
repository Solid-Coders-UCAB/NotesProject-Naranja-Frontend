import 'package:firstapp/application/createNoteInServerService.dart';
import 'package:firstapp/application/createUserService.dart';
import 'package:firstapp/application/deleteNoteFromServerService.dart';
import 'package:firstapp/application/getAllFoldersFromServerService.dart';
import 'package:firstapp/application/getAllTagsFromNote.dart';
import 'package:firstapp/application/getImageFromCameraService.dart';
import 'package:firstapp/application/getImageFromGalleryService.dart';
import 'package:firstapp/application/getUserByIdServide.dart';
import 'package:firstapp/application/getUserCurrentLocation.dart';
import 'package:firstapp/application/imageToTextService.dart';
import 'package:firstapp/application/iniciarSesionService.dart';
import 'package:firstapp/application/offlineDecorator.dart';
import 'package:firstapp/application/updateFolderInServerService.dart';
import 'package:firstapp/application/updateNoteInServerService.dart';
import 'package:firstapp/application/updateUserInServerService.dart';
import 'package:firstapp/application/widgetToImageService.dart';
import 'package:firstapp/infrastructure/controllers/drawingRoomController.dart';
import 'package:firstapp/infrastructure/controllers/editarUsuarioWidgetController.dart';
import 'package:firstapp/infrastructure/controllers/findUserByIdController.dart';
import 'package:firstapp/infrastructure/controllers/homeController.dart';
import 'package:firstapp/infrastructure/controllers/imageToTextWidgetController.dart';
import 'package:firstapp/infrastructure/controllers/notaNuevaWidgetController.dart';
import 'package:firstapp/infrastructure/controllers/editarNotaWidgetController.dart';
import 'package:firstapp/infrastructure/controllers/notePreviewController.dart';
import 'package:firstapp/infrastructure/controllers/registroController.dart';
import 'package:firstapp/infrastructure/implementations/getLocationImp.dart';
import 'package:firstapp/infrastructure/controllers/recycleBinHomeController.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPfolderRepository.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPnoteRepositoy.dart';
import 'package:firstapp/infrastructure/implementations/drawingRoomImp/screenshot_imp.dart';
import 'package:firstapp/infrastructure/implementations/connectionCheckerImp.dart';
import 'package:firstapp/infrastructure/implementations/imagePickerImp.dart';
import 'package:firstapp/infrastructure/implementations/imageToTextImp.dart';
import 'package:firstapp/infrastructure/implementations/imagePickerGalleryImp.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPuserRepository.dart';
import 'package:firstapp/infrastructure/implementations/repositories/localEtiquetaRepository.dart';
import 'package:firstapp/infrastructure/implementations/repositories/localFolderRepository.dart';
import 'package:firstapp/infrastructure/implementations/repositories/localUserRepository.dart';
import 'package:firstapp/infrastructure/implementations/repositories/localnoteRepository.dart';
import 'application/getAllEliminatedNotes.dart';
import 'application/getAllNotEliminatedNotesFromServerService.dart';
import 'application/sincronizacionService.dart';
import 'infrastructure/controllers/homeFolderController.dart';
import 'package:firstapp/application/createFolderInServerService.dart';
import 'package:firstapp/infrastructure/controllers/carpetaNuevaWidgetController.dart';
import 'package:firstapp/infrastructure/controllers/editarCarpetaWidgetController.dart';
import 'package:firstapp/infrastructure/controllers/homeEtiquetasController.dart';
import 'package:firstapp/application/getAllEtiquetasFromServerService.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPetiquetasRepository.dart';
import 'package:firstapp/infrastructure/controllers/etiquetaNuevaWidgetController.dart';
import 'package:firstapp/application/createEtiquetaInServerService.dart';
import 'package:firstapp/infrastructure/controllers/editarEtiquetaWidgetController.dart';
import 'package:firstapp/application/updateEtiquetaInServerService.dart';
import 'package:firstapp/application/deleteEtiquetaService.dart';
import 'package:firstapp/application/deleteCarpetaService.dart';
import 'package:firstapp/application/getNotesByFolderService.dart';
import 'package:firstapp/infrastructure/controllers/notasEnCarpetaController.dart';
import 'package:firstapp/application/getNotesByEtiquetaService.dart';
import 'package:firstapp/infrastructure/controllers/notasPorEtiquetaController.dart';
import 'package:firstapp/application/getNotesByKeywordService.dart';
import 'package:firstapp/infrastructure/controllers/notasPorPalabraClaveController.dart';

import 'infrastructure/controllers/iniciarSesionController.dart';

//fabrica de controladores

class controllerFactory {
  static imageToTextWidgetController imageToTextWidController() {
    imageToTextWidgetController imageToTextController =
        imageToTextWidgetController(
            getImageFromCamaraService(picker: imagePickerImp()),
            imageToTextService(ia: iaTextImp()));
    return imageToTextController;
  }

  static sincronizacionService createSincronizacionService(){
    return sincronizacionService(
    localNoteRepo: localNoteRepository(), serverNoteRepo: httpNoteRepository(), 
    localUserRepo: localUserRepository(),
    localfolderrepo: localFolderRepository(), serverFolderRepo: HTTPfolderRepository(),
    localEtiquetaRepo: localEtiquetaRepository(),serverEtiquetaRepo: HTTPetiquetasRepository(),
    checker: connectionCheckerImp());
  }

  static createNoteInServerService createNoInServerService() {
    var servicio = createNoteInServerService(
        noteRepo: httpNoteRepository(),
        folderRepo: HTTPfolderRepository(),
        localUserRepo: localUserRepository());
    return servicio;
  }

// Controlador de la ventana de crear nota
  static notaNuevaWidgetController notaNuevaWidController() {
    var servicio = createNoteInServerService(
        noteRepo: httpNoteRepository(),
        folderRepo: HTTPfolderRepository(),
        localUserRepo: localUserRepository());

    var offlineService = createNoteInServerService(
        noteRepo: localNoteRepository(),
        folderRepo: localFolderRepository(),
        localUserRepo: localUserRepository());

    var offlineDeco = offlineDecorator(
        servicio: servicio,
        offlineService: offlineService,
        checker: connectionCheckerImp());

    return notaNuevaWidgetController(
        imageToText: imageToTextService(ia: iaTextImp()),
        imageService: getImageFromCamaraService(picker: imagePickerImp()),
        galleryService:
            getImageFromGalleryService(picker: imagePickerGalleryImp()),
        createNotaService: offlineDeco,
        locationService: GetUserCurrentLocationService(loca: GetLocationImp()),
        getAllEtiquetasService: getAllEtiquetasFromServerService(
            etiquetaRepo: HTTPetiquetasRepository(),
            localUserRepo: localUserRepository()),
        getAllFoldersService: getAllFoldersFromServerService(
            folderRepo: HTTPfolderRepository(),
            localUserRepo: localUserRepository()));
  }

// Controlador para el widget de esbozado DrawingRoom
  static DrawingRoomController createDrawingRoomController() {
    return DrawingRoomController(
        imageService: WidgetToImageService(converter: ScreenshotImp()));
  }

  static homeController createHomeController() {
    var onlineService = getAllNotEliminatedNotesFromServerService(
        noteRepo: httpNoteRepository(), localUserRepo: localUserRepository());
    var localService = getAllNotEliminatedNotesFromServerService(
        noteRepo: localNoteRepository(), localUserRepo: localUserRepository());
    var offlineDeco = offlineDecorator(
        servicio: onlineService,
        offlineService: localService,
        checker: connectionCheckerImp());

    return homeController(getAllNotesFromServerService: offlineDeco);
  }

  static editarNotaWidgetController editarNotaWidController() {
    return editarNotaWidgetController(
        imageToText: imageToTextService(ia: iaTextImp()),
        imageService: getImageFromCamaraService(picker: imagePickerImp()),
        galleryService:
            getImageFromGalleryService(picker: imagePickerGalleryImp()),
        updateNotaService:
            updateNoteInServerService(noteRepo: httpNoteRepository()),
        getAllEtiquetasService: getAllEtiquetasFromServerService(
            etiquetaRepo: HTTPetiquetasRepository(),
            localUserRepo: localUserRepository()),
        getAllFoldersService: getAllFoldersFromServerService(
            folderRepo: HTTPfolderRepository(),
            localUserRepo: localUserRepository()));
  }

  static homeFolderController homefolderController() {
    var onlineService = getAllFoldersFromServerService(
            folderRepo: HTTPfolderRepository(),
            localUserRepo: localUserRepository());

    var localService = getAllFoldersFromServerService(
        folderRepo: localFolderRepository(), localUserRepo: localUserRepository());

    var offlineDeco = offlineDecorator(
        servicio: onlineService,
        offlineService: localService,
        checker: connectionCheckerImp());

    return homeFolderController(
        getAllFoldersService: offlineDeco);
  }

// Controlador de la ventana crear carpeta
  static carpetaNuevaWidgetController createCarpetaNuevaWidgetController() {
    var servicio = createFolderInServerService(
            folderRepo: HTTPfolderRepository(),
            localUserRepo: localUserRepository());

    var offlineService = createFolderInServerService(
        folderRepo: localFolderRepository(),
        localUserRepo: localUserRepository());

    var offlineDeco = offlineDecorator(
        servicio: servicio,
        offlineService: offlineService,
        checker: connectionCheckerImp());

    return carpetaNuevaWidgetController(
        createCarpetaService: offlineDeco
        );
  }

  static editarCarpetaWidgetController createEditarCarpetaWidgetController() {
    return editarCarpetaWidgetController(
        updateCarpetaService: updateFolderInServerService(
            folderRepo: HTTPfolderRepository(),
            localUserRepo: localUserRepository()),
        deleteCarpetaService: deleteCarpetaInServerService(
            folderRepo: HTTPfolderRepository(),
            localUserRepo: localUserRepository()));
  }

  static recycleBinHomeController recycleBinhomeController() {
    return recycleBinHomeController(
        getAllEliminatedNotesFromServerService:
            getAllEliminatedNotesFromServerService(
                noteRepo: httpNoteRepository(),
                localUserRepo: localUserRepository()),
        deleteNoteFromServerService:
            deleteNoteFromServerService(noteRepo: httpNoteRepository()),
        updateNoteFromServer:
            updateNoteInServerService(noteRepo: httpNoteRepository()));
  }

  static homeEtiquetasController createHomeEtiquetasController() {

    var onlineService = getAllEtiquetasFromServerService(
            etiquetaRepo: HTTPetiquetasRepository(),
            localUserRepo: localUserRepository());
    var offlineService = getAllEtiquetasFromServerService(
            etiquetaRepo: localEtiquetaRepository(),
            localUserRepo: localUserRepository());
    var offlineDeco = offlineDecorator(servicio: onlineService, offlineService: offlineService, checker: connectionCheckerImp());                      

    return homeEtiquetasController(
        getAllEtiquetasService: offlineDeco);
  }

  static etiquetaNuevaWidgetController createEtiquetaNuevaWidgetController() {

    var onlineService = createEtiquetaInServerService(
            etiquetaRepo: HTTPetiquetasRepository(),
            localUserRepo: localUserRepository());
    var offlineService = createEtiquetaInServerService(etiquetaRepo: localEtiquetaRepository(), localUserRepo: localUserRepository());
    var offlineDeco = offlineDecorator(servicio: onlineService, offlineService: offlineService, checker: connectionCheckerImp());

    return etiquetaNuevaWidgetController(
        createEtiquetaService: offlineDeco  );
  }

  static editarEtiquetaWidgetController createEditarEtiquetaWidgetController() {
    return editarEtiquetaWidgetController(
        updateEtiquetaService: updateEtiquetaInServerService(
            etiquetaRepo: HTTPetiquetasRepository(),
            localUserRepo: localUserRepository()),
        deleteEtiquetaService: deleteEtiquetaInServerService(
            etiquetaRepo: HTTPetiquetasRepository(),
            localUserRepo: localUserRepository()));
  }

  static notePreviewController createNotePreviewController() {
    return notePreviewController(
        getAllTagsFromNote:
            getAllTagsFromNoteService(tagRepo: HTTPetiquetasRepository()));
  }

  static notasEnCarpetaController createnotasEnCarpetaController() {
    return notasEnCarpetaController(
        notesByFolderService: getNotesByFolderService(
            folderRepo: HTTPfolderRepository(),
            localUserRepo: localUserRepository()));
  }

  static notasPorEtiquetaController createnotasPorEtiquetaController() {
    return notasPorEtiquetaController(
        notesByEtiquetaService: getNotesByEtiquetaService(
            etiquetaRepo: HTTPetiquetasRepository(),
            localUserRepo: localUserRepository()));
  }

  static notasPorPalabraClaveController createnotasPorPalabraClaveController() {
    return notasPorPalabraClaveController(
        notesByKeywordService: getNotesByKeywordService(
            noteRepo: httpNoteRepository(),
            localUserRepo: localUserRepository()));
  }

  static iniciarSesionController createIniciarSesionController() {
    return iniciarSesionController(
        localUserRepo: localUserRepository(),
        iniciarSesionService: iniciarSesionService(
            localRepo: localUserRepository(), httpRepo: httpUserRepository()));
  }

  static registroController createRegistroController() {
    return registroController(
        createUserService: createUserService(
            serverRepo: httpUserRepository(),
            localRepo: localUserRepository()));
  }

  static findUserByIdController createfindUserByIdController() {
    return findUserByIdController(
        getUserByIDService: getUserByIdInServerService(
            userRepo: httpUserRepository(),
            localUserRepo: localUserRepository()));
  }

  static editarUsuarioWidgetController createEditarUsuarioWidgetController() {
    return editarUsuarioWidgetController(
        updateUsuarioService: updateUserInServerService(
            userRepo: httpUserRepository(),
            localUserRepo: localUserRepository()));
  }
}
