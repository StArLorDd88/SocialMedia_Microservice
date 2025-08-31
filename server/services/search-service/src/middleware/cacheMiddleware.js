import logger from "../utils/logger.js";

export default async function cache(req, res, next) {
  const key = `search:${req.originalUrl}`;

  try {
    const cachedData = await req.redis.get(key);
    if (cachedData) {
      logger.info("Cache hit");
      return res.json(JSON.parse(cachedData));
    }

    logger.info("Cache miss");

    res.sendResponse = res.json;
    res.json = (body) => {
      req.redis.setex(key, 60, JSON.stringify(body)); 
      res.sendResponse(body);
    };

    next();
  } catch (e) {
    logger.error("Redis cache error", e);
    next();
  }
}