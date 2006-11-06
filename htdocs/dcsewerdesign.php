<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<HTML>
  <HEAD>
    <TITLE>DC Water Design Extension</TITLE>
    <link rel="stylesheet" href="dcwaterdesign.css" type="text/css"/>
	<link rel="alternate" type="application/rss+xml" title="DC Water Design Extension News" href="http://sourceforge.net/export/rss2_projnews.php?group_id=21566&rss_fulltext=1" />
  </HEAD>
  <BODY bgcolor="#666657" text="#d1d1c9" LINK="#003767" ALINK="#c0c0c0" VLINK="#4185aa"
      marginwidth="0" marginheight="0" topmargin="0" leftmargin="0">
	  
    <table border=0 cellpadding=4 cellspacing=0 bgcolor="#666657" WIDTH="100%">

<tr>

<td align="left" style="width: 240px;">

 <A href="http://http://wasser-umwelt.dorsch.de/en/index.php">

<img src="images/logo.gif" width="239" height="98" border="0" alt="DORSCH Consult"> </A>

</td>
<td>
<table border="0" cellpadding="0" cellspacing="0" width="98%" height="22" align="center">

        <tr height="22">

                <td background="images/table_background.png" align="left" height="22" width="5"><img src="images/line.png" width="1" border="0" height="22" ALT=""></td>

                <td background="images/table_background.png" align="center" height="22"><A CLASS="header" HREF="http://sourceforge.net/projects/dcwaterdesign">Project Summary</a></td>

                <td background="images/table_background.png" align="center" height="22" width="5"><img src="images/line.png" width="1" border="0" height="22" ALT=""></td>

                <td background="images/table_background.png" align="center" height="22"><A CLASS="header" HREF="https://sourceforge.net/svn/?group_id=21566">SVN</a></td>

                <td background="images/table_background.png" align="center" height="22" width="5"><img src="images/line.png" width="1" border="0" height="22" ALT=""></td>

                <td background="images/table_background.png" align="center" height="22"><A CLASS="header" HREF="http://sourceforge.net/project/showfiles.php?group_id=21566">Download</a></td>

                <td background="images/table_background.png" align="center" height="22" width="5"><img src="images/line.png" width="1" border="0" height="22" ALT=""></td>

                <td background="images/table_background.png" align="center" height="22"><A CLASS="header" HREF="http://sourceforge.net/docman/?group_id=21566">Documentation</a></td>

                <td background="images/table_background.png" align="center" height="22" width="5"><img src="images/line.png" width="1" border="0" height="22" ALT=""></td>

                <td background="images/table_background.png" align="center" height="22"><A CLASS="header" HREF="http://sourceforge.net/project/stats/?group_id=21566&ugn=dcwaterdesign">Statistics</a></td>

                <td background="images/table_background.png" align="center" height="22" width="5"><img src="images/line.png" width="1" border="0" height="22" ALT=""></td>

        </tr>

</table>

</td></tr></table>

<img src="images/notebook.jpg" alt="DC Water Design Extension" width="1000" height="160" border="0" />

<div style="margin-left: 1em;" class="copy">
<h1 class="headline">DC Sewer Design Extension</h1>
      
      <p>The DC Sewer Design Extension adds the possibility to model
      simple sewer networks in ArcView 3.x and draw network profiles. 
      It is released under the the terms of the <a 
	href="http://www.gnu.org/copyleft/lesser.html" class="copylink">GNU Lesser General 
	Public License</a> (LGPL).</p>
	<p>The software is part of the <a href="index.php" class="copylink"
	  >DC Water Design Extension</a> suite of tools.</p>

      <h2 class="subnavihead">Documentation</h2>
      <p>A summary of features is available in the <a href=
        "dcsewerdesign_flyer.pdf" class="copylink">flyer</a> (PDF).</p>
      <p>The <a href="doc/en/index.html" class="copylink">manual</a>.</p>
      <h2 class="subnavihead">File Releases</h2>
      <?php 
    require_once 'rss_fetch.inc';
    $url =
      "http://sourceforge.net/export/rss2_projfiles.php?group_id=21566&rss_limit=10";
    @$rss = fetch_rss($url);
    if($rss) {
      foreach($rss->items as $item ) { 
	if(strpos($item["title"], "sewerdesign") > 0) { ?>
          <h3 class="subnavihead"><?php echo str_replace("dcsewerdesign", "DC Sewer Design Extension",
	    $item["title"]); ?></h3>
	  <p><?php echo $item["description"]; ?></p> <?php
        }
      } 
    } else { ?>
      <p class="important">RSS feed currently unavailable. Please check again
        later.</p> <?php
    } ?> 
    
    </div>
 <p class="copy" style="margin-left: 1em;">
  Copyright (c) 2001 - 2006 DC Water and Environment<br /><a href="imprint.html">Imprint</a>
</p>
<table border="0" cellpadding="4" cellspacing="0" bgcolor="#ffffff" width="100%">
<tr>
<td align="left" style="background-color: white; color: black;">
 <a href="http://sourceforge.net">
<img src="http://sourceforge.net/sflogo.php?group_id=21566&type=1" width="88" height="31" border="0" alt="SourceForge Logo" /> </a>
The DC Water Design Extension is kindly hosted by Sourceforge.net.
</td></tr></table></body></html>