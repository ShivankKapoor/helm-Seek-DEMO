const express = require('express');
const path = require('path');
const serveStatic = require('serve-static');

const app = express();
const port = process.env.PORT || 3003;

// Serve static files
app.use(serveStatic(path.join(__dirname), {
  'index': ['index.html']
}));

// Handle 404s by serving index.html (for SPA behavior)
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(port, '0.0.0.0', () => {
  console.log(`🚀 Helm Seek server running on port ${port}`);
  console.log(`📱 Local: http://localhost:${port}`);
  console.log(`🌐 Network: http://0.0.0.0:${port}`);
});