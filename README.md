# Wellness Planner (Flutter)

A self-contained Flutter starter project based on the uploaded UI references.

## Screens included
- TDEE-style profile input screen (adapted to a non-diet wellness profile)
- Results / wellness summary
- Suggested foods with meal filters
- Food search and selection
- Food log with remove action
- Exercise and movement ideas
- Bottom navigation between all main screens

## Run
1. Install Flutter and Android Studio.
2. Unzip this project.
3. From this folder run:
   ```bash
   flutter pub get
   flutter run
   ```

No third-party packages are required.

## Notes
The reference images contain weight-loss targets, calorie deficits and exercise-to-burn calculations. Those features are intentionally replaced with neutral wellness guidance rather than calorie restriction or weight-loss prescriptions. The profile values are displayed as entered and are not used to generate a dieting target. This is a UI starter, not medical advice.

To create a new Flutter project and copy these files:
```bash
flutter create wellness_planner
# Replace pubspec.yaml and lib/main.dart with the files in this archive.
flutter pub get
flutter run
```
