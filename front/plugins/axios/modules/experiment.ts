import { axios } from '../index.js';

export default {
  createExperiment(email:string, password:string, password_confirmation:string) {
    return axios.$post(
      `experiments`,
      {
        email: email,
        password: password,
        password_confirmation: password_confirmation
      }
    )
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