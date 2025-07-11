const express = require('express');
const fs = require('fs');
const path = require('path');
const app = express();
let port = 4299;
let latest
app.get('/render', (req, res) => {
    const b64 = req.query.data;
    if (!b64) return
    let bffr = Buffer.from(b64, 'base64');
    let name = `image_${Date.now()}.png`;
    let fpath = path.join(__dirname, 'imgs', name);
    if (!fs.existsSync(path.join(__dirname, 'imgs'))) {
        fs.mkdirSync(path.join(__dirname, 'imgs'));
    }
    fs.writeFile(fpath, bffr, (err) => {
        if (err) {
            console.error(err);
            return
        }
        console.log('render:', name);
        latest = name;
    });
});
app.use('/imgs', express.static(path.join(__dirname, 'imgs')));
app.get('/latest', (req, res) => {
    if (!latest) return
    let url = `/imgs/${latest}`;
    let html = `<!DOCTYPE html>
<html>
    <body>
        <img src="${url}" alt="Latest Image">
    </body>
</html>`;
    res.send(html);
});

app.listen(port, function () {
    console.log(`server running in ${port}`);
});
