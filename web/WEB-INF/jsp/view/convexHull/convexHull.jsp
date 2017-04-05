<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    												pageEncoding="UTF-8" %>
    												    												
<!doctype html>

<html lang="en">
<head>
<meta charset="utf-8">
<title>Convex Hull using Jarvis march</title>
<link rel="stylesheet"
              href="<c:url value="/resources/stylesheet/chDemo.css" />" />
            
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

<script>
"use strict";

/*
Javascript demonstration of Jarvis march algorithm
A random set of points is generated then the Jarvis march is executed as an animation loop. The algorithm setup is created by the function JarvisMarch(points) that calls
the functin step() for animation
*/


var Debugger = function() { };// create  object
  Debugger.log = function(message) {
  try {
    console.log(message);
  } catch(exception) {
    return;
  }
}


function canvasSupport() {
  return !!document.createElement('canvas').getContext;
} 

function canvasApp() {
	
	function PointMsg(index, xpos, ypos) {
		this.index = index;
	    this.xpos = xpos; 
	    this.ypos = ypos;
	}

  function Point(name) {
    this.mName = name;
    this.xPos = 0; 
    this.yPos = 0;
  }// Point

  function drawPoint(point) {
    var xa = point.xPos - 5;
    var xb = point.xPos + 5;
    var ya = point.yPos - 5;
    var yb = point.yPos + 5;

    context.lineWidth = 2;
    context.strokeStyle = "black";     
    context.beginPath();
    context.moveTo(xa, point.yPos);
    context.lineTo(xb, point.yPos);
    context.stroke();
    context.closePath();
    context.beginPath();
    context.moveTo(point.xPos, ya);
    context.lineTo(point.xPos, yb);
    context.stroke();
    context.closePath();  
    var roff = 5;
    setTextStyle();
    context.fillText(point.mName, point.xPos + roff, point.yPos - roff);      
  }// drawPoint
 
  // get canvas context
  if (!canvasSupport) {
    alert("canvas not supported");
    return;
  } else {
    var theCanvas = document.getElementById("canvas");
    var context = theCanvas.getContext("2d");
  }

  var xMin = 0;
  var yMin = 0;
  var xMax = theCanvas.width;
  var yMax = theCanvas.height; 
 
  var delay = 1000;// for animation only
  
  var result;

  var Npoints = 30;
  
  var S = [];

  var limit = 0;
  
  var points;
  var pointList;

  function setTextStyle() {
    context.fillStyle    = '#000000';
    context.font         = '12px _sans';

  }

  function fillBackground() {
    // draw background
    context.fillStyle = '#ffffff';
    context.fillRect(xMin, yMin, xMax, yMax);    
  }// fillBackground

  	
	function distance(p1, p2) {
	    
	  	var dist = Math.sqrt(Math.pow(p1.xPos-p2.xPos, 2) + Math.pow(p1.yPos-p2.yPos, 2));
	    
	  	return dist;
	  
  	}// distance

  
  function redraw(points, S) {
    // draw all points, connect only points in S according to S sequence
    fillBackground();
    for (var i = 0; i < points.length; i++) {
      drawPoint(points[i]);
    }
    for (var i = 0; i < S.length-1; i++) {
      drawSegment(S[i], S[i+1], "black");
    }
  }// redraw

  function randomize(Npoints) {
    var count = 0;
    var points = [];
    var x, y;
    var dmin = 20;

    var toto = [];
	toto[0] =  [116, 362];

	toto[1] = [178, 62];
	toto[2] = [599, 319];
	toto[3] = [148, 360];
	toto[4] = [607, 211];
	toto[5] = [403,  75];

	toto[6] = [351, 125];
	toto[7] = [555, 533];
	toto[8] = [129, 87];
	toto[9] = [252, 406];
	toto[10] = [153, 291];
	toto[11] = [172, 464];
	toto[12] = [454, 302];

	toto[13] = [527, 176];
	toto[14] = [555, 263];
	toto[15] = [129, 547];
	toto[16] = [130, 320];
	toto[17] = [210, 494];
	toto[18] = [418, 242];
	toto[19] = [641, 292];
	toto[20] = [356, 531];
	
	toto[21] = [567, 197];
	toto[22] = [235, 248];
	toto[23] = [630, 207];
	toto[24] = [177, 136];
	toto[25] = [265, 94];
	toto[26] = [521, 299];
	toto[27] = [84, 401];
	toto[28] = [55, 100];
	toto[29] = [100, 61];
	
	/*
	for (var i = 0; i < Npoints; i++) {
		var point = new Point("p" + i);
		point.xPos = toto[i][0];
		point.yPos = toto[i][1];
		point.mIndex = i;
		points.push(point);
	}
	*/
	
	var ind = 0;
	 
    while (points.length < Npoints) {
      // generate random point
      x = Math.floor(Math.random() * 600) + 50;// range
      y = Math.floor(Math.random() * 500) + 50;// range
      var point = new Point("p" + count);
      point.xPos = x;
      point.yPos = y;
      var i = 0;
      // check minimal distance to all existing points
      for (i = 0; i < points.length; i++) {
        if (distance(point, points[i]) < dmin) { 
          break; 
        } 
      }// for
      if (i == points.length) {
		point.mIndex = ind++;
        points.push(point);// accept point
      } else { 
        continue;// reject point 
      }
      count++;
    }
    

    fillBackground();

    for (var i = 0; i < points.length; i++) {
      drawPoint(points[i]);
    }
   
 	$('#CHStep').find(':submit')[0].disabled = false;
	$('#status').text('Ready to compute the convex hull');
  
    	return points;
  	}// randomize 
 
  
  	function drawSegment(p1, p2, color) {
    	context.lineWidth = 2;
    	context.strokeStyle = color;     
    	context.beginPath();
    	context.moveTo(p1.xPos, p1.yPos);
    	context.lineTo(p2.xPos, p2.yPos);
    	context.stroke();
    	context.closePath();
  	}// drawSegment

  
  	function jarvisMarchStep() {
	  	console.log("fucking jarvisStep");
	  
	  	var message = {"type":"STEP"};
	  
	  	$.ajax({
			type : "POST",
			contentType : "application/json",
			url : '<c:url value="/scanStep" />',
			data : JSON.stringify(message),
			dataType : 'json',
			timeout : 100000,
			success : function(data) {
				console.log("STEP SUCCESSFUL");
				
				if (data["status"] == "STEP" || data["status"] == "FINISHED" 
												|| data["status"] == "REDRAW") {
					
					console.log("jackpot");
					
					result = data["snapshot"];
					
					var currentVertex = result["currentVertex"];
					var cand = result["cand"];
					
					if (S.length == 0) {
						S.push(points[currentVertex]);
					}
					
					if (data["status"] == "STEP") {
						console.log("current vertex " + currentVertex);
				
						console.log("candidate " + cand);
						drawSegment(points[currentVertex], points[cand], "green");
					} else if (data["status"] == "REDRAW") {
						console.log("newFoundVertex " + currentVertex);
			
						S.push(points[currentVertex]);
						redraw(points, S);
		
					} else  {// finished
						redraw(points, S);
					    drawSegment(S[S.length-1], S[0], "black"); 						
					}// if
					
					if (data["status"] == "FINISHED") {
						$('#CHStep').find(':submit')[0].disabled = true;
						$('#status').text('Convex hull completed'); 
					} else {
					 	$('#CHStep').find(':submit')[0].disabled = false;
						$('#status').text('Building the convex hull');
					}// if
					
				}// if
			},
				
			error : function(e) {
				console.log("ERROR: ", e);
			},
			done : function(e) {
				console.log("DONE");
			}
		});
	  
	  
	  	console.log("jarvisStep completed");
  	}// jarvisMarchStep
  
  
  	function init() {

		points = randomize(Npoints);
	  		
	  	var data = [];
	  
	  	for (var i = 0; i < points.length; i++) {
	  		data.push(new PointMsg(points[i].mIndex, points[i].xPos, points[i].yPos))
	  	}
	  	
	  	
	  	var message = {"points":data};
	  
	  	$.ajax({
			type : "POST",
			contentType : "application/json",
			url : '<c:url value="/initPoints" />',
			data : JSON.stringify(message),
			dataType : 'json',
			timeout : 100000,
			success : function(data) {
				console.log("INIT SUCCESSFUL");
				
				S = [];
			},
				
			error : function(e) {
				console.log("ERROR: ", e);
			},
			done : function(e) {
				console.log("DONE");
			}
		});
	  
	}// init

    
  	init();

	$("#CHStep").submit(function(event) { jarvisMarchStep(); return false; });
	$("#initelem").submit(function(event) { points = randomize(Npoints); init(); return false});

	$('#initelem').find(':submit')[0].disabled = false;
  
}// canvasApp

