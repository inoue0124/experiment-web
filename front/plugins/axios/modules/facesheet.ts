import { axios } from '../index.js';

export default {

  getTFacesheet(id:number) {
    return axios.$get(`facesheets/${id}`)
  },

  getDFacesheet(id:number,) {
    return axios.$get(`facesheets/data/${id}`)
  },

  listDFacesheets() {
    return axios.$get(`facesheets`)
  },

  createDFacesheet(id:number, body:Object) {
    return axios.$post(`facesheets/${id}`, body)
  },

  updateDFacesheet(id:number, body:Object) {
    return axios.$put(`facesheets/${id}`, body)
  }
}