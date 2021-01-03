import { axios } from '../index.js';

export default {

  getCurrentUser() {
    return axios.get('http://localhost:3000/session')
  },

  login(email: string, password: string) {
    return axios.post(
      'http://localhost:3000/session',
      {
        email: email,
        password: password
      }
    )
  },

  logout() {
    return axios.delete('http://localhost:3000/session')
  }
}