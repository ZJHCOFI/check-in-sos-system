#!/bin/bash
#Edit by ZJHCOFI
#功能：封禁IP(防止攻击)
#后续漏洞修补(如有)通告页面：https://space.bilibili.com/9704701/dynamic
#2021-12-12 19:15

##########可编辑区#############
#     请修改 "" 内的内容      #

# 24小时内单个IP最大访问次数（超过此次数将被封禁，建议设置为50）
ip_num="50"

# 封禁IP记录文件保存路径
ban_ip_log="/usr/www/ban_ip.log"

# mysql数据库用户名
mysql_user="root"

# mysql数据库密码
mysql_passwd="Bili@233"

# mysql数据库端口（默认为3306）
mysql_port="3306"

#########可编辑区结束#########

#-----------------------------
#-------以下代码请勿动--------
#-----------------------------

# 当前时间
ban_time=$(date "+%Y-%m-%d %H:%M:%S")

# 检测一天内的ip访问次数
select_sql_24_hour="select visit_ip from ciss_ip_num_24_hour where num >= ${ip_num}"

# 检测数据库连接
mysql -P${mysql_port} -u${mysql_user} -p${mysql_passwd} ciss_db -e "select count(*) from ciss_ip_num_24_hour where num >= ${ip_num}" > sql.temp	
mysql_check=`tail -n 1 sql.temp`
mysql_printf_check=`echo -n "${mysql_check}" | tr -d '^[0-9]+$'`

# 如果数据库连接异常
if [[ "${mysql_check}" == "" || "${mysql_printf_check}" != "" ]];then

  echo -e "\n【错误】数据库连接或者查询出现问题，请检查：\n1、可编辑区的数据库信息是否正确\n2、是否已使用root权限执行本脚本\n3、是否已正常导入sql文件\n"
  exit

else

  mysql -P${mysql_port} -u${mysql_user} -p${mysql_passwd} ciss_db -e "$select_sql_24_hour" | grep -v ip | while read a
  do
    echo -e "${ban_time}\t${a}" >> ${ban_ip_log}
    if [ $a != "" ]; then
      iptables -I INPUT -s $a -j DROP
    fi
  done

fi