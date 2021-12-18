#!/bin/bash
#Edit by ZJHCOFI
#功能：创建签到用的用户名和密码
#后续漏洞修补(如有)通告页面：https://space.bilibili.com/9704701/dynamic
#2021-12-12 18:04

##########可编辑区#############
#     请修改 "" 内的内容      #

# 需要创建的用于签到的用户名（只能由大小写英文字母、数字或下划线组成，不能出现特殊字符和标点符号，限制20个字符）
ciss_user_name="admin"

# 该用户的密码（为了您的信息安全，请设置高强度密码）
ciss_user_passwd="Admin@321"


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

# 检测用户名/密码是否为空
if [[ "${ciss_user_name}" == "" || "${ciss_user_passwd}" == "" ]];then
	
	echo -e "\n【错误】签到的用户名和密码不能为空！\n"
	exit
	
else

	# 如果不为空，将用户名全部转为小写，并进行合法性判断
	user_name_lower=`echo -n ${ciss_user_name} | tr "[:upper:]" "[:lower:]"`	
	user_name_check=`echo -n "${user_name_lower}" | tr -d '^[0-9a-zA-Z_]+$'`
	user_name_length=`echo ${user_name_lower} | awk -F "" '{print NF}'`

	# 如果用户名不合法
	if [[ "${user_name_check}" != "" || "${user_name_length}" -gt 20 ]];then
		
		echo -e "\n【错误】用户名只能由大小写英文字母、数字或下划线组成，不能出现特殊字符和标点符号！\n用户名不能超过20个字符\n"
		exit
		
	else
	
		# 如果用户名正常，检测用户名是否重复
		mysql -P${mysql_port} -u${mysql_user} -p${mysql_passwd} ciss_db -e "select count(*) from ciss_user where user_name='${user_name_lower}'" > sql.temp	
		mysql_user_check=`tail -n 1 sql.temp`
		mysql_printf_check=`echo -n "${mysql_user_check}" | tr -d '^[0-9]+$'`
		
		# 如果数据库连接异常
		if [[ "${mysql_user_check}" == "" || "${mysql_printf_check}" != "" ]];then
			
			echo -e "\n【错误】数据库连接或者查询出现问题，请检查：\n1、可编辑区的数据库信息是否正确\n2、是否已使用root权限执行本脚本\n3、是否已正常导入sql文件\n"
			exit
			
		else
			
			# 如果数据库连接正常，但用户名重复
			if [[ "${mysql_user_check}" -gt 0 ]];then
				
				echo -e "\n【错误】用户名重复，请换个用户名！\n"
				exit
				
			else
				
				# 用户名不重复，新增信息
				# 使用SHA256加密密码
				passwd_sum=${user_name_lower}${ciss_user_passwd}
				passwd_end=`printf ${passwd_sum} | sha256sum | cut -d " " -f 1`

        #生成uuid
        uuid=`uuidgen`
        
				# mysql插入语句
				mysql_insert="INSERT INTO ciss_user (user_id,user_name,user_passwd) VALUES ('${uuid}','${user_name_lower}','${passwd_end}');"

				# 插入mysql
				mysql -P${mysql_port} -u${mysql_user} -p${mysql_passwd} ciss_db -e "${mysql_insert}"
				
				echo -e "\n【提示】如无报错，则新增用户成功\n【注】“mysql: [Warning] Using a password on the command line interface can be insecure.”不属于报错\n"
				
			fi
		
		fi
		
	fi
	
fi