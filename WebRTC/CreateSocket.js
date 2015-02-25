var appendElemnt=1;
var configuration={"iceServers":[{"url":"stun:stun.l.google.com:19302"}]}; 
var constraints={"optional":[{"DtlsSrtpKeyAgreement":true}]};
pc=new RTCPeerConnection(configuration,constraints);

// Create websocket for signaling between two peers.
var createSocket = function (){
	var ws_uri = "ws://reliance.clt.qburst.in:9000/websocket/chat_app";
			if ("WebSocket" in window) {
               webSocket = new WebSocket(ws_uri);
            }
            else {
               // Firefox 7/8 currently prefixes the WebSocket object
               webSocket = new MozWebSocket(ws_uri);
            }
			
            webSocket.onmessage = function(e) {
               	console.log("Got echo: " + e.data);
               	var data2=JSON.parse(e.data);
               	console.log(data2);
               	
               	var from = data2.from;
				var to = data2.to;
				var data1 = data2.message;
				console.log(from+to+data1);
				
				if(data1=="hi,"+from+" have Joined!"){
				
					console.log("Remote userId "+from);
					console.log("Local userId "+to);
					remoteUser=from;
					if(appendElemnt){
						
						var html="<div class='user-dtls'><div class='list-btn' ></div><div class='user-profile-pic'><img src='/assets/chat-list-img.png'/></div><div class='active-user-dtls'><span class='uname'>"+from+"</span><br/><span class='status-msg'>webrtc :)</span></div><div class='callbtn'><button class='call-grn' onclick='start()'></button></div><br clear='all'></div>";	
																	
						document.getElementById('chatList').innerHTML +=html ;
						appendElemnt=0;
					}
				}
				else {
					data1=JSON.parse(data1);
					
					console.log(data1);
					if(data1.type=="flag"){
						isCaller = data1.value;
					}
		
					// for the caller section
					if(isCaller){
				 		console.log("caller page");
						if(data1.sdpMLineIndex=="0" && to==USER_ID){
		         				call(data1);
		         			}
						if(data1.type=="answer" && to==USER_ID){
		               				console.log(data1.type);
		               				getAnswer(data1);
		         			}
					}
	
					// for the callee section
					else{
						console.log("callee page");
						if(data1.sdpMLineIndex=="0" && to==USER_ID){
		         				call(data1);
		         			}
						if(data1.type=="offer" && to==USER_ID){
					
							if(startFlag){
								var r=confirm("Answer call from "+from);
								if (r==true){
		         					remoteUser=from;
									console.log(data1.type);
		               				getOffer(data1);
		               				
		               				sendAnswer();
		               				start();
		  						}
								else{
		  							console.log("Rejected call");
		  						}
		  					}
		  					else{
		  						remoteUser=from;
								console.log(data1.type);
		               			getOffer(data1);
		               			sendAnswer();
		  					}
		         		}
					}
	            }
            }
            webSocket.onopen = function(e) {
            	var msg2='broadcast';
                var msg = {"from":USER_ID, "to":msg2, "message":"hi,"+USER_ID+" have Joined!"};
                webSocket.send(ROOM_ID+"#!#"+JSON.stringify(msg));
            }
};