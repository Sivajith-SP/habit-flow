import 'package:flutter/material.dart';

import '../../../../app/theme/app_flow_tokens.dart';
import 'bento_cell.dart';

/// NameCell contains the habit title and optional note inputs.
///
/// Features:
/// - Background: `tileLavender`
/// - Label: "Name"
/// - Title TextField: 24 / w800 / letterSpacing -0.5, hint "e.g. Drink water"
/// - Note TextField: 15 / w500, hint "Add a note (optional)"
/// - Single-line inputs with no border and hidden counter texts
class NameCell extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController noteController;
  final FocusNode? titleFocusNode;
  final FocusNode? noteFocusNode;
  final ValueChanged<String>? onTitleChanged;
  final ValueChanged<String>? onNoteChanged;

  const NameCell({
    super.key,
    required this.titleController,
    required this.noteController,
    this.titleFocusNode,
    this.noteFocusNode,
    this.onTitleChanged,
    this.onNoteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

    return BentoCell(
      label: 'Name',
      backgroundColor: tokens.tileLavender,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title input
          TextField(
            controller: titleController,
            focusNode: titleFocusNode,
            onChanged: onTitleChanged,
            maxLength: 40,
            maxLines: 1,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            style: AppUrbanist.habitInputTitle(color: tokens.text),
            decoration: InputDecoration(
              isDense: true,
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              counterText: '',
              hintText: 'e.g. Drink water',
              hintStyle: AppUrbanist.habitInputTitle(
                color: tokens.mutedText.withValues(alpha: 0.65),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Note input
          TextField(
            controller: noteController,
            focusNode: noteFocusNode,
            onChanged: onNoteChanged,
            maxLength: 60,
            maxLines: 1,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            style: AppUrbanist.habitInputNote(color: tokens.text),
            decoration: InputDecoration(
              isDense: true,
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              counterText: '',
              hintText: 'Add a note (optional)',
              hintStyle: AppUrbanist.habitInputNote(
                color: tokens.mutedText.withValues(alpha: 0.65),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
