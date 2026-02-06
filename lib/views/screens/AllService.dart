import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/providers/serviceProvider.dart';
import 'package:nadi_user_app/routing/app_router.dart';

import 'package:nadi_user_app/widgets/app_back.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Allservice extends ConsumerStatefulWidget {
  const Allservice({super.key});

  @override
  ConsumerState<Allservice> createState() => _AllserviceState();
}

class _AllserviceState extends ConsumerState<Allservice> {
  @override
  Widget build(BuildContext context) {
    final services = ref.watch(serviceListProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCircleIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => context.pop(),
                  ),
                  const Text(
                    "Service",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 5),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: AnimationLimiter(
                  child: GridView.builder(
                    itemCount: services.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                        ),
                    itemBuilder: (context, index) {
                      final service = services[index];
                      final String name = service['name'] ?? '';
                      final String serviceId = service['_id'] ?? "";
                      final String? image = service['serviceImage'];
                      final int points =
                          int.tryParse(service['points'].toString()) ?? 0;
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        columnCount: 2,
                        duration: const Duration(
                          milliseconds: 900,
                        ), //  slow & smooth
                        child: SlideAnimation(
                          verticalOffset: 40, // bottom → top feel
                          curve: Curves.easeOutCubic,
                          child: FadeInAnimation(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                context.push(
                                  RouteNames.sendservicerequest,
                                  extra: {
                                    'title': name,
                                    'imagePath':
                                        "${ImageBaseUrl.baseUrl}/$image",
                                    'serviceId': serviceId,
                                    'heroTag': "serviceHero$index",
                                    "points": points,
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.25),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Hero(
                                        tag: "serviceHero$index",
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${ImageBaseUrl.baseUrl}/$image",
                                          height: 80,
                                          width: 140,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                                color: Colors.grey.shade200,
                                                height: 80,
                                                width: 140,
                                              ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
