var NavNode = function(root, parentTitle, parentURL, childURL) {
    this.root = root;
    this.parentTitle = parentTitle;
    this.parentURL = parentURL;
    this.childURL = childURL;
    this.visitTime = new Date();
}

function wasClicked(element) {
    safari.self.tab.dispatchMessage("newNode", new NavNode("all-browsing", top.document.title, top.document.URL, element.href));
    if (rootNode) safari.self.tab.dispatchMessage("newNode", new NavNode(rootNode, top.document.title, top.document.URL, element.href)); // If not null send new Node object
}

function handleMessage(msgEvent) {
    if (msgEvent.name === "tag") {
        rootNode = msgEvent.message;
    } else if (msgEvent.name === "newTree") {
        rootNode = msgEvent.message;
        safari.self.tab.dispatchMessage("newNode", new NavNode("all-browsing", top.document.title, top.document.URL, null));
        safari.self.tab.dispatchMessage("newNode", new NavNode(rootNode, top.document.title, top.document.URL, null));
    }
}

rootNode = null;

links = document.links;

for (var i = 0; i < links.length; i++) { // Injects function into each link
    if (links[i].href && links[i].href != top.document.URL) {
        links[i].addEventListener("click", function() {
            wasClicked(this);
        });
    }
}

safari.self.addEventListener("message", handleMessage, false);
