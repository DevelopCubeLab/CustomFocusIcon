# CustomFocusIcon

## iOS 16或以上版本系统(需要越狱)修改教程

由于配置文件目录从iOS 16.0版本开始，被系统保护了，因此您无法直接使用此App或者`Filza`进行编辑。需要使用SSH或者Terminal命令来实现

1. 首先确保您的设备已经越狱并且安装了`SSH`和`NewTerm`，并且您已经知道当前的root密码。新建一个专注模式，也可以多创建几个，方便批量修改。

2. 建议先在iOS设备上尝试使用NewTerm进行尝试，
   在NewTerm输入
   `su`
   然后按下换行按钮（回车），输入root密码，回车
   请直接到步骤4

3. 如果步骤2失败，只能使用SSH命令进行操作。电脑和手机在同一个Wi-Fi下，电脑打开Terminal 输入
   `ssh root@你的设备IP地址`
   并按下换行按钮，并且输入您的root密码

4. 复制下列命令将配置文件复制到当前App中
   `cp /var/mobile/Library/DoNotDisturb/DB/ModeConfigurations.json /var/mobile/Documents/`
   如果在iOS设备上无法复制，提示无权限，则需要跳转到步骤3使用SSH来解决。  
   复制下列命令更改文件权限
   `chown mobile:mobile /var/mobile/Documents/ModeConfigurations.json`

5. 打开App的设置，启用’手动模式’

6. 使用App内编辑器编辑您想要的专注模式icon

7. 使用下列命令将配置文件复制到原始目录下
    `cp /var/mobile/Documents/ModeConfigurations.json /var/mobile/Library/DoNotDisturb/DB`
    复制下列命令更改文件权限
   `chown mobile:mobile /var/mobile/Library/DoNotDisturb/DB/ModeConfigurations.json`

8. 重启或者重新启动用户空间，在重启之前请勿到设置中更改专注模式，否则之前的修改可能会被覆盖

9. 打开系统设置，专注模式，图标已经被更改，记得要再给这个专注模式改下名字或颜色，这样让iCloud同步这个专注模式，请勿修改图标，改名字或者颜色就好了。

10. 打开专注模式愉快享受。