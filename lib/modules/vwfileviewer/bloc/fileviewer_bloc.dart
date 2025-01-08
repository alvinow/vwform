import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:matrixclient/appconfig.dart';
import 'package:matrixclient/modules/base/vwfilestorage/modules/vwfileencryption/vwfileencryption.dart';
import 'package:matrixclient/modules/base/vwfilestorage/vwfilestorage.dart';
import 'package:matrixclient/modules/util/cryptoutil.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter/foundation.dart' show kIsWeb;
part 'fileviewer_state.dart';
part 'fileviewer_event.dart';

class FileviewerBloc extends Bloc<FileviewerEvent, FileviewerState> {
  VwFileStorage fileStorage;
  Key key;


  FileviewerBloc({required this.key, required this.fileStorage})
      : super(BootupFileviewerState()) {
    on<BootstrapFileviewerEvent>(this._onBootstrapFileviewerEvent);
    on<LoadFileviewerEvent>(this._onLoadFileviewerEvent);
  }

  String? encryptedBase64;
  VwFileEncryption? fileEncryptionInfo;

  String? _getUrl() {
    String? returnValue;

    if (this.fileStorage.availableOnServer == true) {
      if (this.fileStorage.url != null) {
        returnValue = this.fileStorage.url;
      } else {
        returnValue = AppConfig.baseUrl +
            AppConfig.filesUrlPath +
            "/" +
            this.fileStorage.recordId;
      }
    }

    return returnValue;
  }

  void _onBootstrapFileviewerEvent(
      BootstrapFileviewerEvent event, Emitter<FileviewerState> emit) async {
    emit(LoadingFileviewerState());
    this.add(LoadFileviewerEvent(timestamp: DateTime.now()));
  }

  Future<Uint8List> _decryptWithoutIsolateLogic() async {
    Uint8List returnValue=Uint8List(0);
    try
    {

      if(this.encryptedBase64!=null && this.fileEncryptionInfo!=null) {
        returnValue =
            await CryptoUtil.decryptByVwFileEncryptionInfo(
                fileBase64: this.encryptedBase64!,
                fileEncryptionInfo: this.fileEncryptionInfo!)!;
      }
    }
    catch(error)
    {
      returnValue=Uint8List(0);
    }
    return returnValue;
  }

