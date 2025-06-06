import 'package:card_crawler/ui/constant/game_card_aspect_ratio.dart';
import 'package:card_crawler/ui/extension/ui_scale.dart';
import 'package:flutter/material.dart';

import '../../../provider/gameplay/model/game_card.dart';

class GameCardView extends StatelessWidget {
  const GameCardView({
    super.key,
    required this.card,
    this.onTap,
    this.isEffectDetailsVisible = false,
    this.extraActionDescription,
    this.selectionColor,
  });

  final GameCard card;
  final Function()? onTap;
  final bool isEffectDetailsVisible;
  final String? extraActionDescription;
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) {
    final double uiScale = context.uiScale();
    final bool isSmallScreen = context.isSmallScreen();

    final scrollController = ScrollController();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onHighlightChanged: (_) {
          FocusScope.of(context).unfocus();
        },
        onHover: (_) {
          FocusScope.of(context).unfocus();
        },
        focusColor: (selectionColor ?? Colors.white).withValues(alpha: 0.7),
        hoverColor: (selectionColor ?? Colors.white).withValues(alpha: 0.5),
        highlightColor: (selectionColor ?? Colors.white).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8.0 + 4.0 * uiScale),
        child: AspectRatio(
          aspectRatio: gameCardAspectRatio,
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: EdgeInsets.all(4.0 * uiScale),
            clipBehavior: Clip.antiAlias,
            child:
                isEffectDetailsVisible
                    ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 16.0 * uiScale,
                            top: 16.0 * uiScale,
                            right: 16.0 * uiScale,
                            bottom: 8.0 * uiScale,
                          ),
                          child: Text(
                            'Effect: ${card.effect.name}',
                            style: TextStyle(fontSize: 14.0 * uiScale),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Divider(
                          height: 1.0,
                          thickness: 1.0,
                          indent: 16.0 * uiScale,
                          endIndent: 16.0 * uiScale,
                          color: Colors.black26,
                        ),
                        Expanded(
                          child: Scrollbar(
                            controller: scrollController,
                            thumbVisibility: true,
                            interactive: true,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0 * uiScale,
                                horizontal: 16.0 * uiScale,
                              ),
                              controller: scrollController,
                              child: Text(
                                card.effect.description,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0 * uiScale,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 1.0,
                          thickness: 1.0,
                          indent: 16.0 * uiScale,
                          endIndent: 16.0 * uiScale,
                          color: Colors.black26,
                        ),
                        if (extraActionDescription != null)
                          Padding(
                            padding: EdgeInsets.only(
                              left: 16.0 * uiScale,
                              top: 8.0 * uiScale,
                              right: 16.0 * uiScale,
                            ),
                            child: Text(
                              extraActionDescription!,
                              style: TextStyle(fontSize: 12.0 * uiScale),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        SizedBox(height: 16.0 * uiScale),
                      ],
                    )
                    : Padding(
                      padding: EdgeInsets.all(4.0 * uiScale),
                      child: Stack(
                        children: [
                          Center(
                            child: SizedBox(
                              width: 64.0,
                              child: Image.asset(card.asset),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              width: 40.0 * uiScale,
                              height: 40.0 * uiScale,
                              child: Image.asset(
                                isSmallScreen
                                    ? card.type.assetSmall
                                    : card.type.asset,
                                fit: BoxFit.none,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              width: 40.0 * uiScale,
                              height: 40.0 * uiScale,
                              child: Center(
                                child: Text(
                                  card.value.toString(),
                                  style: TextStyle(fontSize: 24.0 * uiScale),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
