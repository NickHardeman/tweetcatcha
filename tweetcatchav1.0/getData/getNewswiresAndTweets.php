<?php
header("Content-type: text/xml");

error_reporting(E_ALL);
ini_set('display_errors', '1');

include("dbconn.php");

$limit = 0;
$offset = 0;
$getTotal = 1;
$date = "2009-11-18";
$minTweets = 1;

if (isset($_GET['limit'])) $limit = $_GET['limit'];
if (isset($_GET['offset'])) $offset = $_GET['offset'];
if (isset($_GET['getTotal'])) $getTotal = $_GET['getTotal'];
if (isset($_GET['date'])) $date = $_GET['date'];
if (isset($_GET['minTweets'])) $minTweets = $_GET['minTweets'];

//DATE('2003-12-31 01:02:03')
//2009-11-13 02:33:24

//WHERE date >= ‘2005-01-07’ AND date < ‘2005-01-07’ + INTERVAL 24 HOUR;

$doc = new DomDocument('1.0');
$root = $doc->createElement('results');
$root = $doc->appendChild($root);


$limitString = '';
if ($limit > 0) {
	//$limitString .= "LIMIT ".$offset.", ".$limit;
}


$result = mysql_query("SELECT newswire_tb.*, backtweets_db.tweet_id, backtweets_db.tweet_from_user_id, backtweets_db.tweet_from_user, backtweets_db.tweet_profile_image_url, backtweets_db.tweet_created_at, backtweets_db.tweet_text, backtweets_db.newswire_id
				  FROM newswire_tb, backtweets_db WHERE backtweets_db.newswire_id=newswire_tb.id AND (newswire_tb.createdTime >= '".$date."' AND newswire_tb.createdTime < '".$date."' + INTERVAL 24 HOUR) ORDER BY newswire_tb.createdTime ASC ".$limitString );

$newsNode;
$tweetNode;
$id = -10;
$totalTweets = 0;
$totalNewsitems = 0;
while( $row = mysql_fetch_assoc( $result ) ) {
	//echo $row['id']." Headline: ".$row['headline']."  Tweet: ".$row['tweet_text'].'<br />';
	
	$totalTweets += 1;
	if ($id != $row['id']) {
		if ($id > -10) {
			if ($totalTweets >= $minTweets) {
				appendAttribute($doc, $newsNode, 'total', $totalTweets);
				appendAttribute($doc, $tweetNode, 'total', $totalTweets);
				$totalNewsitems  += 1;
				$root->appendChild( $newsNode );
			}
		}
		if ($limit > 0 && $totalNewsitems > $limit) {
			break;
		}
		$id = $row['id'];
		$totalTweets = 0;
		$newsNode = $doc->createElement('news_item');
		appendNewsNodeItems( $newsNode, $row );
		$tweetNode = $doc->createElement('tweets');
		$newsNode->appendChild( $tweetNode );
		
	}
	$newsitem_id = $row["id"];
	$newsitem_time = strtotime($row['createdTime']);
	
	$tweet = addTweet($row, $tweetNode);
	$tweetTime = strtotime($row['tweet_created_at']);
	
	$hours = floor( ($tweetTime - $newsitem_time ) / (60 * 60) );
	$minutes = (($tweetTime - $newsitem_time ) / 60) % 60;
	
	appendAttribute($doc, $tweet, 'hourDiff', $hours);
	appendAttribute($doc, $tweet, 'minDiff', $minutes);
	
}
appendAttribute($doc, $root, 'totalNewsItems', strval($totalNewsitems) );
echo $xml_string = $doc->saveXML();


function addTweet($tweetitem, $parentNode) {
	global $doc;
	$entry = appendElement($doc, $parentNode, 'tweet');
	
	$node = appendElement($doc, $entry, 'tweet_id');
	appendTextNode($doc, $node, ($tweetitem['tweet_id']));
	
	$node = appendElement($doc, $entry, 'tweet_from_user_id');
	appendTextNode($doc, $node, ($tweetitem['tweet_from_user_id']));
	
	$node = appendElement($doc, $entry, 'tweet_from_user');
	appendTextNode($doc, $node, ($tweetitem['tweet_from_user']));
	
	$node = appendElement($doc, $entry, 'tweet_profile_image_url');
	appendTextNode($doc, $node, ($tweetitem['tweet_profile_image_url']));
	
	$node = appendElement($doc, $entry, 'tweet_created_at');
	appendTextNode($doc, $node, ($tweetitem['tweet_created_at']));
	
	$node = appendElement($doc, $entry, 'tweet_text');
	appendTextNode($doc, $node, ($tweetitem['tweet_text']));
	
	$node = appendElement($doc, $entry, 'newswire_id');
	appendTextNode($doc, $node, ($tweetitem['newswire_id']));
	
	return $entry;
}

function appendNewsNodeItems( $newsNode, $newsitem ) {
	global $doc, $root;
	appendAttribute($doc, $newsNode, 'url', $newsitem['url']);
	appendAttribute($doc, $newsNode, 'id', $newsitem['id']);
	
	$sectionNode = appendElement($doc, $newsNode, 'section');
	appendTextNode($doc, $sectionNode, ($newsitem['section']));
	
	$headlineNode = appendElement($doc, $newsNode, 'headline');
	appendTextNode($doc, $headlineNode, urldecode($newsitem['headline']));
	
	$summaryNode = appendElement($doc, $newsNode, 'summary');
	appendTextNode($doc, $summaryNode, urldecode($newsitem['summary']));
	
	$byNode = appendElement($doc, $newsNode, 'byline');
	appendTextNode($doc, $byNode, ($newsitem['byline']));
	
	$updatedNode = appendElement($doc, $newsNode, 'updatedTime');
	appendTextNode($doc, $updatedNode, ($newsitem['updatedTime']));
	
	$createdNode = appendElement($doc, $newsNode, 'createdTime');
	appendTextNode($doc, $createdNode, ($newsitem['createdTime']));
	
	$pubNode = appendElement($doc, $newsNode, 'pubDate');
	appendTextNode($doc, $pubNode, ($newsitem['pubDate']));
}

function appendElement($doc, $parentNode, $nodeName) {
	$node = $doc->createElement($nodeName);
	$parentNode->appendChild($node);
	return $node;
}

function appendTextNode($doc, $parentNode, $value) {
	$parentNode->appendChild( $doc->createTextNode( $value ) );
}

function appendAttribute($doc, $node, $attName, $attVal) {
	// create attribute node
	$att = $doc->createAttribute( $attName );
	$node->appendChild( $att );
	
	// create attribute value node
	$val = $doc->createTextNode( $attVal );
	$att->appendChild( $val );
}


?>