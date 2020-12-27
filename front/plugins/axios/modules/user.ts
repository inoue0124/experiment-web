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

  getUser(id:number) {
    return axios.$get(`users/${id}`)
  },

  getUsers() {
    return axios.$get(`users`)
  }
}