import React, { useEffect, useState } from 'react';
import BookList from './BookList';
import BookForm from './BookForm';

function App() {
  const [books, setBooks] = useState([]);
  const [editing, setEditing] = useState(null);

  const loadBooks = () => {
    fetch('/books')
      .then(res => res.json())
      .then(setBooks);
  };

  useEffect(() => {
    loadBooks();
  }, []);

  const handleCreate = data => {
    fetch('/books', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    }).then(loadBooks);
  };

  const handleUpdate = (id, data) => {
    fetch(`/books/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    }).then(() => {
      setEditing(null);
      loadBooks();
    });
  };

  const handleDelete = id => {
    fetch(`/books/${id}`, { method: 'DELETE' }).then(loadBooks);
  };

  return (
    <div>
      <h1>Books</h1>
      <BookForm
        onSubmit={editing ? data => handleUpdate(editing.id, data) : handleCreate}
        initialData={editing}
      />
      <BookList books={books} onEdit={setEditing} onDelete={handleDelete} />
    </div>
  );
}

export default App;
