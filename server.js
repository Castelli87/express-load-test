const express = require("express");
const cors = require("cors");
const app = express();
// Allow FE domain
app.use(cors({
  origin: '*', // Allow all origins for development
  credentials: true
}));
const { exec } = require("child_process");


// Each replica prints its container hostname
// This is IMPORTANT so you can see which instance answered
app.get("/", (req, res) => {
  const hostname = process.env.HOSTNAME|| "unknown";
  console.log("Handled by:", hostname);
  res.send("Hello from " + hostname);
});

// Optional heavy endpoint to simulate CPU load
app.get("/cpu", (req, res) => {
  let sum = 0;
  for (let i = 0; i < 5_000_000; i++) {
    sum += i;
  }

  const hostname = process.env.HOSTNAME|| "unknown";
  res.send("CPU work done by " + process.env.HOSTNAME);
});

app.get('/load-test', (req, res) => {
  //TO DO fix the url and test it

  exec('curl http://192.:3003/', (err, stdout) => {
    if (err) return res.send("Error: " + err.message);
    res.send(stdout);
  });
});

const PORT = 3003;
app.listen(PORT, "0.0.0.0", () => console.log("Server running on", PORT));
