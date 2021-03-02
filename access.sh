SECRET_NAME="access"
KUBECTL_GET_SECRET=$(kubectl get secret $SECRET | cut -d " " -f 1 | grep -vi "name")
if [[ $SECRET_NAME == $KUBECTL_GET_SECRET ]]
then   
    echo "Secret já existe"
else
cat <<EOF>> access.yaml
apiVersion: v1
kind: Secret
metadata:
    name: $SECRET_NAME
type: Opaque
data:
    AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
EOF
kubectl create -f $SECRET_NAME
rm -f $SECRET_NAME
fi