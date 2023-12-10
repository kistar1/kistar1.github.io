<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=windows-1252">
	<style>
	.objimg
	{
		width:56px;
		vertical-align: middle;
	}
	#objects
	{
		overflow-y: scroll;
		background-color:White;
		border-width:1px;
		border-style:solid;
		border-color:black;
		text-align:center;
	}
	select {width:100%;}
	select:focus {width:100%;}
	body
	{
		background-color:ButtonFace;
		overflow: hidden;
	}
	.a{
		color: white;
		display:inline-block;
		*zoom: 1;
		*display: inline;
		border:white 2px solid;
		width:60px;
		height:60px;
		display: table-cell; 
		vertical-align: middle;
	}
	.asset
	{
		display:inline-block;
		*zoom: 1;
		*display: inline;
		height: 56px;
		line-height: 56px;
		margin: 10px 10px 10px 10px;
		width: 56px;
		vertical-align: middle;
	}
	a
	{
		color:blue;
		text-decoration: underline;
	}
	img{text-decoration: none; border: 0px; vertical-align: middle;}
	</style>
	<script>	
	
	
	
	
	function XML2JSON(link) {
        var xhttp = readyAjax();
		if(xhttp)
		{
			xhttp.open("GET", "tojson.php?link="+link, false);
			xhttp.send(null);  
			return JSON.parse(xhttp.responseText);
		}
    }
	

	
	
	var JSON = JSON || {};

// implement JSON.stringify serialization

JSON.stringify = JSON.stringify || function (obj) {

var t = typeof (obj);
if (t != "object" || obj === null) {

    // simple data type
    if (t == "string") obj = '"'+obj+'"';
    return String(obj);

}
else {

    // recurse array or object
    var n, v, json = [], arr = (obj && obj.constructor == Array);

    for (n in obj) {
        v = obj[n]; t = typeof(v);

        if (t == "string") v = '"'+v+'"';
        else if (t == "object" && v !== null) v = JSON.stringify(v);

        json.push((arr ? "" : '"' + n + '":') + String(v));
    }

    return (arr ? "[" : "{") + String(json) + (arr ? "]" : "}");
}
};


if(typeof String.prototype.trim !== 'function') {
  String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, ''); 
  }
}

