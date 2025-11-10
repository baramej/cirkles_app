import express from "express";
import { AccessToken } from "livekit-server-sdk";

const API_KEY = "API7ESYHEEBKv3P";
const API_SECRET = "ZxeSBbVC1r2p4RVVxVYNEPSfFz2NoJeXENhqh2EeI3vC";

const createToken = async (room, username) => {
	const at = new AccessToken(API_KEY, API_SECRET, {
		identity: username,
	});

	at.addGrant({ roomJoin: true, room: room });

	return await at.toJwt();
};

const app = express();
const port = 3000;

app.use(express.json());

app.post("/api/v1/getToken", async (req, res) => {
	const { room, username } = req.body;
	res.send(await createToken(room, username));
});

app.listen(port, () => {
	console.log(`Livekit API Server listening on port ${port}`);
});
