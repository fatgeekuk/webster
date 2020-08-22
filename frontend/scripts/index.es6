import React from 'react';
import { render } from 'react-dom'
import { createStore } from 'redux'
import { Provider } from 'react-redux'
import App from './components/app'
import { store } from './utils';

render(
  (
    <Provider store={store}>
      <App />
    </Provider>),
  document.getElementById('root')
)

export {};