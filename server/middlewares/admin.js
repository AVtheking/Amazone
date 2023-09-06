const jwt = require('jsonwebtoken');
const User = require('../models/user');

const admin = async (req, res, next) => {
    try {
        const token = req.header("x-auth-token");
        if (token === "your_testing_token") {
            req.user = null; // Set req.user to null for testing purposes
            req.token = token;
            return next();
        } // Set the token for testing purposes
        if (!token) {
            return res.status(401).json({ msg: "No auth token access denied" });
        }
        const verified = jwt.verify(token, "passwordKey")
        if (!verified) {
            return res.status(401).json({ msg: "Token verification failed access denied!" });
        }
        const user = await User.findById(verified.id);
        if (user.type == "user" || user.type == "seller") {
            return res.status(401).json({ msg: "You are not an admin" });
        }
        req.user = verified.id;
        req.token = token;
        next();
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
};
module.exports = admin;