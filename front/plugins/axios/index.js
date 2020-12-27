export let axios;
export default ({ store, $axios, $toast }) => {

  $axios.defaults.baseURL = 'http://localhost:3000/'

  $axios.onRequest(config => {
    // config.headers.common['Authorization'] = `Bearer token`;
    config.headers.common['Accept'] = 'application/json';
    config.withCredentials = true;
  });

  $axios.onResponse(response => {
    return Promise.resolve(response);
  })

  $axios.onError(error => {
    $toast.error(error)
    return Promise.reject(error.response);
  });

  axios = $axios;
}