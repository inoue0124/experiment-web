import { axios } from '../index.js';

export default {

  getQuestionnaire(id:number) {
    return axios.$get(`questionnaires/${id}`)
  },

  listQuestionnaires() {
    return axios.$get(`questionnaires`)
  }
}