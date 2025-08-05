import React, { useEffect, useState } from 'react';

export default function BookForm({ onSubmit, initialData }) {
  const [title, setTitle] = useState('');
  const [author, setAuthor] = useState('');

  useEffect(() => {
    if (initialData) {
      setTitle(initialData.title || '');
      setAuthor(initialData.author || '');
    } else {
      setTitle('');
      setAuthor('');
    }
  }, [initialData]);

  const handleSubmit = e => {
    e.preventDefault();
    onSubmit({ title, author });
    if (!initialData) {
      setTitle('');
      setAuthor('');
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input placeholder="Title" value={title} onChange={e => setTitle(e.target.value)} />
      <input placeholder="Author" value={author} onChange={e => setAuthor(e.target.value)} />
      <button type="submit">{initialData ? 'Update' : 'Create'}</button>
    </form>
  );
}
