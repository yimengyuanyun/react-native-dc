1. 初始化npm项目
npm init 
2. 添加用户（没有账号）
npm adduser
回车弹出浏览器窗口，（需要注册https://www.npmjs.com/）
3. 登录（已有账号）
npm login
回车弹出浏览器窗口，输入邮件收到的验证码校验
4. 验证是否登录成功
npm whoami
会显示登录成功的username
5. 发布
npm publish
注意每次发布version都要更新

0.0.13 - 0.0.3 内网
0.0.14 - 0.0.4 外网
0.0.16 - 0.0.6 外网，包含armeabi-v7，改了包名
0.0.17 - 0.0.6 外网，修改了android上传文件监听status=0