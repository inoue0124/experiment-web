import { axios } from '../index.js';

export default {

  getTFacesheet(id:number) {
    return axios.$get(`facesheets/${id}`)
  },

  listDFacesheets() {
    return axios.$get(`facesheets`)
  },

  createDFacesheet(id:number, body:Object) {
    return axios.$post(`facesheets`, body)
  }
}