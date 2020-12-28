import WorkflowApi from '@/plugins/axios/modules/workflow'

export default function ({ redirect, route }) {
  WorkflowApi.getWork()
  .then((res) => {
    // 正しいワークフローでない時
    if (res.name.toLowerCase() !== route.name) {
      return redirect(`/${res.name.toLowerCase()}`)
    }
  })
  // 未認証の場合
  .catch(()=>{
    return redirect('/login')
  })
}