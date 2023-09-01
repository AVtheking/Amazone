

//ALL IMPORTS HERE
const express = require("express");
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");
const adminRouter = require("./routes/admin");
const productRoute = require("./routes/product");

const PORT = 3000;//can be any number here 
const app = express();//storing express instant in variable
const DB="mongodb+srv://Ankit:varshney@cluster1.auetwxy.mongodb.net/?retryWrites=true&w=majority"
//Two ways of creating a call back function in js
// 1-> function (){}
//2 ->()=>{}
//MiddleWare are used here
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRoute);

//CREATING API

//GET PUT POST DELETE UPDATE-> CRUD operation

//https://<youripaddress>/hello-world
// app.get("/hello-world", (req, res) => {
//     res.json({ hi: 'hello-world' });
//     //this wiil get the data when api is being is called
    
// })
//connection to mangodb here 
mongoose.connect(DB).then(() => {//It is a promise function therefore we will use then here
    console.log("connection is succesful")
}).catch(e => {
    console.log(e);
})
app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port ${PORT} `);
})//If we do not pass the ip adress the it will listen with local host 
//with this it can be listen by anyone 
//call back function in listen