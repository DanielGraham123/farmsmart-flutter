import 'package:farmsmart_flutter/model/bloc/Transformer.dart';
import 'package:farmsmart_flutter/model/bloc/ViewModelProvider.dart';
import 'package:farmsmart_flutter/model/model/loading_status.dart';
import 'package:farmsmart_flutter/ui/common/ErrorRetry.dart';
import 'package:farmsmart_flutter/ui/common/RefreshableViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'LoadableViewModel.dart';

class _Strings {
  static String loadingError = "Oops, there was a problem!";
  static String retryAction = "Retry";
}

typedef WidgetBuilder<T> = Widget Function({BuildContext context, AsyncSnapshot<T> snapshot});

class ViewModelProviderBuilder<T> extends StatelessWidget {
  final ViewModelProvider<T> _provider;
  final WidgetBuilder<T> _successBuilder;
  final WidgetBuilder<T> _errorBuilder;
  final WidgetBuilder<T> _loadingBuilder;

  const ViewModelProviderBuilder(
      {Key key,
      ViewModelProvider<T> provider,
      WidgetBuilder<T> successBuilder,
      WidgetBuilder<T> errorBuilder,
      WidgetBuilder<T> loadingBuilder})
      : this._provider = provider,
        this._successBuilder = successBuilder,
        this._errorBuilder = errorBuilder,
        this._loadingBuilder = loadingBuilder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorBuilder = _errorBuilder ?? _defaultErrorBuilder;
    final loadingBuilder = _loadingBuilder ?? _defaultLoadingBuilder;

    return StreamBuilder<T>(
        stream: _provider.observe().stream,
        initialData: _provider.initial(),
        builder: (
          BuildContext context,
          AsyncSnapshot<T> snapshot,
        ) {
          LoadingStatus status = (snapshot.error != null)
              ? LoadingStatus.ERROR
              : LoadingStatus.SUCCESS;
          final loadable = castOrNull<LoadableViewModel>(snapshot.data );
          if (loadable != null) {
            status = loadable.loadingStatus;
          }
          switch (status) {
            case LoadingStatus.ERROR:
              return errorBuilder(context, snapshot);
              break;
            case LoadingStatus.LOADING:
              return loadingBuilder(context, snapshot);
              break;
            default:
              return _successBuilder(context: context, snapshot: snapshot);
          }
        });
  }

  Widget _defaultLoadingBuilder(BuildContext context, AsyncSnapshot<T> snapshot) {
    return Container(
            child: CircularProgressIndicator(), alignment: Alignment.center,);
  }

  Widget _defaultErrorBuilder(BuildContext context, AsyncSnapshot<T> snapshot) {
    final refreshable = castOrNull<RefreshableViewModel>(snapshot.data);
    final Function refreshFunction = (refreshable!=null) ? refreshable.refresh : null;
    return ErrorRetry(
      errorMessage: Intl.message(_Strings.loadingError),
      retryActionLabel: Intl.message(_Strings.retryAction),
      retryFunction: refreshFunction ,
    );
  }
}
