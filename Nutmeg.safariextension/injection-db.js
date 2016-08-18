var NavNode = function(objStore, parentTitle, parentURL, childURL) {
    this.objStore = objStore;
    this.parentTitle = parentTitle;
    this.parentURL = parentURL;
    this.childURL = childURL;
    this.visitTime = new Date();
}

function wasClicked(element) {
    safari.self.tab.dispatchMessage("newNode", new NavNode("all-browsing", top.document.title, top.document.URL, element.href)); // If not null send new Node object
}

links = document.links;

for (var i = 0; i < links.length; i++) {    // Injects function into each link
    if (links[i].href && links[i].href != top.document.URL) {
        links[i].addEventListener("click", function() {wasClicked(this);});
    }
}
