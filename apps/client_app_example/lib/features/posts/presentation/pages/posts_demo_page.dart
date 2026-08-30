import 'package:auto_route/auto_route.dart';
import 'package:client_app_example/core/theme/theme_bloc.dart';
import 'package:client_app_example/di/injection.dart';
import 'package:client_app_example/errors/error_mapper.dart';
import 'package:client_app_example/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:enterprise_ui/enterprise_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The posts demo page widget.
@RoutePage()
class PostsDemoPage extends StatelessWidget {
  /// The constructor for the posts demo page widget.
  const PostsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PostsBloc>()..add(const PostsEvent.loadPost()),
      child: const _PostsDemoView(),
    );
  }
}

class _PostsDemoView extends StatelessWidget {
  const _PostsDemoView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts demo'),
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return IconButton(
                icon: Icon(themeState.currentThemeStatus.icon),
                onPressed: () => context.read<ThemeBloc>().add(
                      const ThemeEvent.toggleRequested(),
                    ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: AppLoadingIndicator()),
            loaded: (post, posts) {
              if (post == null && posts.isEmpty) {
                return AppEmptyView(
                  title: 'No posts found',
                  message: 'Tap download to fetch a post',
                  actionLabel: 'Load post',
                  onAction: () => context.read<PostsBloc>().add(
                        const PostsEvent.loadPost(),
                      ),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (post != null)
                    Text(
                      '${post.id} - ${post.title}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ...posts.map(
                    (p) => ListTile(
                      dense: true,
                      title: Text(p.title),
                      subtitle: Text('id ${p.id}'),
                    ),
                  ),
                ],
              );
            },
            error: (failure) => AppErrorView(
              title: 'Something went wrong',
              message: ErrorMapper.toUserMessage(failure),
              retryLabel: 'Retry',
              onRetry: () => context.read<PostsBloc>().add(
                    const PostsEvent.loadPost(),
                  ),
            ),
          );
        },
      ),
      floatingActionButton: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          final loading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppButton(
                label: 'Load post',
                icon: Icons.cloud_download,
                loading: loading,
                onPressed: () => context.read<PostsBloc>().add(
                      const PostsEvent.loadPost(),
                    ),
              ),
              const SizedBox(height: 8),
              AppButton(
                label: 'Refresh',
                icon: Icons.refresh,
                variant: AppButtonVariant.tonal,
                loading: loading,
                onPressed: () => context.read<PostsBloc>().add(
                      const PostsEvent.loadPost(forceRefresh: true),
                    ),
              ),
              const SizedBox(height: 8),
              AppButton(
                label: 'Load posts',
                icon: Icons.list,
                variant: AppButtonVariant.outlined,
                loading: loading,
                onPressed: () => context.read<PostsBloc>().add(
                      const PostsEvent.loadPosts(),
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}
