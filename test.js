const express = require('express');
const fs = require('fs');
const path = require('path');
const app = express();
let port = 4299;
let latest
let imgs = {}
app.get('/render', (req, res) => {
    const b64 = req.query.data;
    if (!b64) return
    let bffr = Buffer.from(b64, 'base64');
    latest = `${Date.now()}`;
    imgs[latest] = bffr
    res.send(bffr);
});
app.get('/latest', (req, res) => {
    if (!latest) return
    let b64 = imgs[latest];
    let html = `<!DOCTYPE html>
<html>
    <body>
        <img src="data:image/png;base64,${b64}" alt="latest render">
    </body>
</html>`;
    res.send(html);
});

app.listen(port, function () {
    console.log(`server running in ${port}`);
});
