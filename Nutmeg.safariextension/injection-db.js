var NavNode = function(root, parentTitle, parentURL, childURL) {
    this.root = root;
    this.parentTitle = parentTitle;
    this.parentURL = parentURL;
    this.childURL = childURL;
    this.visitTime = new Date();
}

var TrickleNode = function(root) {
    this.root = root;
    this.childURLs = [];
}

function wasClicked(element) {
    safari.self.tab.dispatchMessage("newNavNode", new NavNode("all-browsing", parentWindowURL, parentWindowURL, element.href));
    if (rootNode) safari.self.tab.dispatchMessage("newNavNode", new NavNode(rootNode, parentWindowURL, parentWindowURL, element.href)); // If not null send new Node object
}

function handleMessage(msgEvent) {
    if (msgEvent.name === "tag") {
        rootNode = msgEvent.message;
    } else if (msgEvent.name === "newTree") {
        console.log(parentWindowURL);
        if (!blacklistCheck(parentWindowURL)) return;
        rootNode = msgEvent.message;
        safari.self.tab.dispatchMessage("newNavNode", new NavNode("all-browsing", parentWindowURL, parentWindowURL, null));
        safari.self.tab.dispatchMessage("newNavNode", new NavNode(rootNode, parentWindowURL, parentWindowURL, null));
    } else if (msgEvent.name === "burn") {
        if (rootNode == msgEvent.message) rootNode = null;
    } else if (msgEvent.name === "catch") {}
}

function blacklistCheck(url) {
    if (!url) return false;
    if (blacklistComplete.indexOf(url) != -1) return false;
    for (var i = 0; i < blackListIncomplete.length; i++) {
        if (url.includes(blackListIncomplete[i])) return false;
    }
    return true;
}

var parentWindowURL, parentWindowTitle;

try {
    parentWindowURL = parent.document.URL;
    if (!blacklistCheck(parentWindowURL)) {
        parentWindowURL = null;
        break;
    }
    parentWindowTitle = (document.title ? document.title : document.URL.split("/")[2]);

    var possibleFrames = document.getElementsByTagName("iframe");
    var frameSrcs = [];
    for (var i = 0; i < possibleFrames.length; i++) {
        if (blacklistCheck(possibleFrames[i].src)) frameSrcs.push(possibleFrames[i].src);
    }
    var trickleNode = new TrickleNode(document.URL);
    trickleNode.childURLs = frameSrcs;
    safari.self.tab.dispatchMessage("newTrickleNode", trickleNode);
} catch (e) {
    console.log("Within iFrame");
}

if (parentWindowURL) {
    var rootNode = null;
    var blacklistComplete = ["", "#", "about:blank", "AddThis Utility Frame", "javascript:void(0)"];
    var blackListIncomplete = ["googleads.g.doubleclick.net", "googlesyndication"];

    var links = document.links;

    for (var i = 0; i < links.length; i++) { // Injects function into each link
        if (links[i].href && links[i].href != parentWindowURL && blacklistCheck(links[i].href) {
                links[i].addEventListener("click", function() {
                    wasClicked(this);
                });
            }
        }
    }

    safari.self.addEventListener("message", handleMessage, false);
