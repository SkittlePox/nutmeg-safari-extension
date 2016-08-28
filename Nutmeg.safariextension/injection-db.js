var NavNode = function(root, parentTitle, parentURL, childURL) {
    this.root = root;
    this.parentTitle = parentTitle;
    this.parentURL = parentURL;
    this.childURL = childURL;
    this.visitTime = new Date();
}

function wasClicked(element) {
    safari.self.tab.dispatchMessage("newNode", new NavNode("all-browsing", parentWindowURL, parentWindowURL, element.href));
    if (rootNode) safari.self.tab.dispatchMessage("newNode", new NavNode(rootNode, parentWindowURL, parentWindowURL, element.href)); // If not null send new Node object
}

function handleMessage(msgEvent) {
    if (msgEvent.name === "tag") {
        rootNode = msgEvent.message;
    } else if (msgEvent.name === "newTree") {
        console.log(parentWindowURL);
        if (!blacklistCheck(parentWindowURL)) return;
        rootNode = msgEvent.message;
        safari.self.tab.dispatchMessage("newNode", new NavNode("all-browsing", parentWindowURL, parentWindowURL, null));
        safari.self.tab.dispatchMessage("newNode", new NavNode(rootNode, parentWindowURL, parentWindowURL, null));
    } else if (msgEvent.name === "burn") {
        if (rootNode == msgEvent.message) rootNode = null;
    }
}

function blacklistCheck(url) {
    if(!url) return false;
    if (blacklistComplete.indexOf(url) != -1) return false;
    for (var i = 0; i < blackListIncomplete.length; i++) {
        if (url.includes(blackListIncomplete[i])) return false;
    }
    return true;
}

var parentWindowURL;
var parentWindowTitle;

if (window.top === window) {
    sessionStorage.setItem("nutmeg-rootURL", document.URL);
    sessionStorage.setItem("nutmeg-rootTitle", document.title);
}

parentWindowURL = sessionStorage.getItem("nutmeg-rootURL");
parentWindowTitle = sessionStorage.getItem("nutmeg-rootTitle");

var rootNode = null;
var blacklistComplete = ["", "#", "about:blank", "AddThis Utility Frame"];
var blackListIncomplete = ["googleads.g.doubleclick.net", "googlesyndication"];

var links = document.getElementsByTagName("a");

for (var i = 0; i < links.length; i++) { // Injects function into each link
    // console.log(document.URL);
    if (links[i].href && links[i].href != parentWindowURL && blacklistCheck(links[i].href) && blacklistCheck(parentWindowURL)) {
        links[i].addEventListener("click", function() {
            wasClicked(this);
        });
    }
}

safari.self.addEventListener("message", handleMessage, false);
