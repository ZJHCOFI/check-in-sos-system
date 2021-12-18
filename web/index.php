<!doctype html>
<head>
<!-- 后续漏洞修补(如有)通告页面：https://space.bilibili.com/9704701/dynamic -->
<title>签到式救援系统CISS-登录</title>
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

		<h1>CISS登录</h1>
		
		<!-- Loging form -->
			  <form action="index.php" method="post">
				<div class="form-group">
				  <input type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" placeholder="用户名" name="ciss_user_name">
				  
				</div>
				<div class="form-group">
				  <input type="password" class="form-control" id="exampleInputPassword1" placeholder="密码" name="ciss_passwd">
				</div>

				  <div class="form-check">

				  <!-- <label class="switch">
				  <input type="checkbox">
				  <span class="slider round"></span>
				</label>
				   <label class="form-check-label" for="exampleCheck1">Remember me</label>
				  
				  <label class="forgot-password"><a href="#">Forgot Password?<a></label> -->

				</div>
			  
				<br>
				<button type="submit" class="btn btn-lg btn-block btn-success">确认登录</button>
<?php
//Edit by ZJHCOFI
//后续漏洞修补(如有)通告页面：https://space.bilibili.com/9704701/dynamic
//session传参数
session_start();	

//默认时区
date_default_timezone_set('PRC');

//定义字符串
$passwd_input = "";
$username_input = "";
				  
//转义字符函数
function test_input($data){
	$data = trim($data);
	$data = stripslashes($data);
	$data = htmlspecialchars($data);
	$data = strtolower($data);
	return $data;
}
				  
//检测ip地址是否合法
function isip($val)
{   
   if(ereg("^[0-9.]+$", $val))
   {
	   return true;
   }         
   return false;
} 
				  
//检测是否为标准用户名
function isName($val)
{   
   if(ereg("^[0-9a-zA-Z_]+$", $val))
   {
	   return true;
   }         
   return false;
}
				  
//记录IP
$user_IP = ($_SERVER["HTTP_VIA"]) ? $_SERVER["HTTP_X_FORWARDED_FOR"] : $_SERVER["REMOTE_ADDR"];
$user_IP = ($user_IP) ? $user_IP : $_SERVER["REMOTE_ADDR"];
				  
//连接数据库【 这里有文件名要改！】
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


if($_SERVER['REQUEST_METHOD']=='POST')
{
	//转义字符串
	$username_input = test_input($_POST["ciss_user_name"]);
	$passwd_input = $_POST["ciss_passwd"];
	//连接数据库【 这里有文件名要改！】
	include("webconn.php");
	//定义错误
	$errors = array();
	//检查错误
	if(empty($_POST["ciss_user_name"]) || empty($_POST["ciss_passwd"]))
	{
		$errors[] = '<div><font color="#FF4444" size="+1">请填写完整</font></div>';	
	}
	if(isName($username_input) == false)
	{
		$errors[] = '<div><font color="#FF4444" size="+1">用户名不规范</font></div>';
	}
	//判断字符长度
	if(isset($username_input{20}))
	{
		$errors[] = '<div><font color="#FF4444" size="+1">用户名过长</font></div>';
	}
	if(isip($user_IP) == false || isset($user_IP{20}))
	{
		$errors[] = '<div><font color="#FF4444" size="+1">您的IP地址有毒！</font></div>';
	}
	//如果没有错误
	if(empty($errors))
	{
		//检测用户是否存在
		$sql_have_user = "select * from ciss_user where user_name='$username_input'";
		$res_have_user = mysqli_query($link,$sql_have_user);
		$row_have_user = mysqli_num_rows($res_have_user);
		//用户不存在
		if($row_have_user == 0)
		{
			echo '<div><font color="#FF4444" size="+1">用户名或密码有误</font></div>';
		}
		//用户存在
		else
		{
			//定义变量
			$user_id = "";
			$user_name = "";
			$user_passwd = "";
			
			while($while_have_user = mysqli_fetch_array($res_have_user,MYSQL_ASSOC))
			{
				$user_id = $while_have_user['user_id'];
				$user_name = $while_have_user['user_name'];
				$user_passwd = $while_have_user['user_passwd'];
			}
			
			$password_hash = hash('sha256',$username_input.$passwd_input);

			if($password_hash == $user_passwd)
			{
				$_SESSION['uuid'] = $user_id;
				echo '<div><font color="#00CC00" size="+1">登录成功,正在跳转~</font></div>';
				header('Location: check-in.php');
			}
			else
			{
				echo '<div><font color="#FF4444" size="+1">用户名或密码有误</font></div>';
			}
		}
	}
	else
	{
		foreach($errors as $msg)
		{
			echo "$msg";
		}
	}
	mysqli_close($link);
}

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