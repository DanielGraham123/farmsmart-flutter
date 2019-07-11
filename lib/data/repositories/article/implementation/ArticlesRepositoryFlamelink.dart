import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsmart_flutter/data/model/EntityCollectionInterface.dart';
import 'package:farmsmart_flutter/data/model/article_entity.dart';
import 'package:farmsmart_flutter/data/model/entities_const.dart';
import '../../../firebase_const.dart';
import '../../FlameLink.dart';
import 'package:farmsmart_flutter/model/enums.dart';
import '../ArticleRepositoryInterface.dart';
import 'transformers/FirebaseArticleTransformer.dart';


ArticleEntity _transform(FlameLink cms, DocumentSnapshot snapshot) {
  final transformer = FlamelinkArticleTransformer(cms: cms);
  return transformer.transform(from: snapshot);
}

class ArticleEntityCollectionFlamelink implements EntityCollection<ArticleEntity> {
  final FlamelinkDocumentCollection _collection;
  final bool _onlyPublished;

  ArticleEntityCollectionFlamelink({FlamelinkDocumentCollection collection, bool onlyPublished = true})
      : _collection = collection, _onlyPublished = onlyPublished;

  @override
  Future<List<ArticleEntity>> getEntities({int limit = 0}) {
    return _collection.getDocuments().then((documents) { 
      var articles =  documents.map((document) => _transform(_collection.cms, document)).toList(); 
      if(_onlyPublished) {
          articles.removeWhere((article) { return article.status != Status.PUBLISHED;});
      }
      return articles;
      });
  }
}

class ArticlesRepositoryFlameLink implements ArticleRepositoryInterface {
  final FlameLink _cms;
  static final _articleSchema = "article";
  static final _articleDirectoryName = "articleDirectory";


  ArticlesRepositoryFlameLink(FlameLink cms) : _cms = cms;

  @override
  Future<ArticleEntity> getArticle(uri) {
    if (uri.isEmpty) {
      return null;
    }
    final baseCollection = _cms.content();
    return baseCollection
        .document(uri)
        .get()
        .then((snapshot) => _transform(_cms, snapshot));
  }

  @override
  Stream<ArticleEntity> observeArticle(uri) {
    if (uri.isEmpty) {
      return null;
    }
    final baseCollection = _cms.content();
    final _typeTransform =
        StreamTransformer<DocumentSnapshot, ArticleEntity>.fromHandlers(
            handleData: (snapshot, sink) {
      sink.add(_transform(_cms, snapshot));
    });
    return baseCollection.document(uri).snapshots().transform(_typeTransform);
  }

  @override
  Future<List<ArticleEntity>> getArticles(EntityCollection<ArticleEntity> collection) {
    return collection.getEntities();
  }

  @override
  Future<List<ArticleEntity>> get(
      {ArticleCollectionGroup group = ArticleCollectionGroup.all,
      int limit = 0}) {
    //NB: for now there is only one  group (all articles)

    switch (group) {
      case ArticleCollectionGroup.discovery:
        return getDirectory(directoryName: _articleDirectoryName);
        break;
      default:
        final publishedDocuments = _cms
            .documentsQuery(schema: _articleSchema, limit: limit)
            .where(PUBLICATION_STATUS, isEqualTo: DataStatus.PUBLISHED);
        final collection = FlamelinkDocumentCollection(cms: _cms, query: publishedDocuments);
        return ArticleEntityCollectionFlamelink(collection: collection)
            .getEntities();
    }
  }

  Future<List<ArticleEntity>> getDirectory({String directoryName}) {
    return _cms.getSingle(schema: directoryName).then((snapshot) {
      final refs = snapshot.data[ARTICLES]
          .map((article) => article[ARTICLE].path.toString())
          .toList();
      final paths = List<String>.from(refs);
      final collection = FlamelinkDocumentCollection.list(cms: _cms, paths: paths);
      return ArticleEntityCollectionFlamelink(collection: collection).getEntities();
    });
  }
}