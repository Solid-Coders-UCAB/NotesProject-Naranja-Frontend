import 'package:firstapp/application/connectionCheckerDecorator.dart';
import 'package:firstapp/application/createNoteInServerService.dart';
import 'package:firstapp/application/deleteNoteFromServerService.dart';
import 'package:firstapp/application/getAllFoldersFromServerService.dart';
import 'package:firstapp/application/getAllTagsFromNote.dart';
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
import 'package:firstapp/infrastructure/controllers/notePreviewController.dart';
import 'package:firstapp/infrastructure/implementations/getLocationImp.dart';
import 'package:firstapp/infrastructure/controllers/recycleBinHomeController.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPfolderRepository.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPnoteRepositoy.dart';
import 'package:firstapp/infrastructure/implementations/drawingRoomImp/screenshot_imp.dart';
import 'package:firstapp/infrastructure/implementations/connectionCheckerImp.dart';
import 'package:firstapp/infrastructure/implementations/imagePickerImp.dart';
import 'package:firstapp/infrastructure/implementations/imageToTextImp.dart';
import 'package:firstapp/infrastructure/implementations/imagePickerGalleryImp.dart';
import 'package:firstapp/infrastructure/implementations/repositories/localUserRepository.dart';
import 'application/getAllEliminatedNotes.dart';
import 'application/getAllNotEliminatedNotesFromServerService.dart';
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
    return createNoteInServerService(noteRepo: httpNoteRepository(),
                                     folderRepo: HTTPfolderRepository(),
                                     localUserRepo: localUserRepository());
  }

  static notaNuevaWidgetController notaNuevaWidController() {
    return notaNuevaWidgetController(
        imageToText: imageToTextService(ia: iaTextImp()),
        imageService: getImageFromCamaraService(picker: imagePickerImp()),
        galleryService:
            getImageFromGalleryService(picker: imagePickerGalleryImp()),
        createNotaService: 
                createNoteInServerService(noteRepo: httpNoteRepository(),
                                          folderRepo: HTTPfolderRepository(),
                                           localUserRepo: localUserRepository()),
        locationService:
            GetUserCurrentLocationService(loca: GetLocationImp()),
        getAllEtiquetasService: 
            getAllEtiquetasFromServerService(etiquetaRepo: HTTPetiquetasRepository(), localUserRepo: localUserRepository()),
         getAllFoldersService: 
            getAllFoldersFromServerService(folderRepo: HTTPfolderRepository(), localUserRepo: localUserRepository())    );
  }

// Controlador para el widget de esbozado DrawingRoom
  static DrawingRoomController createDrawingRoomController() {
    return DrawingRoomController(
        imageService: WidgetToImageService(converter: ScreenshotImp()));
  }

  static homeController createHomeController() {
    return homeController(
        getAllNotesFromServerService: getAllNotEliminatedNotesFromServerService(
            noteRepo: httpNoteRepository(),
            localUserRepo: localUserRepository()));
  }

  static editarNotaWidgetController editarNotaWidController() {
    return editarNotaWidgetController(
        imageToText: imageToTextService(ia: iaTextImp()),
        imageService: getImageFromCamaraService(picker: imagePickerImp()),
        galleryService:
            getImageFromGalleryService(picker: imagePickerGalleryImp()),
        updateNotaService:
            updateNoteInServerService(noteRepo: httpNoteRepository()),
        getAllEtiquetasService: 
            getAllEtiquetasFromServerService(etiquetaRepo: HTTPetiquetasRepository(), 
                                             localUserRepo: localUserRepository()),
        getAllFoldersService: 
            getAllFoldersFromServerService(folderRepo: HTTPfolderRepository(), localUserRepo: localUserRepository())
        
        );
  }

  static homeFolderController homefolderController() {
    return homeFolderController(
        getAllFoldersService:
            getAllFoldersFromServerService(folderRepo: HTTPfolderRepository(),
                                          localUserRepo: localUserRepository()));
  }

  static carpetaNuevaWidgetController createCarpetaNuevaWidgetController() {
    return carpetaNuevaWidgetController(
        createCarpetaService:
            createFolderInServerService(folderRepo: HTTPfolderRepository(),
                                        localUserRepo: localUserRepository()));
  }

  static editarCarpetaWidgetController createEditarCarpetaWidgetController() {
    return editarCarpetaWidgetController(
            updateCarpetaService:
            updateFolderInServerService(folderRepo: HTTPfolderRepository(),
                                        localUserRepo: localUserRepository()),
            deleteCarpetaService: deleteCarpetaInServerService(folderRepo: HTTPfolderRepository(), 
                                                              localUserRepo: localUserRepository())
        );
  }

  static recycleBinHomeController recycleBinhomeController() {
    return recycleBinHomeController(
        getAllEliminatedNotesFromServerService:
            getAllEliminatedNotesFromServerService(
                noteRepo: httpNoteRepository(),
                localUserRepo: localUserRepository()),
        deleteNoteFromServerService: 
                deleteNoteFromServerService(
                  noteRepo: httpNoteRepository()),
        updateNoteFromServer: 
                updateNoteInServerService(noteRepo: httpNoteRepository())          
        );
  }

   static homeEtiquetasController createHomeEtiquetasController() {
    return homeEtiquetasController(
            getAllEtiquetasService: getAllEtiquetasFromServerService(etiquetaRepo: HTTPetiquetasRepository(),
                                                                    localUserRepo: localUserRepository()));
  }

    static etiquetaNuevaWidgetController createEtiquetaNuevaWidgetController() {
    return etiquetaNuevaWidgetController(
        createEtiquetaService:
            createEtiquetaInServerService(etiquetaRepo: HTTPetiquetasRepository(),
                                        localUserRepo: localUserRepository())
        );
  }

    static editarEtiquetaWidgetController createEditarEtiquetaWidgetController() {
    return editarEtiquetaWidgetController(
            updateEtiquetaService:
            updateEtiquetaInServerService(etiquetaRepo: HTTPetiquetasRepository(),
                                        localUserRepo: localUserRepository()),
            deleteEtiquetaService: deleteEtiquetaInServerService(etiquetaRepo: HTTPetiquetasRepository(), 
                                                                localUserRepo: localUserRepository())
          );
   }

   static notePreviewController createNotePreviewController(){
    return notePreviewController(getAllTagsFromNote: 
                                    getAllTagsFromNoteService(tagRepo: HTTPetiquetasRepository())
                                );
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
}
