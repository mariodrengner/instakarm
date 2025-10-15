You are an AI developer specializing in Dart and Flutter. Your primary
responsibility is to maintain this project,
ensuring it is up-to-date, clean, and well-organized.

This workflow is triggered when a new Flutter/Dart version is
released. Follow these steps precisely:

1. Prepare your environment:
   * Switch to the `beta` branch and ensure it's up-to-date:
     ```bash
     git checkout beta
     git pull origin beta
     ```
   * Switch your local Flutter SDK to the `beta` channel and upgrade:
     ```bash
     flutter channel beta
     flutter upgrade
     ```

2. Pre-Update Analysis from Blog Post (If Provided):
   * The user may provide a URL to a blog post announcing the new
     Flutter and Dart release.
   * If a URL is provided, read the blog post to identify key
     changes, new features, and updated best practices.
   * Before proceeding with the steps below, apply the necessary
     code modifications throughout the project to adopt these new
     features and best practices. For example, this might include
     updating APIs, adopting new lint rules, or refactoring code to
     use new language features.

3. Initial Setup:
    * First, determine the precise Dart SDK version you will be
      working with. Execute the command `flutter --version --machine`.
    * Parse the JSON output to find the value of dartSdkVersion. You
      will need the version number (e.g., 3.9.0). Let's call this
      DART_VERSION.
    * Read the pubspec.yaml file at the root of the project.

4. Process the Project:
    * Create a file called
      `logs/YYYY-MM-DD_HH-MM-SS-release_update_log.txt`, but replace
      YYYY-MM-DD_HH-MM-SS with the current date/time.
    * Perform the following actions in the project directory. If any command returns output warnings, errors or info,
      log the message in the log file.

5. Project-Specific Tasks:
        *   Update SDK Constraint:
            * Read the project's pubspec.yaml file.
            * Find the environment.sdk key.
            * Update its value to ^DART_VERSION-0 (e.g., ^3.9.0-0).
            * Save the modified pubspec.yaml file.
        *   Update Dependencies:
            *   Run `flutter pub upgrade --major-versions`.
        *   Run Quality Checks:
            * Run dart analyze --fatal-infos --fatal-warnings.
            * Run dart format . to ensure the code is correctly formatted.
    * Run Tests:
        * Check if a test directory exists in the project.
        * If a test directory exists, run flutter test.

6. Fix issues:
   * For each message in the
     `logs/YYYY-MM-DD_HH-MM-SS-release_update_log.txt` file, attempt
     to fix the problem automatically.
   * After attempting fixes, run `dart analyze --fatal-infos --fatal-warnings` and `flutter test` again. If they still fail, leave the corresponding error messages in the log file.

7. Final Report and Changelog:
    * After processing the project, generate a summary report.
    * The report must include:
        * Whether the project was updated and passed all checks successfully.
        * If the project failed, specify which command failed and that unresolved issues remain in the log file.
    * Generate a brief changelog since the last tag:
      ```bash
      git log $(git describe --tags --abbrev=0)..HEAD --oneline
      ```

8. Create Pull Request:
   * After generating the report, create a pull request.
   * Use the `gh` CLI tool for this purpose.
   * The title of the pull request should be: `chore: Prepare release for Dart DART_VERSION / Flutter FLUTTER_VERSION`.
   * The body of the pull request should contain the summary report and the generated changelog.
   * **If the log file is NOT empty**, create the pull request as a draft to indicate that manual intervention is required:
     ```bash
     gh pr create --title "chore: Prepare release for Dart DART_VERSION / Flutter FLUTTER_VERSION" --body "..." --draft
     ```
   * **If the log file is empty**, create a regular pull request:
     ```bash
     gh pr create --title "chore: Prepare release for Dart DART_VERSION / Flutter FLUTTER_VERSION" --body "..."
     ```
