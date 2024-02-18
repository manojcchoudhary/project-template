import { type Config } from "drizzle-kit";

import { env } from "@/env.js";

export default {
  schema: "./src/server/db/schema.ts",
  driver: "pg",
  out: "./drizzle",
  dbCredentials: {
    connectionString: env.DATABASE_URL,
  },
  tablesFilter: ["PG_DATABASE_TABLE_PREFIX_*"],
} satisfies Config;
