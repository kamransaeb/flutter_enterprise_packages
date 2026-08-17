import 'dart:async';

import 'package:client_app_example/di/injection.dart';
import 'package:client_app_example/errors/error_mapper.dart';
import 'package:client_app_example/features/posts/domain/entities/post.dart';
import 'package:client_app_example/features/posts/domain/usecases/get_post_usecase.dart';
import 'package:client_app_example/features/posts/domain/usecases/get_posts_usecase.dart';
import 'package:enterprise_core/enterprise_core.dart';
import 'package:enterprise_ui/enterprise_ui.dart';
import 'package:flutter/material.dart';

/// A page that displays a list of posts.
class PostsDemoPage extends StatefulWidget {
  /// Creates a [PostsDemoPage].
  const PostsDemoPage({super.key});

  @override
  State<PostsDemoPage> createState() => _PostsDemoPageState();
}

class _PostsDemoPageState extends State<PostsDemoPage> {
  bool _loading = false;
  Post? _post;
  List<Post> _posts = const [];
  Failure? _failure;

  @override
  void initState() {
    super.initState();
    unawaited(_loadPost());
  }

  Future<void> _loadPost({bool forceRefresh = false}) async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _failure = null;
    });

    final result = await getIt<GetPostUseCase>()(
      GetPostParams(id: 1, forceRefresh: forceRefresh),
    );

    if (!mounted) return;
    setState(() => _loading = false);

    result.fold(
      (failure) {
        setState(() => _failure = failure);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (post) {
        setState(() {
          _failure = null;
          _post = post;
        });
      },
    );
  }

  Future<void> _loadPosts() async {
    setState(() {
      _loading = true;
      _failure = null;
    });

    final result = await getIt<GetPostsUseCase>()(const GetPostsParams());

    if (!mounted) return;
    setState(() => _loading = false);

    result.fold(
      (failure) {
        setState(() => _failure = failure);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorMapper.toUserMessage(failure))),
        );
      },
      (posts) {
        setState(() {
          _failure = null;
          _posts = posts;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts demo')),
      body: _buildBody(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppButton(
            label: 'Load post',
            icon: Icons.cloud_download,
            loading: _loading,
            onPressed: _loadPost,
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'Refresh',
            icon: Icons.refresh,
            variant: AppButtonVariant.tonal,
            loading: _loading,
            onPressed: () => _loadPost(forceRefresh: true),
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'Load posts',
            icon: Icons.list,
            variant: AppButtonVariant.outlined,
            loading: _loading,
            onPressed: _loadPosts,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: AppLoadingIndicator());
    }
    if (_failure != null) {
      return AppErrorView(
        title: 'Something went wrong',
        message: ErrorMapper.toUserMessage(_failure!),
        retryLabel: 'Retry',
        onRetry: _loadPosts,
      );
    }
    if (_post == null && _posts.isEmpty) {
      return AppEmptyView(
        title: 'No posts found',
        message: 'Tap download to fetch a post',
        actionLabel: 'Load post',
        onAction: _loadPost,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_post != null)
          Text(
            '${_post!.id} - ${_post!.title}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ..._posts.map(
          (post) => ListTile(
            dense: true,
            title: Text(post.title),
            subtitle: Text('id ${post.id}'),
          ),
        ),
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Posts demo')),
  //     body: ListView(
  //       padding: const EdgeInsets.all(16),
  //       children: [
  //         if (_loading) const LinearProgressIndicator(),
  //         Text(
  //           _post == null ? 'No post loaded' : '${_post!.id}
  //- ${_post!.title}',
  //           style: Theme.of(context).textTheme.titleLarge,
  //         ),
  //         const SizedBox(height: 16),
  //         ..._posts.map(
  //           (post) => ListTile(
  //             dense: true,
  //             title: Text(post.title),
  //             subtitle: Text('id ${post.id}'),
  //           ),
  //         ),
  //       ],
  //     ),
  //       floatingActionButton: Column(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         FloatingActionButton(
  //           heroTag: 'getPost',
  //           onPressed: _loading ? null : _loadPost,
  //           child: const Icon(Icons.cloud_download),
  //         ),
  //         const SizedBox(height: 12),
  //         FloatingActionButton(
  //           heroTag: 'getPostFresh',
  //           onPressed: _loading ? null : () => _loadPost(forceRefresh: true),
  //           child: const Icon(Icons.refresh),
  //         ),
  //         const SizedBox(height: 12),
  //         FloatingActionButton(
  //           heroTag: 'getPosts',
  //           onPressed: _loading ? null : _loadPosts,
  //           child: const Icon(Icons.list),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