// implement JSON.parse de-serialization
JSON.parse = JSON.parse || function (str) {
if (str === "") str = '""';
eval("var p=" + str + ";");
return p;
 };
	
	
	
		function readyAjax()
		{
			try{
				return new ActiveXObject("Microsoft.XMLHTTP");
			}
			catch(ex1)
			{
				try{
				return new XMLHttpRequest();
				}
				catch(ex)
				{
					alert("Could not create ajax");
					return false;
				}
			}
		}
	
	
		var currentpage = 0;
		var pgamount = 0;
		var scode = "";
		function sendAJAX(searchvar, pages, usescode)
		{
			if(typeof usescode !== 'undefined' && usescode == true)
			{
				searchvar = scode;
			}
			var andpage = "";
			if (typeof pages !== 'undefined') {
						if(pages <= pgamount && pages >= 0)
							andpage = "&pagenum=" + pages;
						else
							andpage = "";
			}
			if(document.getElementById("selection").selectedIndex >= 9)
				document.getElementById("search").style.visibility = "visible";
			else
				document.getElementById("search").style.visibility = "hidden";
			var xhttp = readyAjax();
			if(xhttp)
			{
					document.getElementById("objects").innerHTML = "";
					var page = document.getElementById("selection").selectedIndex
					if (typeof searchvar !== 'undefined') {
						if(searchvar.trim() !== "")
							xhttp.open("POST", "getassets.php?page="+page+"&search="+encodeURI(searchvar.trim()+andpage), true);
						else
							xhttp.open("POST", "getassets.php?page="+page+andpage, true);
					}
					else
					{
						xhttp.open("POST", "getassets.php?page="+page, true);
					}
					
					//xhttp.open("GET", "bricks.json", true);
					xhttp.send(null);  
					xhttp.onreadystatechange = function() {
						if (xhttp.readyState == 4 && xhttp.status == 200) {
						  var go = true;
						  try{
						  var jsonOutcome = JSON.parse(xhttp.responseText);
						  }catch(ex)
						  {
						  document.getElementById("objects").innerHTML = "Page is missing or down for maintainance";
						  var go = false;
						  }
						  if(go)
						  if("pages" in jsonOutcome)
						  {
							currentpage = jsonOutcome.curpage;
							pgamount = jsonOutcome.pages;
							document.getElementById("curpage").innerHTML = currentpage+1;
							document.getElementById("pages").style.visibility = "visible";
							document.getElementById("pagetotal").innerHTML = pgamount+1;
							if(currentpage == 0)
								document.getElementById("prev").style.display = "none";
							else
								document.getElementById("prev").style.display = "";
								
							if(currentpage == pgamount)
								document.getElementById("next").style.display = "none";
							else
								document.getElementById("next").style.display = "";
						  }
						  else
						  {
							document.getElementById("pages").style.visibility = "hidden";
						  }
						  for(var i = 0; i < jsonOutcome.assets.length; i++)
						  {
							var img = new Image();
							if("img" in jsonOutcome.assets[i])
								img.src = jsonOutcome.assets[i].img;
							else if(jsonOutcome.assets[i].type === "normal")
								img.src = 'http://androdome.com/ide/asset/asset'+jsonOutcome.assets[i].id+'.png';
							else if(jsonOutcome.assets[i].type === "script")
								img.src = 'http://androdome.com/ide/asset/script.png';
							else if(jsonOutcome.assets[i].type === "bin")
								img.src = 'http://androdome.com/ide/asset/bin.png';
							else if(jsonOutcome.assets[i].type === "sound")
								img.src = 'http://androdome.com/ide/asset/sound.png';
							else if(jsonOutcome.assets[i].type === "moderated")
								img.src = 'http://androdome.com/ide/asset/content_moderated.png';
							else
								img.src = 'http://androdome.com/ide/asset/unavail.png';
							document.getElementById("objects").innerHTML = document.getElementById("objects").innerHTML + '<div class="asset" title="'+jsonOutcome.assets[i].name+'" ><div class="a" onclick="insertItem(\''+jsonOutcome.assets[i].id+'\', \''+jsonOutcome.assets[i].type+'\')" onmouseover="mouseover(this)" onmouseout="mouseout(this)"><table width="56px" height="56px"><tr><th><img class="objimg" ondragstart="startDrag(\''+jsonOutcome.assets[i].id+'\', \''+jsonOutcome.assets[i].type+'\');" alt="'+jsonOutcome.assets[i].name+'" src="' + img.src + '"/></th></tr></table></div></div>';
						  }
						  if(typeof jsonOutcome !== undefined)
						  try{
							  if(jsonOutcome.assets.length <= 0)
							  {
								document.getElementById("objects").innerHTML = "Result not found.";
							  }
							  }
							  catch(ex){}
						}
					};
			}
			else
			{
			alert("Your browser doesn't support AJAX.");
			}
		}
		
	
		function insertItem(item, type)
		{
			if(type !== "moderated")
			{
					window.external.Insert("http://androdome.com/ide/asset/?id=" + item );
					
			}
			else
			{
				alert("Could not insert item");
			}
		}
		
		function startDrag(item, type)
		{
			if(type !== "moderated")
			{
				try{
					window.external.StartDrag("http://androdome.com/ide/asset/?id=" + item);
				}
				catch(e)
				{
					insertItem(item, type);
				}
			}
			else
			{
				alert("Could not insert item");
			}
		}
		
		function mouseover(item)
		{
			item.style.borderStyle = "outset";
			item.style.borderWidth = "2px";
			item.style.borderColor = "white";
			var elementToChange = document.getElementsByTagName("body")[0];
			elementToChange.style.cursor = "pointer";
		}
		function mouseout(item)
		{
			item.style.borderStyle = "solid";
			item.style.borderWidth = "2px";
			item.style.borderColor = "white";
			var elementToChange = document.getElementsByTagName("body")[0];
			elementToChange.style.cursor = "auto";
		}

		
		function onKeySearch(value, event)
		{
			if (event.keyCode == 13)
			{
				scode = value;
				sendAJAX(value);
			}
		}

		
	</script>
	
	
	</head>
	<body onload="sendAJAX()" oncontextmenu="return false" style="cursor: auto;">
	<table style="height:100%; display:block;" height="100%">
		<tbody><tr><td style="height:15px;">
		<select onchange="sendAJAX()" id="selection" style="border: solid 2px Window;">
			<option selected="selected">Bricks</option>
			<option>Robots</option>
			<option>Chassis</option>
			<option>Tools</option>
			<option>Furniture</option>
			<option>Roads</option>
			<option>Skyboxes</option>
			<option>Billboards</option>
			<option>Game 
