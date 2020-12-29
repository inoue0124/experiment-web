import { axios } from '../index.js';

export default {

  getWork() {
    return axios.$get(`workflow`)
  },

  complete(id:number) {
    return axios.$put(`workflow/${id}/complete`)
  },

  undo() {
    return axios.$put(`workflow/undo`)
  }
}