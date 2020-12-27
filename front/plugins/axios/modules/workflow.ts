import { axios } from '../index.js';

export default {
  createUser(email:string, password:string, password_confirmation:string) {
    return axios.$post(
      `users`,
      {
        email: email,
        password: password,
        password_confirmation: password_confirmation
      }
    )
  },

  getNextWork() {
    return axios.$get(`workflow/next`)
  },

  getUsers() {
    return axios.$get(`users`)
  }
}