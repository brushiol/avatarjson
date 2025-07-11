const express = require('express');
const fs = require('fs');
const path = require('path');
const app = express();
let port = 4299;
let latest;
let imgs = {};

app.get('/latest', (req, res) => {
    console.log("looking for latest")
    let b64 = imgs[latest];
    let html = `<!DOCTYPE html>
<html>
    <body>
        <script src="//static.base64.guru/js/form_base64_decode_preview.min.js?1.0.50"></script>
        <img onload="form_base64_decode_preview(this)"
        onloadedmetadata="this.onload()"
        src="data:image/png;base64,${b64}" 
        alt="latest render">
    </body>
</html>`;
    res.send(html);
});

app.use(express.json());

app.post('/render', (req, res) => {
    const b64 = req.body.data;
    if (!b64) return
    latest = `render_${Date.now()}`;
    imgs[latest] = b64
    console.log("got render: "+latest)
});

app.listen(port, function() {
    console.log(`server running in ${port}`);
});