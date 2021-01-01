import { axios } from '../index.js';

export default {

  getAgreement(id:number) {
    return axios.$get(`agreements/${id}`)
  }
}