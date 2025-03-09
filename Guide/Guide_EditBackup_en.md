# CustomFocusIcon

## Backup Editing Guide (requires computer)

You can use Windows PC or macOS to achieve this, macOS users are recommended to refer to the macOS editing tutorial, which is simpler.

1. First, create a new Focus Mode, you can also create several, which is convenient for batch modification. Encrypt the backup device using iTunes or a third-party management tool (such as: iMazing or i4 Tools or 3u Tools), please note that you must encrypt the backup, otherwise the backup will not contain the required files.

2. After the backup is complete, open the backup and find
`/HomeDomain/Library/DoNotDisturb/DB/ModeConfigurations.json`
Copy this file to your computer.

3. (Using App Modification) Send this file to the current device, save it to the File App, find the current App's directory, then open the App's 'Manual Mode' for modification. After modification, the file will be saved to the directory you copied to, and you can copy this file back to the computer.

4. (Manual Modification) Open the copied file, use a text editor, any text editor is fine, no restrictions, search for the focus mode you just created, after searching, find the field `"symbolImageName"` after the name, it looks something like this:`"symbolImageName":"book.fill"`, then you just need to change "book.fill" to `"bell.slash.fill"`, this is the mute icon, or the SF Symbol you want, you can find it in the SF Symbols app. Do not leave any spaces, do not change the original format `"symbolImageName":"bell.slash.fill"`, save the file, and close the text editor  
**Important Tip: It is recommended to choose an SF Symbol that is compatible with all your devices, and it is recommended to choose an SF Symbol compatible with iOS 15.0 or later, otherwise, when you open this SF Symbol, the low version system will not be able to display this icon normally, which will cause SpringBoard to restart indefinitely! Unless you turn off this incompatible Focus Mode!**

5. Replace the modified file in the backup.

6. Restore the backup to the device and wait for the restore to complete. Please note that after the restore process, if "Data Restore Options" appear on the screen, please select "Do Not Transfer Apps and Data", otherwise your data may be lost.

7. Open System Settings, Focus Mode, the icon has been changed. Remember to change the name or color of this focus mode again so that iCloud can sync this focus mode. Please do not change the icon, just change the name or color.

8. Open the Focus Mode and enjoy it.