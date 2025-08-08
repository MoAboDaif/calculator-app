import unittest
from calculator import add, subtract, multiply, divide

class TestCalculator(unittest.TestCase):

    def test_add(self):
        self.assertEqual(add(5, 3), 8)
        
    def test_subtract(self):
        self.assertEqual(subtract(5, 3), 2)
        
    def test_multiply(self):
        self.assertEqual(multiply(5, 3), 15)
        
    def test_divide(self):
        self.assertEqual(divide(6, 3), 2)
        
    def test_divide_by_zero(self):
        with self.assertRaises(ValueError):
            divide(5, 0)