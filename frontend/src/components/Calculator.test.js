import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import Calculator from './Calculator';
import * as api from '../services/api';

jest.mock('../services/api');

test('validates inputs before submission', async () => {
  render(<Calculator />);

  fireEvent.click(screen.getByTestId('calculate-button'));

  await waitFor(() => {
    // first input should show error class
    expect(screen.getByTestId('first-number-input')).toHaveClass('input-error');

    // there may be multiple identical error messages; assert at least one exists
    const msgs = screen.getAllByText('Please enter a valid number');
    expect(msgs.length).toBeGreaterThanOrEqual(1);

    expect(api.calculate).not.toHaveBeenCalled();
  });
});
