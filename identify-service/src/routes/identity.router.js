import express from "express";

const {
  resgiterUser,
  loginUser,
  refreshTokenUser,
  logoutUser,
} = require("../controllers/identity-controller");

const router = express.Router();

router.post("/register", resgiterUser);
router.post("/login", loginUser);
router.post("/refresh-token", refreshTokenUser);
router.post("/logout", logoutUser);

export default router;