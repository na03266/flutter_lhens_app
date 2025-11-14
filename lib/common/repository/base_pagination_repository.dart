import 'package:lhens_app/common/model/page_pagination_params.dart';

import '../model/cursor_pagination_model.dart';
import '../model/model_with_id.dart';
import '../model/cursor_pagination_params.dart';
import '../model/page_pagination_model.dart';

abstract class IBaseCursorPaginationRepository<T extends IModelWithIdString> {
  Future<CursorPagination<T>> paginate({
    CursorPaginationParams? paginationParams = const CursorPaginationParams(),
  });
}

abstract class IBasePagePaginationRepository<T> {
  Future<PagePagination<T>> paginate({
    PagePaginationParams? paginationParams = const PagePaginationParams(),
  });
}
