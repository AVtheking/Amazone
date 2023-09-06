const express = require('express');
const adminRouter = express.Router();
const {Product} = require('../models/product');
const admin = require('../middlewares/admin');
const Order = require('../models/order');

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
});
adminRouter.post("/admin/delete-product", admin, async (req, res) => {
    try {
        const { id } = req.body;
        let product = await Product.findByIdAndDelete(id);
        
        res.json(product);

    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }
});
adminRouter.get("/admin/get-orders", admin, async (req, res) => {
    try {
        const order = await Order.find();
        res.json(order);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});
adminRouter.post("/admin/change-status", admin, async (req, res) => {
    try {
        const { id, status } = req.body;
        let order = await Order.findById(id);

        order.status = status;
        order = await order.save();
        res.json(order);
        
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});
adminRouter.get("/admin/analytics", admin, async (req, res) => {
    try {
        let orders = await Order.find();
        let totalEarning = 0;
        for (let i = 0; i < orders.length; i++){
            totalEarning += orders[i].totalPrice;

        }
        let mobileEarning = await fetchCategoryWiseProduct("Mobiles");
        let essentialEarning = await  fetchCategoryWiseProduct("Essentials");
        let appliancesEarning = await  fetchCategoryWiseProduct("Appliances");
        let bookEarning = await  fetchCategoryWiseProduct("Books");
        let fashionEarning = await fetchCategoryWiseProduct("Fashion");
        
        let earning = {
            totalEarning,
            mobileEarning,
            essentialEarning,
            appliancesEarning,
            bookEarning,
            fashionEarning
        }

        res.json(earning);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})
async function fetchCategoryWiseProduct(category)   {
    const categoryOrder = await Order.find({
        'products.product.category': category
    });
    let earning = 0;
    for (let i = 0; i < categoryOrder.length; i++){
        earning += categoryOrder[i].totalPrice;
    }
    return earning;
}
module.exports = adminRouter;