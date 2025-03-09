# CustomFocusIcon

## macOS Editing Guide (requires macOS)

Firstly, make sure that the computer and phone are using the same iCloud account. This is very important!

1. Open the computer's settings, Focus Mode, create a new Focus Mode, you can also create several, which is convenient for batch modification. Then name it arbitrarily, remember this name, and choose any icon. Choose the color you like. Then close the settings, `Command + Q`

2. Open Mac's Finder
   `Command + Shift + G` to bring up the address bar, paste this address
   `~/Library/DoNotDisturb/DB/ModeConfigurations.json`
   Make a copy of this file, copy it to the desktop or the download folder, you must copy it, otherwise you will be prompted that the file is locked

3. (Using App to Modify) Send this file to the current device, save it to the Files App, find the current App's directory, then open the App's 'Manual Mode' for modification. After modification, the file will be saved to the directory you copied to, and then copy this file back to the computer.

4. (Manual Modification) Open the copied file, use a text editor, any text editor is fine, no restrictions, search for the focus mode you just created, after searching, find the field `"symbolImageName"` after the name, it looks something like this:`"symbolImageName":"book.fill"`, then you just need to change "book.fill" to `"bell.slash.fill"`, this is the mute icon, or the SF Symbol you want, you can find it in the SF Symbols app. Do not leave any spaces, do not change the original format `"symbolImageName":"bell.slash.fill"`, save the file, and close the text editor   **Important Tip: It is recommended to choose an SF Symbol that is compatible with all your devices, and it is recommended to choose an SF Symbol compatible with iOS 15.0 or later, otherwise, when you open this SF Symbol, the low version system will not be able to display this icon normally, which will cause SpringBoard to restart indefinitely! Unless you turn off this incompatible Focus Mode!**

5. Copy the file back to `~/Library/DoNotDisturb/DB/`and overwrite it

6. Restart the computer, this step is crucial, otherwise the system will not reload the Focus Mode

7. After restarting, open the computer settings, Focus Mode, the icon has changed, remember to change the name or color of this Focus Mode again, so that iCloud can synchronize this Focus Mode, please do not change the icon, just change the name or color.

8. Wait for iCloud to synchronize to the phone and iPad, open the focus mode and enjoy it happily.