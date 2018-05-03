var express = require('express'),
    app = express(),
    shell = require('node-powershell'),
    ps = new shell({
        executionPolicy: 'bypass',
        noProfile: true
    }),
    bodyparser = require('body-parser'),
    path = require('path');

app.use(bodyparser.urlencoded({ extended: true }));
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

app.post('/SetPassword', function (request, response) {
    //response.send("<h1>Thanks</h1>");
    ps.addCommand("./scripts/ResetPassword.ps1", [ {
        name: 'LoginID',
        value: request.body.LoginID
    }, {
        name: 'newPassword',
        value: request.body.newPassword
    },{
        name: 'uPhoneNumber',
        value: request.body.uPhoneNumber 
    } ])
    ps.invoke().then(output => {
        response.send(output)
    })
})

app.listen(3000)
console.log("Its Running!")
