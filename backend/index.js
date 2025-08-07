const express = require('express');
const app = express();

app.use(express.json());

// Simple in-memory metrics collection
const metrics = {};
app.use((req, res, next) => {
  res.on('finish', () => {
    if (req.path === '/metrics') return;
    const routePath = req.route ? req.route.path : req.path;
    const key = `${req.method} ${routePath}`;
    metrics[key] = (metrics[key] || 0) + 1;
  });
  next();
});

let books = [];
let nextId = 1;

// Get all books
app.get('/books', (req, res) => {
  res.json(books);
});

// Get a book by id
app.get('/books/:id', (req, res) => {
  const id = parseInt(req.params.id, 10);
  const book = books.find(b => b.id === id);
  if (!book) {
    return res.status(404).json({ error: 'Book not found' });
  }
  res.json(book);
});

// Create a new book
app.post('/books', (req, res) => {
  const { title, author } = req.body;
  if (!title) {
    return res.status(400).json({ error: 'Title is required' });
  }
  const book = { id: nextId++, title, author };
  books.push(book);
  res.status(201).json(book);
});

// Update a book
app.put('/books/:id', (req, res) => {
  const id = parseInt(req.params.id, 10);
  const book = books.find(b => b.id === id);
  if (!book) {
    return res.status(404).json({ error: 'Book not found' });
  }
  const { title, author } = req.body;
  if (title !== undefined) book.title = title;
  if (author !== undefined) book.author = author;
  res.json(book);
});

// Delete a book
app.delete('/books/:id', (req, res) => {
  const id = parseInt(req.params.id, 10);
  const index = books.findIndex(b => b.id === id);
  if (index === -1) {
    return res.status(404).json({ error: 'Book not found' });
  }
  books.splice(index, 1);
  res.status(204).send();
});

// Expose metrics in Prometheus format
app.get('/metrics', (req, res) => {
  res.set('Content-Type', 'text/plain; version=0.0.4');
  const lines = [
    '# HELP http_requests_total The total number of HTTP requests',
    '# TYPE http_requests_total counter'
  ];
  for (const [key, value] of Object.entries(metrics)) {
    const [method, path] = key.split(' ');
    lines.push(`http_requests_total{method="${method}",path="${path}"} ${value}`);
  }
  res.send(lines.join('\n'));
});

module.exports = app;

if (require.main === module) {
  const PORT = process.env.PORT || 3001;
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}
