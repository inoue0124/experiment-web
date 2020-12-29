import { axios } from '../index.js';

export default {

  login(email: string, password: string) {
    return axios.post(
      'http://localhost:3000/login',
      {
        email: email,
        password: password
      }
    )
  },

}