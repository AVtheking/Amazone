const express = require('express');
const productRoute = express.Router();
const auth = require("../middlewares/auth");
const Product = require('../models/product');

productRoute.get("/api/product", auth, async (req, res) => {
    try {
        const products = await Product.find({
            category: req.query.category
        });
        res.json(products);
        
    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }
});
productRoute.get("/api/product/search/:name", auth, async (req, res) => {
    try {
        const prodcuts = await Product.find({
            name: { $regex: req.params.name, $options: "i" },
        });
        res.json(prodcuts);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})
module.exports = productRoute;