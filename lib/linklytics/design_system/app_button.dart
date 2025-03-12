import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_sizes.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

/// (e.g., filters, tags, inline actions).
/// Medium Buttons (Default): Used for most actions in the app.
/// Large Buttons: Used for primary CTA (e.g., "Sign Up", "Buy Now", "Submit").
/// small: 100px (e.g., for compact UI elements)
/// medium: 150px (default)
/// large: 200px (e.g., for emphasis)
/// fullWidth: Expands to the parent width (e.g., dialogs or mobile UIs)
/// Small Buttons: Used for compact UI elements
enum ButtonSize { small, medium, large, fullWidth }

/// Warning Button (Orange): Actions that need caution (e.g., "Archive", "Disable").
/// Error Button (Red): Destructive actions (e.g., "Delete Account", "Remove User").
/// Success Button (Green): Confirmations (e.g., "Order Placed", "Payment Successful").
/// Filled (Primary): The main action on a page (e.g., "Submit").
/// Outlined (Secondary): Less emphasized but still important (e.g., "Cancel").
/// Text Buttons (Tertiary): Minimal design for minor actions (e.g., "Learn More").
enum ButtonType { primary, secondary, tertiary, warning, error, gradient }

/// Currently used by gradient button
final isHoveredProvider = StateProvider<bool>((ref) => false);
final isClickedProvider = StateProvider<bool>((ref) => false);

class AppButton extends ConsumerWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonType type;
  final ButtonSize size;
  final bool isOutlined;
  final bool isDisabled;
  final double borderRadius;
  final TextStyle? textStyle;
  final Color? outlineColor;

  const AppButton({
    required this.label,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isOutlined = false,
    this.isDisabled = false,
    this.borderRadius = AppSizes.radiusMedium,
    this.textStyle,
    this.outlineColor,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = _getButtonColors(type);
    final height = _getButtonHeight(size);
    final fontSize = _getFontSize(size);
    final width = _getButtonWidth(size, context);
    final isHovered = ref.watch(isHoveredProvider);
    final isClicked = ref.watch(isClickedProvider);
    final baseColors =
        isDisabled ? [Colors.grey, Colors.grey] : [Colors.blue, Colors.purple];
    final clickColors =
        isDisabled ? baseColors : [Colors.deepPurple, Colors.indigo];

    // Determine final button color based on state
    final gradientColors = isClicked ? clickColors : baseColors;

    final textColor = isDisabled
        ? Colors.grey
        : isHovered
            ? _getHoverTextColor(textStyle?.color ?? Colors.white)
            : textStyle?.color ?? Colors.white;

    final defaultTextStyle = TextStyle(fontSize: fontSize, color: textColor);

    if (type == ButtonType.gradient) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => ref.read(isHoveredProvider.notifier).state = true,
        onExit: (_) => ref.read(isHoveredProvider.notifier).state = false,
        child: GestureDetector(
          onTapDown: (_) {
            ref.read(isClickedProvider.notifier).state = true;
          },
          onTapUp: (_) {
            ref.read(isClickedProvider.notifier).state = false;
            onPressed();
          },
          onTapCancel: () {
            ref.read(isClickedProvider.notifier).state = false;
          },
          // onTap: isDisabled ? null : onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: textStyle?.copyWith(color: textColor) ?? defaultTextStyle,
            ),
          ),
        ),
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isDisabled ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.textColor,
                side: BorderSide(color: outlineColor ?? colors.backgroundColor),
                minimumSize: Size(width ?? 0, height),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ).copyWith(
                overlayColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.hovered)
                      ? Colors.black
                          .withValues(alpha: 0.1) // Change hover color
                      : null,
                ),
              ),
              child: Text(label, style: textStyle ?? defaultTextStyle),
            )
          : ElevatedButton(
              onPressed: isDisabled ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDisabled ? Colors.grey : colors.backgroundColor,
                minimumSize: Size(width ?? 0, height),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: Text(label, style: textStyle ?? defaultTextStyle),
            ),
    );
  }

  /// Returns a darker or lighter text color based on the current color.
  Color _getHoverTextColor(Color baseColor) {
    return baseColor.computeLuminance() > 0.5 ? Colors.grey : Colors.white70;
  }

  _ButtonColors _getButtonColors(ButtonType type) {
    switch (type) {
      case ButtonType.primary:
        return _ButtonColors(Colors.blueAccent, Colors.white);
      case ButtonType.secondary:
        return _ButtonColors(Colors.grey.shade800, Colors.white);
      case ButtonType.tertiary:
        return _ButtonColors(Colors.white, Colors.black);
      case ButtonType.warning:
        return _ButtonColors(Colors.orange, Colors.white);
      case ButtonType.error:
        return _ButtonColors(Colors.red, Colors.white);
      default:
        return _ButtonColors(Colors.blueAccent, Colors.white);
    }
  }

  double _getFontSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 12;
      case ButtonSize.medium:
        return 14;
      case ButtonSize.large:
      case ButtonSize.fullWidth:
        return 16;
    }
  }

  double _getButtonHeight(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return AppSizes.buttonSmall;
      case ButtonSize.medium:
        return AppSizes.buttonMedium;
      case ButtonSize.large:
      case ButtonSize.fullWidth:
        return AppSizes.buttonLarge;
    }
  }

  double? _getButtonWidth(ButtonSize size, BuildContext context) {
    switch (size) {
      case ButtonSize.small:
        return 100;
      case ButtonSize.medium:
        return 150;
      case ButtonSize.large:
        return 200;
      case ButtonSize.fullWidth:
        return double.infinity;
    }
  }
}

