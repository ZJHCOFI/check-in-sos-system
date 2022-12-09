# 基于LAMP的签到式救援系统(Check In SOS System - CISS)

## 基本情况  
  
本系统架构及流程解析，还有部署教程的地址：https://www.zjhcofi.com/2021/12/04/check-in-sos-system/  
  
后续更新或漏洞修补通告页面(国内)：https://space.bilibili.com/9704701/dynamic  
  
开源协议：BSD 3-Clause “New” or “Revised” License (https://choosealicense.com/licenses/bsd-3-clause/)  
  
## 更新日志  

### 2022-12-09 新增了签到时记录IP地址，发送邮件时自动带上最后五次签到记录的功能  
  
`web/check-in.php`：新增了签到时记录IP地址的功能  
`ciss_send_mail.sh`：新增了发送邮件时自动带上最后五次签到记录的功能  
`ciss_db.sql`：新增了用于记录IP的字段  
  
如已部署了旧版本的sql文件，可以输入以下语句新增字段：  
mysql> `use ciss_db;`  
mysql> `ALTER TABLE ciss_check_in ADD COLUMN check_user_ip varchar(40) DEFAULT NULL COMMENT '签到的用户ip地址' AFTER check_user_id;`  
mysql> `ALTER TABLE ciss_user ADD COLUMN user_last_login_ip varchar(40) DEFAULT NULL COMMENT '最后登录的IP地址' AFTER user_last_login_time;`  
