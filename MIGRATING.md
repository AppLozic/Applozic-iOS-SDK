## Migration Guides

#### Migrating from old version to new version 6.11.0

1) Updates to ApplozicAttachmentDelegate will now come in main thread, so you can directly update your UI from the delegate methods.

#### Migrating from old version to version 6.9.6 and above

Below Migrating from old version to new version 6.9.5 are not required to add in 6.9.6 and above as those settings will be added in our internal class methods.

#### Migrating from old version to new version 6.9.5

Add the below settings in two files

1) In `AppDelegate` file inside the method of  `didFinishLaunchingWithOptions`  paste the below settings code
2) In `ALChatManager`  file  inside the  method   `ALDefaultChatViewSettings`  paste the below settings

Settings code :

Objective- c
```
[ALApplozicSettings setupSuiteAndMigrate];
```
Swift
```
ALApplozicSettings.setupSuiteAndMigrate()
```