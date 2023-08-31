const express = require('express');
const User = require('../models/user');
const authRouter = express.Router();
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');
const auth = require('../middlewares/auth');
//post request to our server
authRouter.post("/api/signUp", async (req, res) => {
    try {
        const { name, email, password } = req.body //  as data from client would be in the form of map therefore 
        // we store each values in the variable here
    
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            //we have to specify status code here if not then it will send it 200 which means it is a success
            return res.status(400).json({ msg: "User with same email already exists" });
        }
        const hashedPassword = await bcryptjs.hash(password, 8);
        let user = new User({
            email,
            name,
            password: hashedPassword,
        });
        user = await user.save();
        res.status(200).json(user);//also by default status code is 200
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
   


});

// authRouter.post('/api/signUp', async (req, res) => {
//     const { name, email, password } = req.body;

//     const existingUser = await User.findOne({ email });
//     if (existingUser) {
//         return res.status(400).json({ msg: "User with same email already exists" });
//     }
//     let user = User({
//         email, name, password
//     });
//     user = await user.save();
//     res.status(200).json(user);
// })

//signIn api
authRouter.post("/api/signIn", async (req, res) => {
    try {
    const{ email, password} = req.body;
        const user = await User.findOne({ email });
        if (!user) {
          return  res.status(400).json({ msg: "User with this email do not exists", });
        }
        const isMatch = await bcryptjs.compare(password, user.password);
        if (!isMatch) {
          return    res.status(400).json({ msg: "Incorrect password" });
        }
        // res.status(200).json({ msg: "Signed in successfully" });
        const token = jwt.sign({ id: user._id }, "passwordKey");
        res.json({ token, ...user._doc });

        
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
    //to check token is valid or not
    authRouter.post("/tokenIsValid", async (req, res) => {
        try {
            const token = req.header('x-auth-token');
            if (!token) {
                return res.json(false);
            }
            const verified = jwt.verify(token, 'passwordKey');
            if (!verified) {
                return res.json(false);

            }
            const user = await User.findById(verified.id);
            if (!user) {
                return res.json(false);
            }
            res.json(true);
            
        } catch (e) {
            res.status(500).json({ error: e.message });
      }
  })
   //get user data api
    authRouter.get("/", auth, async (req, res) => {
        const user = await User.findById(req.user);
        //sending user data from here

        res.json({ ...user._doc, token: req.token });

    });
});
module.exports = authRouter;