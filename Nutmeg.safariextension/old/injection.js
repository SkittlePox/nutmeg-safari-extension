var Node = function(parentTitle, parentURL, childURL) {
    this.parentTitle = parentTitle;
    this.parentURL = parentURL;
    this.childURL = childURL;
    this.childTitle = "";
}

function wasClicked(element) {
    safari.self.tab.dispatchMessage("newNode", new Node(top.document.title, top.document.URL, element.href)); // If not null send new Node object
}

links = document.links;

for (var i = 0; i < links.length; i++) {    // Injects function into each link
    if (links[i].href && links[i].href != top.document.URL) {
        links[i].addEventListener("click", function() {wasClicked(this);});
    }
}
