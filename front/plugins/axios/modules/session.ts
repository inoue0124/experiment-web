import { axios } from '../index.js';

export default {

  baseURL: 'http://localhost:3000/',

  getCurrentUser() {
    return axios.get(this.baseURL + 'session')
  },

  login(email: string, password: string) {
    return axios.post(
      this.baseURL + 'session',
      {
        email: email,
        password: password
      }
    )
  },

  logout() {
    return axios.delete(this.baseURL + 'session')
  }
}