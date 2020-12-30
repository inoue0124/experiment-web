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

  bulkCreateUsers(data:Object) {
    return axios.$post(`users/bulk`, data)
  },

  getUser(id:number) {
    return axios.$get(`users/${id}`)
  },

  getUsers() {
    return axios.$get(`users`)
  },

  updateUser(id:number, body:Object) {
    return axios.$put(`users/${id}`, body)
  },

  deleteUser(id:number) {
    return axios.$delete(`users/${id}`)
  }
}