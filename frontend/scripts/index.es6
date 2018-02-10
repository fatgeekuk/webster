import React from 'react';
import { render } from 'react-dom'
import { createStore } from 'redux'
import { Provider } from 'react-redux'
import baseReducer from './reducers'
import App from './components/app'

let store = createStore(baseReducer);

render(
(
  <Provider store={store}>
    <App />
  </Provider>),
  document.getElementById('root')
)