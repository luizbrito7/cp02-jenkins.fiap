const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;
const APP_VERSION = process.env.APP_VERSION || 'dev';
const IMAGE_TAG = process.env.IMAGE_TAG || 'dev';
const IMAGE = `ghcr.io/luizbrito7/cp02-jenkins.fiap:${IMAGE_TAG}`;

app.get('/', (req, res) => {
  res.json({
    app: 'cp02-app',
    version: APP_VERSION,
    image: IMAGE,
    message: 'Pipeline CI/CD funcionando!',
    timestamp: new Date().toISOString(),
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.listen(PORT, () => {
  console.log(`cp02-app v${APP_VERSION} rodando na porta ${PORT}`);
});
