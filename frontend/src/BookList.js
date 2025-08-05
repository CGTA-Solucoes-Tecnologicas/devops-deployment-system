import React from 'react';

export default function BookList({ books, onEdit, onDelete }) {
  return (
    <ul>
      {books.map(book => (
        <li key={book.id}>
          {book.title} by {book.author || 'Unknown'}
          <button onClick={() => onEdit(book)}>Edit</button>
          <button onClick={() => onDelete(book.id)}>Delete</button>
        </li>
      ))}
    </ul>
  );
}
