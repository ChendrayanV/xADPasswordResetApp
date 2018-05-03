var express = require('express'),
    app = express(),
    shell = require('node-powershell'),
    ps = new shell({
        executionPolicy: 'bypass',
        noProfile: true
    }),
    bodyparser = require('body-parser'),
    path = require('path'),
    myData = require('./myData.json');
    //twilio = require('twilio');

app.use(bodyparser.urlencoded({ extended: true }));
//app.use(express.static('public'))
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

app.get("/", function (request, response) {
    response.render("index");
});

app.get("/UserID", function (request, response) {
    response.render("UserID")
});

app.post("/UserInformation", function (request, response) {
    ps.addCommand("./scripts/GetADUser.ps1", [ {
        name: 'sAMAccountName',
        value: request.body.sAMAccountName
    } ])
    ps.invoke().then(output => {
        var result = JSON.parse(output)
        response.render('UserInformation', {
            sAMAccountName: result[ 'sAMAccountName' ],
            FirstName: result[ 'FirstName' ],
            LastName: result[ 'LastName' ],
            Email: result[ 'Email' ],
            NewPassword: result[ 'NewPassword' ]
        })
    })
});

app.post('/DoAction', function (request, response) {
    response.send("<h1>Thanks</h1>");
})

app.listen(3000)
console.log("Its Running!")