Objects&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
			<option>My Decals</option>
			<option>Free Decals</option>
			<option>My Models</option>
			<option>Free Models</option>
		</select>
		</td></tr><tr><td style="height:15px;">
		<div id="search" style="visibility: hidden;">Search:<input type="text" onkeypress="onKeySearch(this.value, event);" id="srchbox"></div>
		</td></tr><tr>
		<td style="height: 100%"><div style="width:100%;height: 100%" id="objects"><div class="asset" title="Reddish brown 2x4"><div class="a" onclick="insertItem('1', 'normal')" onmouseover="mouseover(this)" onmouseout="mouseout(this)"><table width="56px" height="56px"><tbody><tr><th><img class="objimg" ondragstart="startDrag('1', 'normal');" alt="Reddish brown 2x4" src="clienttoolbox_files/content_moderated.png"></th></tr></tbody></table></div></div><div class="asset" title="Black 2x4"><div class="a" onclick="insertItem('2', 'normal')" onmouseover="mouseover(this)" onmouseout="mouseout(this)"><table width="56px" height="56px"><tbody><tr><th><img class="objimg" ondragstart="startDrag('2', 'normal');" alt="Black 2x4" src="clienttoolbox_files/asset2.png"></th></tr></tbody></table></div></div><div class="asset" title="Dark grey 2x4"><div class="a" onclick="insertItem('3', 'normal')" onmouseover="mouseover(this)" onmouseout="mouseout(this)"><table width="56px" height="56px"><tbody><tr><th><img class="objimg" ondragstart="startDrag('3', 'normal');" alt="Dark grey 2x4" src="clienttoolbox_files/asset3.png"></th></tr></tbody></table></div></div><div class="asset" title="Medium stone grey 2x4"><div class="a" onclick="insertItem('4', 'normal')" onmouseover="mouseover(this)" onmouseout="mouseout(this)"><table width="56px" height="56px"><tbody><tr><th><img class="objimg" ondragstart="startDrag('4', 'normal');" alt="Medium stone grey 2x4" src="clienttoolbox_files/asset4.png"></th></tr></tbody></table></div></div><div class="asset" title="Grey 2x4"><div class="a" onclick="insertItem('5', 'normal')" onmouseover="mouseover(this)" onmouseout="mouseout(this)"><table width="56px" height="56px"><tbody><tr><th><img class="objimg" ondragstart="startDrag('5', 'normal');" alt="Grey 2x4" src="clienttoolbox_files/asset5.png"></th></tr></tbody></table></div></div><div class="asset" title="Earth orange 2x4"><div class="a" onclick="insertItem('6', 'normal')" onmouseover="mouseover(this)" onmouseout="mouseout(this)"><table width="56px" height="56px"><tbody><tr><th><img class="objimg" ondragstart="startDrag('6', 'normal');" alt="Earth orange 2x4" src="clienttoolbox_files/asset6.png"></th></tr></tbody></table></div></div><div class="asset" title="Bright blue 2x4"><div class="a" onclick="insertItem('7', 'normal')" onmouseover="mouseover(this)" onmouseout="mouseout(this)"><table width="56px" height="56px"><tbody><tr><th><img class="objimg" ondragstart="startDrag('7', 'normal');" alt="Bright blue 2x4" src="clienttoolbox_files/asset7.png"></th></tr></tbody></table></div></div><div class="asset" title="Sand green 2x4"><div class="a" onclick="insertItem('8', 'normal')" onmouseover="mouseover(this)" onmouseout="mouseout(this)"><table width="56px" height="56px"><tbody><tr><th><img class="objimg" ondragstart="startDrag('8', 'normal');" alt="Sand green 2x4" src="clienttoolbox_files/asset8.png"></th></tr></tbody></table></div></div><div class="asset" title="Dark green 2x4"><div class="a" onclick="insertItem('9', 'normal')" onmouseover="mouseover(this)" onmouseout="mouseout(this)"><table width="56px" height="56px"><tbody><tr><th><img class="objimg" ondragstart="startDrag('9', 'normal');" alt="Dark green 2x4" src="clienttoolbox_files/asset9.png"></th></tr></tbody></table></div></div><div class="asset" title="Bright red 2x4"><div class="a" onclick="insertItem('10', 'normal')" onmouseover="mouseover(this)" onmouseout="mouseout(this)"><table width="56px" height="56px"><tbody><tr><th><img class="objimg" ondragstart="startDrag('10', 'normal');" alt="Bright red 2x4" src="clienttoolbox_files/asset10.png"></th></tr></tbody></table></div></div><div class="asset" title="Bright orange 2x4"><div class="a" onclick="insertItem('11', 'normal')" onmouseover="mouseover(this)" onmouseout="mouseout(this)"><table width="56px" height="56px"><tbody><tr><th><img class="objimg" ondragstart="startDrag('11', 'normal');" alt="Bright orange 2x4" src="clienttoolbox_files/asset11.png"></th></tr></tbody></table></div></div><div class="asset" title="Bright yellow 2x4"><div class="a" onclick="insertItem('12', 'normal')" onmouseover="mouseover(this)" onmouseout="mouseout(this)"><table width="56px" height="56px"><tbody><tr><th><img class="objimg" ondragstart="startDrag('12', 'normal');" alt="Bright yellow 2x4" src="clienttoolbox_files/asset12.png"></th></tr></tbody></table></div></div><div class="asset" title="Brick yellow 2x4"><div class="a" onclick="insertItem('13', 'normal')" onmouseover="mouseover(this)" onmouseout="mouseout(this)"><table width="56px" height="56px"><tbody><tr><th><img class="objimg" ondragstart="startDrag('13', 'normal');" alt="Brick yellow 2x4" src="clienttoolbox_files/asset13.png"></th></tr></tbody></table></div></div><div class="asset" title="Light yellow 2x4"><div class="a" onclick="insertItem('14', 'normal')" onmouseover="mouseover(this)" onmouseout="mouseout(this)"><table width="56px" height="56px"><tbody><tr><th><img class="objimg" ondragstart="startDrag('14', 'normal');" alt="Light yellow 2x4" src="clienttoolbox_files/asset14.png"></th></tr></tbody></table></div></div><div class="asset" title="White yellow 2x4"><div class="a" onclick="insertItem('15', 'normal')" onmouseover="mouseover(this)" onmouseout="mouseout(this)"><table width="56px" height="56px"><tbody><tr><th><img class="objimg" ondragstart="startDrag('15', 'normal');" alt="White yellow 2x4" src="clienttoolbox_files/asset15.png"></th></tr></tbody></table></div></div></div>
		</td>
		</tr><tr><td style="height:15px;">
		<div id="pages" align="center" style="visibility: hidden;"><a id="prev" onclick="currentpage--;sendAJAX(null, currentpage, true);">&lt;Previous</a> Page <span id="curpage">0</span> of <span id="pagetotal">0</span> <a id="next" onclick="currentpage++;sendAJAX(null, currentpage, true);">Next&gt;</a>
		</div></td></tr>
	</tbody></table>	
	
</body></html>