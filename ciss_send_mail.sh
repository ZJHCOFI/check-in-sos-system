#!/bin/bash
#Edit by ZJHCOFI
#功能：按照特定情况发送邮件
#后续漏洞修补(如有)通告页面：https://space.bilibili.com/9704701/dynamic
#2021-12-12 21:31

##########可编辑区#############
#     请修改 "" 内的内容      #

#-----用户信息
# 签到的用户名
user_name="admin"
# 邮件发送记录保存路径
send_mail_log="/usr/www/send_mail.log"

#-----情况一
# 连续未签到几天执行？（注：如果情况一符合条件，会在情况二符合条件前的每天执行）
Attention_day="1"
# 邮件标题
Attention_title="签到提示"
# 邮件正文（换行请使用"\n"）
Attention_text="该签到啦！\n再不签到你的隐私就自动发出去了！"
# 邮件附件路径（没有附件请留空）
Attention_appendix=""
# 邮件收件人（多个收件人请用英文逗号","分割）
Attention_addressee="test@qq.com"

#-----情况二
# 连续未签到几天执行？（只在符合条件的当天执行）
Warning_day="3"
# 邮件标题
Warning_title="ZJH可能遭遇意外，请尽快联系他"
# 邮件正文（换行请使用"\n"）
Warning_text="ZJH可能遭遇意外，请尽快联系他\n他的手机号：12345\n他父亲的手机号：12345\n他母亲的手机号：12345\n\n此邮件由签到系统自动发出，他已经${Warning_day}天没签到了"
# 邮件附件路径（没有附件请留空）
Warning_appendix=""
# 邮件收件人（多个收件人请用英文逗号","分割）
Warning_addressee="test@qq.com,test@163.com"

#-----情况三
# 连续未签到几天执行？（只在符合条件的当天执行）
Error_day="7"
# 邮件标题
Error_title="本人物品一览表"
# 邮件正文（换行请使用"\n"）
Error_text="如果您收到此邮件，请将该邮件附件给到XXX。\n本人各种账号密码等内容在附件内（该附件已加密，只有XXX知道密码）\n\n此邮件由签到系统自动发出，他已经${Error_day}天没签到了"
# 邮件附件路径（没有附件请留空）
Error_appendix="/usr/www/ZJH_something.zip"
# 邮件收件人（多个收件人请用英文逗号","分割）
Error_addressee="test@qq.com,test@163.com"

#-----数据库信息
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
send_time=$(date "+%Y-%m-%d %H:%M:%S")

# 检测数据库连接
mysql -P${mysql_port} -u${mysql_user} -p${mysql_passwd} ciss_db -e "select count(*) from ciss_user where user_name='${user_name}'" > sql.temp	
mysql_check=`tail -n 1 sql.temp`
mysql_printf_check=`echo -n "${mysql_check}" | tr -d '^[0-9]+$'`

# 如果数据库连接异常
if [[ "${mysql_check}" == "" || "${mysql_printf_check}" != "" ]];then

  echo -e "\n【错误】数据库连接或者查询出现问题，请检查：\n1、可编辑区的数据库信息是否正确\n2、是否已使用root权限执行本脚本\n3、是否已正常导入sql文件\n"
  exit

else

  # 如果数据库连接正常，但用户名不存在
  if [[ "${mysql_check}" == "0" ]];then
    
    echo -e "\n【错误】用户名不存在，请修改！\n"
    exit
    
  else
    # 未签到的天数查询
    no_check_days=`mysql -P${mysql_port} -u${mysql_user} -p${mysql_passwd} ciss_db -e "SELECT datediff(DATE_FORMAT(now(),'%Y-%m-%d'),DATE_FORMAT(c.check_time,'%Y-%m-%d')) FROM ciss_user u left join ciss_check_in c on u.user_id = c.check_user_id where u.user_name = '${user_name}' order by c.check_time desc limit 1" | grep -v check`
    # 如果没有签到记录
    if [[ "${no_check_days}" == "" || "${no_check_days}" == "NULL" ]];then
    	echo -e "${send_time}\t无签到记录" >> ${send_mail_log}
    	exit
    fi
    # 如果是情况一
    if [[ "${no_check_days}" -ge "${Attention_day}" && "${no_check_days}" -lt "${Warning_day}" ]];then
      if [[ "${Attention_appendix}" != "" ]];then
        echo -e "${Attention_text}" | mailx -s "${Attention_title}" -a ${Attention_appendix} ${Attention_addressee}
        echo -e "发送记录：\t${send_time}\t${Attention_title}\t${Attention_text}\t${Attention_addressee}\t${Attention_appendix}" >> ${send_mail_log}
      else
        echo -e "${Attention_text}" | mailx -s "${Attention_title}" ${Attention_addressee}
        echo -e "发送记录：\t${send_time}\t${Attention_title}\t${Attention_text}\t${Attention_addressee}" >> ${send_mail_log}
      fi
    fi
    # 如果是情况二
    if [[ "${no_check_days}" == "${Warning_day}" ]];then
      if [[ "${Warning_appendix}" != "" ]];then
        echo -e "${Warning_text}" | mailx -s "${Warning_title}" -a ${Warning_appendix} ${Warning_addressee}
        echo -e "发送记录：\t${send_time}\t${Warning_title}\t${Warning_text}\t${Warning_addressee}\t${Warning_appendix}" >> ${send_mail_log}
      else
        echo -e "${Warning_text}" | mailx -s "${Warning_title}" ${Warning_addressee}
        echo -e "发送记录：\t${send_time}\t${Warning_title}\t${Warning_text}\t${Warning_addressee}" >> ${send_mail_log}
      fi
    fi
    # 如果是情况三
    if [[ "${no_check_days}" == "${Error_day}" ]];then
      if [[ "${Error_appendix}" != "" ]];then
        echo -e "${Error_text}" | mailx -s "${Error_title}" -a ${Error_appendix} ${Error_addressee}
        echo -e "发送记录：\t${send_time}\t${Error_title}\t${Error_text}\t${Error_addressee}\t${Error_appendix}" >> ${send_mail_log}
      else
        echo -e "${Error_text}" | mailx -s "${Error_title}" ${Error_addressee}
        echo -e "发送记录：\t${send_time}\t${Error_title}\t${Error_text}\t${Error_addressee}" >> ${send_mail_log}
      fi
    fi  
  
  fi

fi