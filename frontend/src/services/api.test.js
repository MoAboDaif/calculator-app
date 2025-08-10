import { calculate, getHistory } from './api.js';

// Mock the fetch API globally
global.fetch = jest.fn();

describe('API Service', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('calculate sends correct request and handles success', async () => {
    const mockResponse = { result: 8 };
    fetch.mockResolvedValueOnce({
      ok: true,
      headers: { get: () => 'application/json' }, // ✅ needed for handleResponse
      json: () => Promise.resolve(mockResponse),
    });

    const result = await calculate(5, 3, 'add');

    expect(result).toEqual(mockResponse);
    expect(fetch).toHaveBeenCalledWith(
      expect.stringContaining('/calculate'),
      expect.objectContaining({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: JSON.stringify({ a: 5, b: 3, operation: 'add' }),
      })
    );
  });

  test('calculate handles error response', async () => {
    fetch.mockResolvedValueOnce({
      ok: false,
      headers: { get: () => 'application/json' },
      json: () => Promise.resolve({ error: 'Division by zero' }),
    });

    await expect(calculate(5, 0, 'divide')).rejects.toThrow('Division by zero');
  });

  test('getHistory fetches history successfully', async () => {
    const mockHistory = [{ id: 1, operation: 'add', result: 8 }];
    fetch.mockResolvedValueOnce({
      ok: true,
      headers: { get: () => 'application/json' },
      json: () => Promise.resolve({ history: mockHistory }),
    });

    const history = await getHistory();

    expect(history).toEqual({ history: mockHistory });
    expect(fetch).toHaveBeenCalledWith(
      expect.stringContaining('/history'),
      expect.objectContaining({
        method: 'GET',
        headers: { 'Accept': 'application/json' },
      })
    );
  });

  test('getHistory handles fetch failure', async () => {
    fetch.mockRejectedValueOnce(new Error('Network error'));

    await expect(getHistory()).rejects.toThrow('Network error');
  });
});
