import 'package:FlutterNews/repository/notice_repository/model/notice.dart';
import 'package:FlutterNews/repository/notice_repository/notice_repository.dart';
import 'package:FlutterNews/support/conection/api.dart';
import 'package:cubes/cubes.dart';

class SearchCube extends Cube {
  final NoticeRepository repository;

  SearchCube(this.repository);

  final progress = ObservableValue<bool>(value: false);
  final error = ObservableValue<bool>(value: false);
  final empty = ObservableValue<bool>(value: false);
  final newsList = ObservableList<Notice>(value: []);

  @override
  void ready() {
    search(data);
    super.ready();
  }

  void search(String query) {
    progress.value = true;
    error.value = false;

    repository
        .loadSearch(query)
        .then((news) => _showNews(news))
        .catchError(_showImplError);
  }

  _showNews(List<Notice> news) {
    progress.value = false;
    if (news.length > 0) {
      newsList.addAll(news);
      empty.value = false;
    } else {
      empty.value = true;
    }
  }

  _showImplError(onError) {
    print(onError);
    if (onError is FetchDataException) {
      print("codigo: ${onError.code()}");
    }
    error.value = true;
    progress.value = false;
  }
}
