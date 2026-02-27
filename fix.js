const fs = require('fs');
let content = fs.readFileSync('static/js/admin.js', 'utf8');

// The exact broken string
const broken = 'onclick="selectPersona(\"' + ' + p.id + ' + '\")"';
// What we want: onclick="selectPersona('" + p.id + "')"
const fixed = "onclick=\"selectPersona('\" + p.id + \"')\"";

if (content.includes(broken)) {
    content = content.split(broken).join(fixed);
    console.log('Fixed!');
} else {
    console.log('String not found, trying alternate...');
    // Try direct replace
    content = content.replace(/onclick="selectPersona\("\\+" \+ p\.id \+ "\\)"\)/g, 
        "onclick=\"selectPersona('\\'\" + p.id + \"'\\')\"");
}

fs.writeFileSync('static/js/admin.js', content);
