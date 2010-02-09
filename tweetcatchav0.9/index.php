<?php

$month = ''; $day = ''; $year = '';

if (isset($_GET['month'])) {
	if (strlen(trim($_GET['month'])) > 0) {
		$month = mysql_real_escape_string( stripslashes(strip_tags($_GET['month'])) );
	}
}

if (isset($_GET['day'])) {
	if (strlen(trim($_GET['day'])) > 0) {
		$day = mysql_real_escape_string( stripslashes(strip_tags($_GET['day'])) );
	}
}

if (isset($_GET['year'])) {
	if (strlen(trim($_GET['year'])) > 0) {
		$year = mysql_real_escape_string( stripslashes(strip_tags($_GET['year'])) );
	}
}

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>TweetCatcha v 1.0</title>
	
	<style type="text/css">
	html, body {margin:0px; padding:0px; background-color:#020204; height:100%;}
	#FlashContent {margin:0px; padding:0px; width:100%; height:100%;}
	</style>
	
	<script type="text/javascript" src="swfobject.js"></script>
	<script type="text/javascript">
	var fullDate = '';
	<?php
	$fullDate = '';
	if ($month != '' && $day != '' && $year != '') {
		$fullDate = $month.'-'.$day.'-'.$year;
		echo 'fullDate='.$fullDate.';';
	}
	?>
	
	swfobject.embedSWF("TweetCatcha.swf", "FlashContent", "100%", "100%", "9.0.0", "expressInstall.swf", {date:fullDate}, {menu:"false", allowScriptAccess:"sameDomain"}, {id:"TweetCatcha", name:"TweetCatcha"});
	
	</script>

</head>

<body>

<div id="FlashContent">
	<div>
		Content to be replaced by Flash.
	</div>
</div>


</body>
</html>