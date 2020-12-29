import { axios } from '../index.js';

export default {

  getAssessmentWork(id:number) {
    return axios.$get(`assessments/${id}`)
  },

  update(id:number, body:Object) {
    return axios.$post(`assessments/${id}`, body)
  }
}