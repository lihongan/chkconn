#oc create -f https://raw.githubusercontent.com/lihongan/chkconn/main/websrv-ds.yaml
oc get node
oc get pod

for srcpod in $(oc get pod -oname -l name=websrv-ds)
do
  srcpodip=$(oc get $srcpod -o go-template='{{.status.podIP}}')
  node=$(oc get $srcpod -o go-template="{{.spec.nodeName}}")
  echo "checking connection from the $srcpod($srcpodip) on node: $node" 
  ## for podip in $(oc get pod -o go-template='{{range .items}}{{.status.podIP}}{{"\n"}}{{end}}')
  for dstpod in $(oc get pod -oname -l name=websrv-ds)
  do
    dstpodip=$(oc get $dstpod -o go-template='{{.status.podIP}}')
    echo -n "$srcpodip --> $dstpodip: "
    oc exec $srcpod -- curl -sSI $dstpodip:8080 | head -n1
  done
done
