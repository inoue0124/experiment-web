import { axios } from '../index.js';

export default {

  getNextWork() {
    return axios.$get(`workflow/next`)
  },

  getUsers() {
    return axios.$get(`users`)
  }
}