  void _onLoadFileviewerEvent(
      LoadFileviewerEvent event, Emitter<FileviewerState> emit) async {
    emit(LoadingFileviewerState());
    await Future.delayed(const Duration(seconds: 1));
    try {
      if (this.fileStorage.availableOnServer == true) {
        String? url = _getUrl();

        if (url != null) {
          if (this.fileStorage.isEncrypted == true &&
              this.fileStorage.fileEncryption != null) {
            if (this.fileStorage.fileEncryption!.encryptionMethod ==
                "aes-256-cbc") {
              final String? extension = p
                  .extension(
                      this.fileStorage.clientEncodedFile!.fileInfo.fileName)
                  .toLowerCase();

              if (extension == ".mp4" || extension == ".mp3") {
                if (kIsWeb == false) {
                  File file = await DefaultCacheManager().getSingleFile(url);


                  String fileBase64 =  await file.readAsString();

                  Uint8List? decryptedUint8List;

                  if (this.fileStorage.fileEncryption != null) {
                    decryptedUint8List =
                        await CryptoUtil.decryptByVwFileEncryptionInfo(
                            fileBase64: fileBase64,
                            fileEncryptionInfo:
                                this.fileStorage.fileEncryption!);
                  }

                  if (decryptedUint8List != null) {
                    final appDir = await syspaths.getTemporaryDirectory();

                    final String unencryptedFilename =
                        '${appDir.path}/${this.fileStorage.recordId}${extension}';

                    File fileCacheUnencrypted = File(unencryptedFilename);
                    await fileCacheUnencrypted.writeAsBytes(decryptedUint8List,
                        mode: FileMode.write);

                    emit(DisplayContentInFileFileviewerState(
                        fileLink: fileCacheUnencrypted,
                        fileStorage: this.fileStorage,
                        metadata: {}));
                    return;
                  }

                  /*
                  final keyAES =
                  encryption.Key.fromBase64(this.fileStorage.fileEncryption!.encryptionKey);
                  final iv =
                  encryption.IV.fromBase64(this.fileStorage.fileEncryption!.encryptionIV!);

                  final encrypter = encryption.Encrypter(encryption.AES(keyAES, mode: encryption.AESMode.cbc));

                  final String decryptedBase64 =
                  encrypter.decrypt64(fileBase64, iv: iv);

                  final Uint8List decryptedUint8List = base64Decode(decryptedBase64);
                  */
                } else {
                  emit(DisplayContentInYoutubeVideoIdFileviewerState(
                      videoIds: ["qsYdVF8IIyk", "6JftaLbDkTc"]));
                }
              } else {
                File file = await DefaultCacheManager().getSingleFile(url);
                String fileBase64 =  await file.readAsString();

                Uint8List decryptedUint8List=Uint8List(0);

                if (this.fileStorage.fileEncryption != null) {

                  /*
                  encryptedBase64=fileBase64;
                  fileEncryptionInfo=this.fileStorage.fileEncryption!;

                  final Uint8List decrypted=await Isolate.run(_decryptWithoutIsolateLogic);
                  decryptedUint8List=decrypted;
                  encryptedBase64=null;
                  fileEncryptionInfo=null;

                   */


                  decryptedUint8List =await CryptoUtil.decryptByVwFileEncryptionInfo(
                          fileBase64: fileBase64,
                          fileEncryptionInfo: this.fileStorage.fileEncryption!);
                }
                else{
                  decryptedUint8List=file.readAsBytesSync();
                }

                if (decryptedUint8List != null && decryptedUint8List.length>0) {
                  emit(DisplayContentInMemoryFileviewerState(
                      fileInMemory: decryptedUint8List,
                      fileStorage: this.fileStorage,
                      metadata: {}));
                  return;
                }

                /*
                final keyAES =
                encryption.Key.fromBase64(this.fileStorage.fileEncryption!.encryptionKey);
                final iv =
                encryption.IV.fromBase64(this.fileStorage.fileEncryption!.encryptionIV!);

                final encrypter = encryption.Encrypter(encryption.AES(keyAES, mode: encryption.AESMode.cbc));

                final String decryptedBase64 =encrypter.decrypt64(fileBase64, iv: iv);

                final Uint8List decryptedUint8List = base64Decode(decryptedBase64);

                 */
              }
            }
          } else {
            File file = await DefaultCacheManager().getSingleFile(url);
            if (file != null) {
              emit(DisplayContentInFileFileviewerState(
                  fileLink: file, fileStorage: this.fileStorage, metadata: {}));
              return;
            }
          }
        } else {
          emit(LoadFailedFileviewerState());
          return;
        }
      } else if (this.fileStorage.availableOnClientEncodedFile == true &&
          this.fileStorage.clientEncodedFile != null &&
          this.fileStorage.clientEncodedFile!.fileDataEncodedBase64 != null) {
        emit(DisplayContentInMemoryFileviewerState(
            fileInMemory: base64Decode(
                this.fileStorage.clientEncodedFile!.fileDataEncodedBase64!),
            fileStorage: this.fileStorage,
            metadata: {}));
        return;
      } else if (this.fileStorage.availableOnClientStorage == true) {
        File file = File(this.fileStorage.clientEncodedFile!.fileSource.path +
            "/" +
            this.fileStorage.clientEncodedFile!.fileSource.filename);
        emit(DisplayContentInFileFileviewerState(
            fileLink: file, fileStorage: this.fileStorage, metadata: {}));
        return;
      }
    } catch (error) {
      print("error on OnLoadFileViewer Event : " + error.toString());
    }
    emit(LoadFailedFileviewerState());
  }
}
