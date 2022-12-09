<!doctype html>
<head>
<!-- 后续漏洞修补(如有)通告页面：https://space.bilibili.com/9704701/dynamic -->
<title>签到式救援系统CISS-签到</title>
<meta name="description" content="" />
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
<!-- Bootstrap CSS -->
<link rel="stylesheet" href="css/main_bootstrap.min.css">

<!-- Loding font -->
<!-- <link href="https://fonts.googleapis.com/css?family=Montserrat:300,700" rel="stylesheet"> -->

<link rel="shortcut icon" type="image/x-icon" href="img/favicon.png" media="screen" />

<!-- Custom Styles -->
<link rel="stylesheet" type="text/css" href="css/main_styles.css">


<body>

<!-- Backgrounds -->

<div id="login-bg" class="container-fluid">

  <div class="bg-img"></div>
  <div class="bg-color"></div>
</div>

<!-- End Backgrounds -->

<div class="container" id="login">
	<div class="row justify-content-center">
	<div class="col-lg-8">
	  <div class="login">

		<h1>CISS签到</h1>
		
		<!-- Loging form -->
			  <form action="check-in.php" method="post">
<?php
//Edit by ZJHCOFI
//后续漏洞修补(如有)通告页面：https://space.bilibili.com/9704701/dynamic
//session传参数
session_start();	

//默认时区
date_default_timezone_set('PRC');

//定义字符串
$uuid = $_SESSION['uuid'];
$passwd_input = "";
$username_input = "";			  
				  
//检测ip地址是否合法
function isip($val)
{   
   if(ereg("^[0-9.]+$", $val))
   {
	   return true;
   }         
   return false;
} 
				  
//检测是否为标准的uuid
function isUUID($val)
{   
   if(ereg("^[0-9a-zA-Z-]+$", $val))
   {
	   return true;
   }         
   return false;
}
				  
//记录IP
$user_IP = ($_SERVER["HTTP_VIA"]) ? $_SERVER["HTTP_X_FORWARDED_FOR"] : $_SERVER["REMOTE_ADDR"];
$user_IP = ($user_IP) ? $user_IP : $_SERVER["REMOTE_ADDR"];
				  
//连接数据库
include("webconn.php");
//记录最后时间及IP
if(isip($user_IP) == true && strlen($user_IP) <= 20)
{
	$sql_save_ip = "insert into ciss_ip_visit (visit_time,visit_ip) values (now(),'$user_IP')";
	$result_save_ip = mysqli_query($link,$sql_save_ip);
	if(!$result_save_ip){
		die('<div><font color="#FF4444" size="+1">数据库连接错误</font></div>'.mysqli_connect_error());
	}
}
else
{
	die('<div><font color="#FF4444" size="+1">您的IP地址有毒！</font></div>');
}
mysqli_close($link);

//判断是否已签到，如果已签到则显示已签到，否则出现“签到”按钮
//连接数据库
include("webconn.php");
//检查错误
if(isUUID($uuid) == false)
{
	die('<div><font color="#FF4444" size="+1">您可能尚未登录！</font></div>');
}
//检测用户是否存在
$sql_have_user = "select * from ciss_user where user_id='$uuid'";
$res_have_user = mysqli_query($link,$sql_have_user);
$row_have_user = mysqli_num_rows($res_have_user);
//用户不存在
if($row_have_user == 0)
{
	die('<div><font color="#FF4444" size="+1">您可能尚未登录！</font></div>');
}
//判断是否已签到
$sql_checkin_check = "select * from ciss_check_in where DATE_FORMAT(check_time,'%Y-%m-%d') = DATE_FORMAT(now(),'%Y-%m-%d') and check_user_id = '$uuid'";
$res_checkin_check = mysqli_query($link,$sql_checkin_check);
$row_checkin_check = mysqli_num_rows($res_checkin_check);
if($row_checkin_check > 0)
{
	echo '<div><font color="#00CC00" size="+3"><b>您今天已签到！</b></font></div>';
}
else
{
	//显示“签到”按钮
	echo '<button type="submit" class="btn btn-lg btn-block btn-success"><font  size="+2"><b>签到</b></font></button>';
	//点击“签到”按钮
	if($_SERVER['REQUEST_METHOD']=='POST')
	{
		//二次判断是否已签到
		$sql_checkin_check2 = "select * from ciss_check_in where DATE_FORMAT(check_time,'%Y-%m-%d') = DATE_FORMAT(now(),'%Y-%m-%d') and check_user_id = '$uuid'";
		$res_checkin_check2 = mysqli_query($link,$sql_checkin_check2);
		$row_checkin_check2 = mysqli_num_rows($res_checkin_check2);
		if($row_checkin_check2 > 0)
		{
			echo '<div><font color="#00CC00" size="+3"><b>您今天已签到！</b></font></div>';
		}
		else
		{
			//插入登录记录
			$sql_save_login = "update ciss_user set user_last_login_time=now(),user_last_login_ip='$user_IP' where user_id='$uuid'";
			$result_save_login = mysqli_query($link,$sql_save_login);
			if(!$result_save_login){
				die('<div><font color="#FF4444" size="+1">数据库连接错误</font></div>' . mysqli_connect_error());
			}

			//插入签到记录
			$sql_save_check_in = "insert into ciss_check_in (check_time,check_user_id,check_user_ip) values (now(),'$uuid','$user_IP')";
			$result_save_check_in = mysqli_query($link,$sql_save_check_in);
			if(!$result_save_check_in){
				die('<div><font color="#FF4444" size="+1">数据库连接错误</font></div>' . mysqli_connect_error());
			}
			else
			{
				echo '<div><font color="#00CC00" size="+3"><b>签到成功！</b></font></div>';
			}
		}
	}
}
				  
//显示最近5条签到记录
echo '<p></p><div><b><font size="+1">最近5条签到记录，如需修改密码请<a href="reset-pass.php" target="_blank">点这</a></font></b><p></p>';
echo '<table width="460" border="1" cellpadding="0" cellspacing="0">
		<tr>
		  <td width="20%" align="center">签到用户</td>
		  <td width="40%" align="center">签到时间</td>
		  <td width="40%" align="center">IP地址</td>
		</tr>
	</table>';
//获取签到记录
$sql_check_in_record = "SELECT u.user_name,c.check_time,c.check_user_ip FROM ciss_user u left join ciss_check_in c on u.user_id = c.check_user_id where c.check_user_id = '$uuid' order by c.check_time desc limit 5";
$res_check_in_record = mysqli_query($link,$sql_check_in_record);
while($while_check_in_record = mysqli_fetch_array($res_check_in_record,MYSQL_ASSOC))
{
	$user_name = $while_check_in_record['user_name'];
	$check_time = $while_check_in_record['check_time'];
	$check_user_ip = $while_check_in_record['check_user_ip'];

	echo '<table width="460" border="1" cellpadding="0" cellspacing="0">
		<tr>
		  <td width="20%" align="center">'.$user_name.'</td>
		  <td width="40%" align="center">'.$check_time.'</td>
		  <td width="40%" align="center">'.$check_user_ip.'</td>
		</tr>
	</table>';
}
echo '</div>';
mysqli_close($link);			  

?>
			  </form>
		 <!-- End Loging form -->
		<div>网页模板来自<a href="https://sc.chinaz.com/moban/191117385430.htm" target="_blank">互联网</a>，PHP代码编写:<a href="http://zjhcofi.com" target="_blank">ZJHCOFI</a></div>
	  </div>
	</div>
	</div>
</div>


</body>
</html>
