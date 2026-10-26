import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

IconData _iconFor(String name) {
  final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
  return switch (ext) {
    'mp4' ||
    'mov' ||
    'mkv' ||
    'avi' ||
    'webm' =>
      PhosphorIconsRegular.fileVideo,
    'jpg' ||
    'jpeg' ||
    'png' ||
    'gif' ||
    'webp' ||
    'heic' =>
      PhosphorIconsRegular.fileImage,
    'pdf' => PhosphorIconsRegular.filePdf,
    'zip' || 'rar' || '7z' || 'tar' || 'gz' => PhosphorIconsRegular.fileZip,
    _ => PhosphorIconsRegular.file,
  };
}

/// A file's icon, name and size in a tonal card. [trailing] is optional.
class FileCard extends StatelessWidget {
  const FileCard({
    super.key,
    required this.name,
    required this.size,
    this.trailing,
  });

  final String name;
  final String size;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_iconFor(name), color: scheme.onPrimaryContainer),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  size,
                  style:
                      text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
