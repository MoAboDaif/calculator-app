import React from 'react';
import Calculator from './components/Calculator';
import History from './components/History';
import ThemeToggle from './components/ThemeToggle';
import './App.css';

function App() {
  return (
    <div className="container" data-testid="app-container">
      <div className="header">
        <img 
          className="img" 
          src="https://cdn-icons-png.flaticon.com/512/134/134914.png" 
          alt="Calculator Icon" 
          data-testid="app-logo"
        />
        <h1 data-testid="app-title">Enhanced Calculator</h1>
        <ThemeToggle />
      </div>
      
      <Calculator />
      <History />
      
      <footer data-testid="app-footer">
        <p>© 2023 Enhanced Calculator | Made with <i className="fas fa-heart"></i></p>
        <div className="footer-links">
          <a href="#" aria-label="Help"><i className="fas fa-question-circle"></i></a>
          <a href="#" aria-label="Settings"><i className="fas fa-cog"></i></a>
          <a href="#" aria-label="GitHub Repository"><i className="fab fa-github"></i></a>
        </div>
      </footer>
    </div>
  );
}

export default App;