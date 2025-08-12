import React, { useEffect, useState } from 'react';
import BookList from './BookList';
import BookForm from './BookForm';
import './styles.css';

const api = `http:${process.env.REACT_APP_HOST || 'localhost'}:${process.env.REACT_APP_API_PORT || 3001}`;

export default function App() {
  const [books, setBooks] = useState([]);
  const [editing, setEditing] = useState(null);

  const loadBooks = () => {
    fetch(`${api}/books`)
      .then(res => res.json())
      .then(setBooks);
  };

  useEffect(() => {
    loadBooks();
  }, []);

  const handleCreate = data => {
    fetch(`${api}/books`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    }).then(loadBooks);
  };

  const handleUpdate = (id, data) => {
    fetch(`${api}/books/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    }).then(() => {
      setEditing(null);
      loadBooks();
    });
  };

  const handleDelete = id => {
    fetch(`${api}/books/${id}`, { method: 'DELETE' }).then(loadBooks);
  };

  return (
    <div className="min-h-screen bg-gray-100 p-6">
      <div className="max-w-2xl mx-auto bg-white rounded-xl shadow-md p-6 space-y-6">
        <h1 className="text-3xl font-bold text-gray-800 text-center">📚 Book Manager</h1>

        <BookForm
          onSubmit={editing ? data => handleUpdate(editing.id, data) : handleCreate}
          initialData={editing}
        />

        <BookList books={books} onEdit={setEditing} onDelete={handleDelete} />
      </div>
    </div>
  );
}
