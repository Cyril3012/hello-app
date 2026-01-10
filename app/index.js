const http = require("http");

http.createServer((req, res) => {
  res.writeHead(200);
  res.end("Hello World from Kubernetes EKS\n");
}).listen(3000);
