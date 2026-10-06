const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) =>
  res.json({ app: 'devops-showcase-app', version: process.env.APP_VERSION || 'dev' })
);
app.get('/health', (req, res) => res.status(200).json({ status: 'ok' }));
app.get('/ready', (req, res) => res.status(200).json({ status: 'ready' }));

app.listen(PORT, () => console.log(`Listening on ${PORT}`));//d