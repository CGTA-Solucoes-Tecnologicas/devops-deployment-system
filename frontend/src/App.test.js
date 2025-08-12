// App.test.js
import '@testing-library/jest-dom';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import App from './App';

global.fetch = jest.fn();

const API = 'http://localhost:3001/books';

// Small helper to mock fetch JSON responses in order
function mockJsonOnce(data, { status = 200 } = {}) {
  fetch.mockResolvedValueOnce({
    ok: status >= 200 && status < 300,
    status,
    json: async () => data,
  });
}

beforeEach(() => {
  // Reset mocks before each test to avoid cross-test interference
  fetch.mockReset();
});

describe('Books CRUD', () => {
  it('loads empty list on start', async () => {
    // initial GET
    mockJsonOnce([]); // GET /books

    render(<App />);

    // Ensure initial fetch was called correctly
    expect(fetch).toHaveBeenCalledWith(`${API}`);

    // Nothing rendered yet (no books)
    // You can assert presence of the title or form inputs as a smoke test
    expect(await screen.findByText(/Books/i)).toBeInTheDocument();
  });

  it('creates a book', async () => {
    // initial GET -> []
    mockJsonOnce([]); // GET /books

    render(<App />);

    // POST /books -> created item
    mockJsonOnce({ id: 1, title: 'Test', author: 'Author' }, { status: 201 });
    // follow-up GET /books -> list with created item
    mockJsonOnce([{ id: 1, title: 'Test', author: 'Author' }]);

    fireEvent.change(screen.getByPlaceholderText(/Title/i), {
      target: { value: 'Test' },
    });
    fireEvent.change(screen.getByPlaceholderText(/Author/i), {
      target: { value: 'Author' },
    });
    fireEvent.click(screen.getByText(/Create/i));

    // wait until the new item appears
    await screen.findByText(/Test/);
    expect(screen.getByText(/by Author/)).toBeInTheDocument();

    // Optionally assert fetch calls
    expect(fetch).toHaveBeenCalledWith(API, expect.objectContaining({ method: 'POST' }));
  });

  it('updates a book', async () => {
    // initial GET -> one book
    mockJsonOnce([{ id: 1, title: 'Test', author: 'Author' }]); // GET

    render(<App />);

    // PUT /books/1 -> updated
    mockJsonOnce({ id: 1, title: 'Updated', author: 'Author' });
    // follow-up GET -> updated list
    mockJsonOnce([{ id: 1, title: 'Updated', author: 'Author' }]);

    fireEvent.click(await screen.findByText(/Edit/i));
    fireEvent.change(screen.getByPlaceholderText(/Title/i), {
      target: { value: 'Updated' },
    });
    fireEvent.click(screen.getByText(/Update/i));

    await screen.findByText(/Updated/);
    expect(screen.getByText(/by Author/)).toBeInTheDocument();

    expect(fetch).toHaveBeenCalledWith(`${API}/1`, expect.objectContaining({ method: 'PUT' }));
  });

  it('deletes a book', async () => {
    // initial GET -> one book
    mockJsonOnce([{ id: 1, title: 'ToRemove', author: 'A' }]);

    render(<App />);

    // DELETE /books/1
    fetch.mockResolvedValueOnce({ ok: true, status: 204, json: async () => ({}) });
    // follow-up GET -> empty
    mockJsonOnce([]);

    fireEvent.click(await screen.findByRole('button', { name: /Delete/i }));

    // After deletion, the item should NOT be on screen
    await waitFor(() => {
      expect(screen.queryByText(/ToRemove/)).not.toBeInTheDocument();
      expect(screen.queryByText(/by A/)).not.toBeInTheDocument();
    });

    expect(fetch).toHaveBeenCalledWith(`${API}/1`, expect.objectContaining({ method: 'DELETE' }));
  });
});
