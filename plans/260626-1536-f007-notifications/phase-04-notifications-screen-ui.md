# Phase 04 — NotificationsScreen UI (Track A)

## MoMorph refs
- Notifications: `_b68CBWKl5` → https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/_b68CBWKl5
- fileKey `9ypp4enmFmdK3YAFJLIu6C` · Clarifications: none (decisions in plan.md + spec draft)

## Goal
NotificationsScreen implemented from Figma design — list of notification rows, props-only, no providers. Figma content as mock-data source.
- **Delivered:** NotificationsScreen + NotificationRow widget, loading/empty/error states, type icons (Material), relative timestamps, read/unread visual treatment. Files <200 lines.

## Integration contract (props the screen exposes for P5 wiring)
- `notifications: List<AppNotification>`, `isLoading`, `hasError`, `onRetry`
- `onTap: ValueChanged<AppNotification>` (P5 marks read + deep-links)
- `onMarkAllRead: VoidCallback?` (only if design shows the affordance)
- Row renders: type icon (map `NotificationType → Material icon`), title, body, relative timestamp, read/unread visual state.
- States: loading / empty / error+retry — match Home/Awards/Kudos.

## Out of scope
- Providers, routing, deep-link resolution, badge (all P3/P5).
- Backend, persistence, settings screen, pagination.

## Notes
- `momorph-implement-design` handles exact colors/typography/positions at takumi time (bg `#00101A`, Montserrat, gold `#FFEA9E`).
- Avoid fixed widths/heights — size to parent, wrap long `Text` in `Flexible` (known overflow gotcha).
- Files <200 lines; split row widget into `presentation/widgets/notification_row.dart` if needed.
