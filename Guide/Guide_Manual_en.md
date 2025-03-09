# CustomFocusIcon

## iOS 16 or above version (requires jailbreak) modification guide
Due to the fact that the configuration file directory has been protected by the system starting from iOS 16.0 version, you cannot directly use this App or `Filza` to edit it. You need to use SSH or Terminal commands to achieve this.

1. First, make sure your device is jailbroken and has `SSH` and `NewTerm` installed, and you know the current root password. Create a new focus mode, you can also create several, which is convenient for batch modification.

2. It is recommended to try using NewTerm on the iOS device first,
   In NewTerm, input
  `su`
   Then press the Enter key, input the root password, and press Enter 
    Go directly to step 4

3. If step 2 fails, you can only use the SSH command to operate. The computer and phone are on the same Wi-Fi, open Terminal on the computer and input

`ssh root@your_device_IP_address`

Press the Enter key and input your root password

4. Copy the following command to copy the configuration file to the current App

`cp /var/mobile/Library/DoNotDisturb/DB/ModeConfigurations.json /var/mobile/Documents/`

If you cannot copy it on the iOS device, it prompts "no permission", then you need to jump to step 3 to use SSH to solve it.

Copy the following command to change file permissions

`chown mobile:mobile /var/mobile/Documents/ModeConfigurations.json`

5. Open the App's settings and enable 'Manual Mode'

6. Use the App's built-in editor to edit the icon of the desired focus mode

7. Use the following command to copy the configuration file back to the original directory

`cp /var/mobile/Documents/ModeConfigurations.json /var/mobile/Library/DoNotDisturb/DB`

Copy the following command to change file permissions

`chown mobile:mobile /var/mobile/Library/DoNotDisturb/DB/ModeConfigurations.json`

8. Restart or reboot the user space. Do not change the focus mode in the settings before restarting, otherwise the previous modifications may be overwritten.

9. Open system settings, focus mode, the icon has been changed. Remember to change the name or color of this focus mode so that iCloud can sync this focus mode. Please do not change the icon, just change the name or color.

10. Open the focus mode and enjoy it.