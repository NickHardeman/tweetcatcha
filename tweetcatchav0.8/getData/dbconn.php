<?php

if (!$link = mysql_connect('localhost', 'root', 'admin8or')) {
    	echo 'Could not connect to mysql';
    	exit;
}

if (!mysql_select_db('Tweetcatcha_db', $link)) {
    echo 'Could not select the database';
    exit;
}

?>