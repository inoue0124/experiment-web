import { axios } from '../index.js';

export default {

  getWork() {
    return axios.$get(`workflow`)
  },

  complete() {
    return axios.$put(`workflow/complete`)
  },

  undo() {
    return axios.$put(`workflow/undo`)
  }
}