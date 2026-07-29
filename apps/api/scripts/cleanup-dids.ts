import "dotenv/config";
import { MongoClient } from "mongodb";

async function main() {
  const c = new MongoClient(process.env.MONGO_URL!);
  await c.connect();
  const db = c.db();
  
  // Delete stale DIDs that don't match the actual VoiceLink DID
  const staleIds = ["919484956633", "919484956952"];
  const r = await db.collection("dids").deleteMany({ _id: { $in: staleIds } as any });
  console.log("Deleted stale DIDs:", r.deletedCount);
  
  const remaining = await db.collection("dids").find({}).toArray();
  console.log("Remaining DIDs:", remaining.map(d => ({ id: d._id, providerNumber: d.providerNumber })));
  
  await c.close();
}

main().catch(e => { console.error(e); process.exit(1); });