class _ButtonColors {
  final Color backgroundColor;
  final Color textColor;

  _ButtonColors(this.backgroundColor, this.textColor);
}

class _AppButtonCodePreview {
  static String codePreview(label, type, size, isDisabled, isOutlined) =>
      '''AppButton(
  label: '$label',
  onPressed: () {},
  type: $type,
  size: $size,
  isDisabled: $isDisabled,
  isOutlined: $isOutlined
)''';
}

/// Storybook examples
final List<Story> appButtonStories = [
  Story(
    name: 'Buttons/Primary',
    builder: (context) => Center(
      child: AppButton(
        label: 'Primary',
        onPressed: () {},
        type: ButtonType.primary,
        size: ButtonSize.medium,
        borderRadius: context.knobs
            .slider(label: 'Border Radius', initial: 8, min: 0, max: 32),
      ),
    ),
  ),
  Story(
    name: 'Buttons/Gradient',
    builder: (context) => AppButton(
      label: 'Gradient',
      onPressed: () {},
      type: ButtonType.gradient,
      size: ButtonSize.medium,
      borderRadius: context.knobs
          .slider(label: 'Border Radius', initial: 8, min: 0, max: 32),
    ),
  ),
  Story(
    name: 'Buttons/Sizes',
    builder: (context) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton(
          label: 'Small',
          onPressed: () {},
          type: ButtonType.primary,
          size: ButtonSize.small,
          borderRadius: context.knobs
              .slider(label: 'Border Radius', initial: 8, min: 0, max: 32),
        ),
        const SizedBox(height: 10),
        AppButton(
          label: 'Medium',
          onPressed: () {},
          type: ButtonType.primary,
          size: ButtonSize.medium,
          borderRadius: context.knobs
              .slider(label: 'Border Radius', initial: 8, min: 0, max: 32),
        ),
        const SizedBox(height: 10),
        AppButton(
          label: 'Large',
          onPressed: () {},
          type: ButtonType.primary,
          size: ButtonSize.large,
          borderRadius: context.knobs
              .slider(label: 'Border Radius', initial: 8, min: 0, max: 32),
        ),
      ],
    ),
  ),
  Story(
    name: 'Buttons/Knobs',
    builder: (context) {
      final label = context.knobs.text(label: 'Label', initial: 'Click Me');
      final isDisabled =
          context.knobs.boolean(label: 'Disabled', initial: false);
      final type = context.knobs.options(
        label: 'Type',
        options: ButtonType.values
            .map((type) =>
                Option(label: type.toString().split('.').last, value: type))
            .toList(),
        initial: ButtonType.primary,
      );
      final size = context.knobs.options(
        label: 'Size',
        options: ButtonSize.values
            .map((size) =>
                Option(label: size.toString().split('.').last, value: size))
            .toList(),
        initial: ButtonSize.medium,
      );

      final isOutlined = context.knobs.options(
          label: 'Outlined',
          options: const [
            Option(label: 'true', value: true),
            Option(label: 'false', value: false)
          ],
          initial: false);

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            child: AppButton(
              label: label,
              onPressed: () {},
              type: type,
              size: size,
              isDisabled: isDisabled,
              isOutlined: isOutlined,
              borderRadius: context.knobs
                  .slider(label: 'Border Radius', initial: 8, min: 0, max: 32),
            ),
          ),
          const SizedBox(height: 10),
          const AppText(
            text: 'Flutter Code Preview',
            type: TextType.md,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            width: 200,
            child: SelectableText(
              _AppButtonCodePreview.codePreview(
                label,
                type,
                size,
                isDisabled,
                isOutlined,
              ),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Courier', // Monospaced font
                color: Colors.greenAccent, // Code-like color
              ),
            ),
          ),
        ],
      );
    },
  ),
];
