const mongoose = require('mongoose');
//schema is just a structure of model

//Defining structure of usermodel
const userSchema = mongoose.Schema({
    name: {
        required: true,
        type: String,
        trim: true,
    },
    email: {
        required: true,
        type: String,
        trim: true,
        validate: {
            validator: (value) => {
                //email validator
                const re = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re);
            },
            //If above validation fails then this line will execute
            message: "Please enter a valid email address",

        },
    },
    password: {
        required: true,
        type: String,
        validate: {
            validator: (value) => {
                return value.length > 6;
            },
            //If above validation fails then this line will execute
            message:"Password should be 6 characters long",

        },
        
    },
    address: {
        type: String,
        default: "",
    },
    type: {
        type: String,
        default:'user',
    },
});
//creating model
const User = mongoose.model("user", userSchema);
//Now we have to export it
module.exports = User;