import { axios } from '../index.js';

export default {
  createExperiment(body: Object) {
    return axios.$post(`experiments`,body)
  },

  getExperiment(id:number) {
    return axios.$get(`experiments/${id}`)
  },

  listExperiments() {
    return axios.$get(`experiments`)
  },

  updateExperiment(id:number, body:Object) {
    return axios.$put(`experiments/${id}`, body)
  },

  deleteExperiment(id:number) {
    return axios.$delete(`experiments/${id}`)
  }
}