import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import App from './App';

global.fetch = jest.fn();

afterEach(() => {
  fetch.mockClear();
});

test('create, update, and delete a book', async () => {
  // initial load
  fetch.mockResolvedValueOnce({
    json: async () => []
  });

  render(<App />);
  expect(fetch).toHaveBeenCalledWith('/books');

  // create
  fetch.mockResolvedValueOnce({
    json: async () => ({ id: 1, title: 'Test', author: 'Author' }),
    status: 201
  });
  fetch.mockResolvedValueOnce({
    json: async () => [{ id: 1, title: 'Test', author: 'Author' }]
  });

  fireEvent.change(screen.getByPlaceholderText(/Title/i), {
    target: { value: 'Test' }
  });
  fireEvent.change(screen.getByPlaceholderText(/Author/i), {
    target: { value: 'Author' }
  });
  fireEvent.click(screen.getByText(/Create/i));

  await waitFor(() => screen.getByText('Test by Author'));

  // update
  fetch.mockResolvedValueOnce({
    json: async () => ({ id: 1, title: 'Updated', author: 'Author' })
  });
  fetch.mockResolvedValueOnce({
    json: async () => [{ id: 1, title: 'Updated', author: 'Author' }]
  });

  fireEvent.click(screen.getByText(/Edit/i));
  fireEvent.change(screen.getByPlaceholderText(/Title/i), {
    target: { value: 'Updated' }
  });
  fireEvent.click(screen.getByText(/Update/i));
  await waitFor(() => screen.getByText('Updated by Author'));

  // delete
  fetch.mockResolvedValueOnce({ status: 204 });
  fetch.mockResolvedValueOnce({
    json: async () => []
  });
  fireEvent.click(screen.getByText(/Delete/i));
  await waitFor(() => expect(screen.queryByText('Updated by Author')).toBeNull());
});