$(document).ready(canvasApp);

</script>
</head>

<body>

<nav>
<br>

<br><br>
</nav>

<header id="intro">
<h1>Convex Hull of a set of points using Jarvis march algorithm</h1>
<p>I present here a Java based demonstration of the Jarvis march that finds the convex hull of a given set of points.<br>
I follow closely the approach of Cormen in his classical textbook.</p>
<h2>Explanations</h2>
<p>The points are randomly generated (browser).<br>
The points collection is sent to the server as a JSON object.<br/>
A reference point is selected, then the convex hull vertices are found successively in counterclockwise order using the Jarvis march (server).<br/>
At each step the current vertex and candidate are sent to the browser as a JSON object.<br/>
All candidate points are temporarily connected in green to the current vertex.<br/> 
The convex hull itself is drawn in black. You can interactively randomize by clicking the button.</p>
</header>

<div id="display">
  <canvas id="canvas" width="700" height="600">
    Your browser does not support HTML 5 Canvas
  </canvas>
<footer>
<p>Dominique Ubersfeld, Cachan, France</p>
</footer> 
 
</div>

<div id="controls">
  <div id="ConvexHull">
      <p>Click here to start building the convex hull</p>
    
       <form name="CHStep" id="CHStep">
        <input type="submit" name="CH-btn" value="Convex hull step">
      </form>
    </div>
    <div id="randomize">
      <p>Click here to randomize the points distribution</p>
      <form name="initialize" id="initelem">
        <input type="submit" name="randomize-btn" value="Randomize">
      </form>
    </div>
    <div id="msg">
      <p id="status"></p>
    </div> 
</div>

</body>

</html>