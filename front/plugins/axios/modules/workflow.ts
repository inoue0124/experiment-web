import { axios } from '../index.js';

export default {

  completeWork() {
    return axios.$put(`workflow/complete`)
  },

  undoWork() {
    return axios.$put(`workflow/undo`)
  },

  getNextWork() {
    return axios.$get(`workflow/next`)
  },

  getUsers() {
    return axios.$get(`users`)
  }
}