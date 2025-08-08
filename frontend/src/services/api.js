const API_BASE_URL = process.env.REACT_APP_API_BASE_URL || 'http://localhost:5000';

export const calculate = async (a, b, operation) => {
  try {
    const response = await fetch(`${API_BASE_URL}/calculate`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: JSON.stringify({ a, b, operation })
    });

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.error || 'Calculation error');
    }

    return await response.json();
  } catch (error) {
    throw error;
  }
};

export const getHistory = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/history`, {
      method: 'GET',
      headers: {
        'Accept': 'application/json'
      }
    });

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.error || 'Failed to fetch history');
    }

    return await response.json();
  } catch (error) {
    throw error;
  }
};