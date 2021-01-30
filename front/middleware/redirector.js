import WorkflowApi from '@/plugins/axios/modules/workflow'

export default function ({ redirect, route }) {
  WorkflowApi.getWork()
  .then((res) => {
    // 正しいワークフローでない時
    if (res.work.name.toLowerCase() !== route.name) {
      return redirect(`/${res.work.name.toLowerCase()}?id=${res.workflow.id}`)
    }
  })
  // 未認証の場合
  .catch(()=>{
    return redirect('/')
  })
}