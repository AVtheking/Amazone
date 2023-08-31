const express = require('express');
const adminRouter = express.Router();
const Product = require('../models/product');
const admin = require('../middlewares/admin');

adminRouter.post("/admin/add-product", admin, async (req, res) => {
    try {
        const { name, description, images, quantity, price, category } = req.body;
        let product = new Product({
            name,
            description,
            images,
            quantity,
            price,
            category
        });
        product = await product.save();
        res.status(200).json(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

adminRouter.get("/admin/get-product", admin, async (req, res) => {
    try {
        const products = await Product.find({});
        // console.log(products);
        res.json(products);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})
module.exports = adminRouter;