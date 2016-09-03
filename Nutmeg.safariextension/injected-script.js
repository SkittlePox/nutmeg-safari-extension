var NavNode = function(root, parentTitle, parentURL, childURL) {
    this.root = root;
    this.parentTitle = parentTitle;
    this.parentURL = parentURL;
    this.childURL = childURL;
    this.visitTime = new Date();
}

function blacklistCheck(url) {
    if (!url) return false;
    if (blacklistComplete.indexOf(url) != -1) return false;
    for (var i = 0; i < blackListIncomplete.length; i++) {
        if (url.includes(blackListIncomplete[i])) return false;
    }
    return true;
}

function wasClicked(element) {
    safari.self.tab.dispatchMessage("newNavNode", new NavNode("all-browsing", parentWindowTitle, parentWindowURL, element.href));
    if (rootNode) safari.self.tab.dispatchMessage("newNavNode", new NavNode(rootNode, parentWindowTitle, parentWindowURL, element.href)); // If not null send new Node object
}

function handleMessage(msgEvent) {
    console.log("Message");
    if (msgEvent.name === "tag") {
        rootNode = msgEvent.message;
        console.log("Tagged with root " + rootNode);
    } else if (msgEvent.name === "newTree") {
        //  alert(parentWindowURL);
        if (!blacklistCheck(parentWindowURL)) return;
        rootNode = msgEvent.message;
        safari.self.tab.dispatchMessage("newNavNode", new NavNode("all-browsing", parentWindowURL, parentWindowURL, null));
        safari.self.tab.dispatchMessage("newNavNode", new NavNode(rootNode, parentWindowURL, parentWindowURL, null));
    } else if (msgEvent.name === "burn") {
        if (rootNode == msgEvent.message) rootNode = null;
    }
}

var rootNode = null;
var blacklistComplete = ["#", "about:blank", "AddThis Utility Frame", "javascript:void(0)"];
var blackListIncomplete = ["googleads.g.doubleclick.net", "googlesyndication"];
var parentWindowURL, parentWindowTitle;

try {
    parentWindowURL = top.document.URL;
    parentWindowTitle = (top.document.title ? top.document.title : top.document.URL.split("/")[2]);
    // console.log(parentWindowURL);
    console.log(document.URL);
    console.log(blacklistCheck(parentWindowURL));

    if (blacklistCheck(parentWindowURL)) {
        var links = document.links;
        var count = 0;
        for (var i = 0; i < links.length; i++) { // Injects function into each link
            if (links[i].href && blacklistCheck(links[i].href)) {
                links[i].addEventListener("click", function() {
                    wasClicked(this);
                });
                count++;
            }
        }
        safari.self.addEventListener("message", handleMessage, false);
    }
    console.log("Accessing higher page");
    console.log("Injected " + count + " listeners");
} catch (e) {
    parentWindowURL = document.URL;
    parentWindowTitle = (document.title ? document.title : document.URL.split("/")[2]);

    if (blacklistCheck(parentWindowURL)) {
        var links = document.links;
        for (var i = 0; i < links.length; i++) { // Injects function into each link
            if (links[i].href && blacklistCheck(links[i].href)) {
                links[i].addEventListener("click", function() {
                    wasClicked(this);
                });
            }
        }
        safari.self.addEventListener("message", handleMessage, false);
    }
    console.log("Sticking to this page");
}
