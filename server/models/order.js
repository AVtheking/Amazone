const mongoose = require("mongoose");
const { proudctSchema } = require("./product");

const orderSchema = mongoose.Schema({
    products: [
        {
            product: proudctSchema,
            quantity: {
                type: Number,
                required: true
                
            
            },
            
        },
    ],
    totalPrice: {
        type: Number,
        required: true,
    },
    address: {
        type: String,
        required: true,
    },
    userId: {
        type: String,
        required: true
    },
    orderedAt: {
        type: Number,
        required:true,
    },
    status: {
        type: Number,
        default:0,
    },

});
const Order = mongoose.model("order", orderSchema);
module.exports = Order;