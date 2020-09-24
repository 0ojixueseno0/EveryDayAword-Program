# EveryDayAword

功能介绍移步：https://im0o.top/everydayaword.html

## 🚀程序部分 - 后端

使用语言：Ruby + Yaml + Bat +MySQL

数据传输实现：

-----

获取数据库 表 - Word列 中的所有内容，并转为数组，通过websocket传值



当前版本：从数据库获取数据，并通过websocket传值给前端



未来版本：定时从数据库获取数据并存入变量，websocket将变量传给前端

----

食用方法：

在你的windows服务器上打开bat即可，如需更改端口，请更改bat中的<8887>（默认端口为8887）

or

在你的Linux服务器中的程序目录内执行指令`rackup App.ru -s puma -E production -p 8887`

更改端口一样

