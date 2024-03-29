export let axios;
export default ({ store, $axios, $toast }) => {

  $axios.defaults.baseURL = 'http://localhost:3000/'
  $axios.defaults.headers.post['Access-Control-Allow-Origin'] = 'http://localhost:8080';

  $axios.onRequest(config => {
    // config.headers.common['Authorization'] = `Bearer token`;
    config.headers.common['Accept'] = 'application/json';
    config.withCredentials = true;
  });

  $axios.onResponse(response => {
    return Promise.resolve(response);
  })

  $axios.onError(error => {
    $toast.error(`エラーが発生しました！エラー内容：${error}`)
    return Promise.reject(error.response);
  });

  axios = $axios;
}