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
    latest = `render_${Date.now()}`;
    imgs[latest] = b64
    res.send(b64);
});

app.get('/latest', (req, res) => {
    if (!latest) return
    let b64 = imgs[latest];
    let html = `<!DOCTYPE html>
<html>
    <body>
        <img onload="form_base64_decode_preview(this)"
        onloadedmetadata="this.onload()"
        src="data:image/png;base64,${b64}" 
        alt="latest render">
    </body>
</html>`;
    res.send(html);
});

app.listen(port, function () {
    console.log(`server running in ${port}`);
});

function form_base64_decode_preview(a) { //idk what this does
    function e() {
        var c = k(function (a) {
            return "FIELDSET" === a.tagName
        });
        if (c) {
            var b = c.querySelector("h5"),
                a = c.querySelector(".preview-output");
            b && a && (c = document.createElement("a"), c.innerHTML = "Toggle Background Color", c.href = "#", c.style = "font-style:normal;text-decoration:none;border-bottom:1px dotted", c.onclick = function () {
                a.style.backgroundColor = "black" === a.style.backgroundColor ? null : "black";
                return !1
            }, b.innerHTML += " | ", b.appendChild(c))
        }
    }

    function k(c) {
        for (var b = a; b.parentNode;)
            if (b =
                b.parentNode, !0 === c(b)) return b
    }

    function h(a, b) {
        !(g.w >= a && g.h >= b) && 0 < a && 0 < b && (g.w = a, g.h = b, d.innerHTML += "&bull; Resolution: " + (a + "&times;" + b) + "<br/>")
    }
    if (!1 === a.support_decode_preview) return null;
    var g = {};
    a.support_decode_preview = !0;
    var f = a.parentNode.getElementsByTagName("i")[0];
    f && (f.innerHTML = "");
    var d = function () {
        var a = k(function (a) {
            return -1 < a.className.indexOf("preview-wrapper")
        });
        if (a) return a.querySelector(".preview-info-extra")
    }();
    d && (d.innerHTML = "", h(a.naturalWidth, a.naturalHeight), "IMG" ===
        a.tagName ? (-1 < a.src.indexOf("image/svg") && (f = a.getBoundingClientRect()) && h(f.width, f.height), e()) : (h(a.videoWidth, a.videoHeight), 0 < a.duration && (d.innerHTML += "&bull; Duration: " + (a.duration + "s") + "<br/>")))
}