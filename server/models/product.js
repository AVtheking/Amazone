const mongoose = require('mongoose');

const proudctSchema = mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true,
    },
    description: {
        type: String,
        required: true,
        trim: true
    },
    images: [
        {
            type: String,
            required: true
        }
    ],
    quantity: {
        type: Number,
        required: true
    },
    price: {
        type: Number,
        required: true
    },
    category: {
        type: String,
        required:true,
    }
});
const Product = mongoose.model('product', proudctSchema);
module.exports=Product;