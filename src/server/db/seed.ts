import { connection } from ".";

const main = async () => {
  const _connection = connection;
  //   const _db = db;
  console.log("Seed start");

  await _connection.end();
  console.log("Seed done");
};

await main();
