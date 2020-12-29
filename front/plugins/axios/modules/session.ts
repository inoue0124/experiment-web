import { axios } from '../index.js';

export default {

  isAuthenticated() {
    return axios.get('http://localhost:3000/login')
  },

  login(email: string, password: string) {
    return axios.post(
      'http://localhost:3000/login',
      {
        email: email,
        password: password
      }
    )
  },

  logout() {
    return axios.delete('http://localhost:3000/logout')
  }
}