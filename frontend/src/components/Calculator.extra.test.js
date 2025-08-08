// src/components/Calculator.extra.test.js
import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import Calculator from './Calculator';
import * as api from '../services/api';

// Mock the API module
jest.mock('../services/api');

describe('Calculator additional tests', () => {
  afterEach(() => {
    jest.resetAllMocks();
    // Reset DOM state between tests
    document.body.className = '';
  });

  test('operation buttons and select reflect the chosen operation', () => {
    render(<Calculator />);

    // default operation is 'add'
    const addBtn = screen.getByTestId('add-button');
    const multiplyBtn = screen.getByTestId('multiply-button');
    const opSelect = screen.getByTestId('operation-select');

    expect(addBtn).toHaveClass('active');
    expect(opSelect.value).toBe('add');

    // click multiply and assert active class and select change
    fireEvent.click(multiplyBtn);
    expect(multiplyBtn).toHaveClass('active');
    expect(opSelect.value).toBe('multiply');

    // change via select should update operation too
    fireEvent.change(opSelect, { target: { value: 'divide' }});
    expect(screen.getByTestId('divide-button')).toHaveClass('active');
    expect(opSelect.value).toBe('divide');
  });

  test('validates blank and non-numeric inputs and prevents API call', async () => {
    render(<Calculator />);

    // blank values — click calculate
    fireEvent.click(screen.getByTestId('calculate-button'));

    await waitFor(() => {
      expect(screen.getByTestId('first-number-input')).toHaveClass('input-error');
      expect(screen.getByTestId('second-number-input')).toHaveClass('input-error');
      expect(screen.getByTestId('result-error')).toHaveTextContent('Please enter valid numbers in both fields');
    });

    // ensure API was not called
    expect(api.calculate).not.toHaveBeenCalled();

    // Now test non-numeric input in first field
    fireEvent.change(screen.getByTestId('first-number-input'), { target: { value: 'abc' }});
    fireEvent.change(screen.getByTestId('second-number-input'), { target: { value: '5' }});
    fireEvent.click(screen.getByTestId('calculate-button'));

    await waitFor(() => {
      expect(screen.getByTestId('first-number-input')).toHaveClass('input-error');
    });
    expect(api.calculate).not.toHaveBeenCalled();
  });

  test('shows loading spinner and success result after successful API call', async () => {
    // mock API calculate to resolve with an object containing result
    api.calculate.mockResolvedValueOnce({ result: 15 });

    render(<Calculator />);

    fireEvent.change(screen.getByTestId('first-number-input'), { target: { value: '3' }});
    fireEvent.change(screen.getByTestId('second-number-input'), { target: { value: '5' }});
    // switch to multiply
    fireEvent.click(screen.getByTestId('multiply-button'));

    fireEvent.click(screen.getByTestId('calculate-button'));

    // spinner should appear while loading
    expect(screen.getByTestId('calculate-button')).toHaveAttribute('aria-busy', 'true');
    expect(screen.getByTestId('spinner')).toBeInTheDocument();

    // wait for result and for API to be called with numeric values and operation
    await waitFor(() => {
      expect(api.calculate).toHaveBeenCalledWith(3, 5, 'multiply');
      expect(screen.getByTestId('result-success')).toBeInTheDocument();
      expect(screen.getByTestId('result-success')).toHaveTextContent('Result: 15');
      // spinner should be gone / button no longer busy
      expect(screen.getByTestId('calculate-button')).toHaveAttribute('aria-busy', 'false');
    });
  });

  test('displays API error when calculate rejects', async () => {
    api.calculate.mockRejectedValueOnce(new Error('Division by zero'));

    render(<Calculator />);

    fireEvent.change(screen.getByTestId('first-number-input'), { target: { value: '10' }});
    fireEvent.change(screen.getByTestId('second-number-input'), { target: { value: '0' }});
    fireEvent.click(screen.getByTestId('divide-button'));

    fireEvent.click(screen.getByTestId('calculate-button'));

    // wait for the error to be displayed
    await waitFor(() => {
      expect(api.calculate).toHaveBeenCalledWith(10, 0, 'divide');
      expect(screen.getByTestId('result-error')).toBeInTheDocument();
      expect(screen.getByTestId('result-error')).toHaveTextContent('Error: Division by zero');
      // spinner should be gone
      expect(screen.getByTestId('calculate-button')).toHaveAttribute('aria-busy', 'false');
    });
  });
});
