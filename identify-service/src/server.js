import express from "express";
import cors from "cors";
import helmet from "helmet";
import Redis from "ioredis"
import rateLimit from "express-rate-limit"
import RedisStore from "rate-limit-redis"
import proxy from "express-http-proxy"
import logger from "./utils/logger.util.js";
import errorHandler from "./middleware/errorHandler.middleware.js";
import validateToken from "./middleware/auth.middleware.js";
import mongoose from "mongoose";
import RateLimiterRedis from "rate-limiter-flexible";

import "dotenv/config";

const app = express();
const PORT = process.env.PORT || 3001;

//connect to mongodb
mongoose
  .connect(process.env.MONGODB_URI)
  .then(() => logger.info("Connected to mongodb"))
  .catch((e) => logger.error("Mongo connection error", e));

const redisClient = new Redis(process.env.REDIS_URL);

//middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

app.use((req, res, next) => {
  logger.info(`Received ${req.method} request to ${req.url}`);
  logger.info(`Request body, ${req.body}`);
  next();
});

//DDos protection and rate limiting
const rateLimiter = new RateLimiterRedis({
  storeClient: redisClient,
  keyPrefix: "middleware",
  points: 10,
  duration: 1,
});

app.use((req, res, next) => {
  rateLimiter
    .consume(req.ip)
    .then(() => next())
    .catch(() => {
      logger.warn(`Rate limit exceeded for IP: ${req.ip}`);
      res.status(429).json({ success: false, message: "Too many requests" });
    });
});

//Ip based rate limiting for sensitive endpoints
const sensitiveEndpointsLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 50,
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    logger.warn(`Sensitive endpoint rate limit exceeded for IP: ${req.ip}`);
    res.status(429).json({ success: false, message: "Too many requests" });
  },
  store: new RedisStore({
    sendCommand: (...args) => redisClient.call(...args),
  }),
});

//apply this sensitiveEndpointsLimiter to our routes
app.use("/api/auth/register", sensitiveEndpointsLimiter);

//Routes
app.use("/api/auth", routes);

//error handler
app.use(errorHandler);

app.listen(PORT, () => {
  logger.info(`Identity service running on port ${PORT}`);
});

//unhandled promise rejection

process.on("unhandledRejection", (reason, promise) => {
  logger.error("Unhandled Rejection at", promise, "reason:", reason);
});