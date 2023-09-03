const express = require('express');
const auth = require('../middlewares/auth');
const { Product } = require('../models/product');
const User = require('../models/user');
const userRouter = express.Router();
//api to add product to cart
userRouter.post("/api/add-to-cart", auth, async (req, res) => {
    try {
        const { id } = req.body;
        const product = await Product.findById(id);
        let user = await User.findById(req.user);

        if (user.cart.length == 0) {
            user.cart.push({
                product,
                quantity: 1
            });
        }
        else {
            let isProductFound = false;
            for (let i = 0; i < user.cart.length; i++) {
                //_id because it is given by mongoose in the form of object id 
                if (user.cart[i].product._id.equals(id)) {
                    isProductFound = true;
                    user.cart[i].quantity += 1;
                    break;
                }
            }
            if (!isProductFound) {
                user.cart.push({
                    product,
                    quantity: 1
                });
            }
        }
        user = await user.save();
        res.json(user);
        
    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }
});
userRouter.delete("/api/delete-product/:id", auth, async (req, res) => {
    
    try {
        const { id } = req.params;
        let user = await User.findById(req.user);
        for (let i = 0; i < user.cart.length; i++) {
            if (user.cart[i].product._id.equals(id)) {
                if (user.cart[i].quantity == 1) {
                    user.cart.splice(i, 1);

                }
                else {
                    user.cart[i].quantity -= 1;
                }
         }   
        }
        user = await user.save();
        res.json(user); 
    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }
})



module.exports = userRouter;