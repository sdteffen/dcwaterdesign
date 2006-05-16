<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
  <head>
    <title>DC Sewer Design Extension</title>
    <link rel="stylesheet" href="dcwaterdesign.css" type="text/css"/>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
  </head>
  <body>
    <div class="dcmms">
      <h1>DC Sewer Design Extension</h1>
      
      <p>The DC Sewer Design Extension is released under the the terms of the <a 
	href="http://www.gnu.org/copyleft/lesser.html">GNU Lesser General 
	Public License</a> (LGPL).</p>

      <h2>Documentation</h2>
      <p>A summary of features is available in the <a href=
        "dcsewerdesign_flyer.pdf">flyer</a> (PDF).</p>
      <p>The <a href="doc/en/index.html">manual</a>.</p>
      <h2>File Releases</h2>
      <?php 
    require_once 'rss_fetch.inc';
    $url =
      "http://sourceforge.net/export/rss2_projfiles.php?group_id=21566&rss_limit=10";
    @$rss = fetch_rss($url);
    if($rss) {
      foreach($rss->items as $item ) { 
	if(strpos($item["title"], "sewerdesign") > 0) { ?>
          <h3><?= str_replace("dcsewerdesign", "DC Sewer Design Extension",
	    $item["title"]); ?></h3>
	  <p><?= $item["description"]; ?></p> <?php
        }
      } 
    } else { ?>
      <p class="important">RSS feed currently unavailable. Please check again
        later.</p> <?php
    } ?> 
    <hr />
      <p>Back to the <a href="index.php">DC Water Design Extension</a> page.</p>
    </div>
  <p class="footer">$Date$ <a href=
   "mailto:Steffen_Macke@dorsch.com.jo">Steffen Macke 
   &lt;Steffen_Macke@dorsch.com.jo&gt;</a></p>
 </body>
</html>
