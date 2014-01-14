chrome.app.runtime.onLaunched.addListener(function() {
  chrome.app.window.create('pub.html',
    {id: 'pub', bounds: {width: 1000, height: 650}});
});
