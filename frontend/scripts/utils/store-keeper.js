import { createStore } from 'redux'
import baseReducer from '../reducers'

let store = createStore(baseReducer);

export default store;