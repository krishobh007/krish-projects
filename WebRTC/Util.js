//common function for logging
function trace(text) {
	  if (text[text.length - 1] == '\n') {
	    text = text.substring(0, text.length - 1);
	  }
	  console.log((performance.now() / 1000).toFixed(3) + ": " + text);
}


