import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';

/// Presentational description block for the Home screen theme (node 6885:9028).
///
/// Layout: 335×240 px, starts at y=637.
/// Renders the "Root Further" theme description text in Montserrat Light.
class ThemeDescription extends StatelessWidget {
  const ThemeDescription({super.key});

  // Design constants (from MoMorph node 6885:9029)
  static const double _width = 335;
  static const double _height = 240;
  static const double _fontSize = 14;
  static const double _lineHeight = 20;
  static const double _letterSpacing = 0.25;
  static const Color _textColor = Color(0xFFFFFFFF);

  static const String _text =
      'Không đơn thuần là một cái tên, "Root Further" chính là tinh thần mà '
      'mỗi người Sun* đang hướng tới: luôn nhìn nhận sâu sắc trong mọi bối '
      'cảnh và không ngừng sáng tạo, mở rộng bản thân để vượt qua những giới '
      'hạn mà chính mình đã từng đặt ra. Mượn hình ảnh ẩn dụ của lý thuyết '
      'phối màu, chỉ từ ba màu cơ bản: đỏ, vàng và lam, sức sáng tạo vô tận '
      'của mỗi cá nhân có thể tạo ra số lượng màu sắc gần như vô hạn, với mỗi '
      'gam màu đều đại diện cho sự bứt phá và sáng tạo không giới hạn.';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: Text(
        _text,
        style: AppTypography.montserrat(
          fontSize: _fontSize,
          weight: FontWeight.w300,
          height: _lineHeight / _fontSize,
          letterSpacing: _letterSpacing,
          color: _textColor,
        ),
      ),
    );
  }
}
