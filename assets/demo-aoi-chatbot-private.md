# Deploy ChatBot Azure OpenAI fully private on top of Fully private ARO cluster

## Deploy FrontEnd App that uses Azure OpenAI

* Clone the demo repository:

```md
git clone https://github.com/rcarrat-AI/aro-azureopenai.git && cd aro-azureopenai
```

* Deploy the FrontEnd App that uses Azure OpenAI:

```md
kubectl apply -k manifests/overlays/ocp
```

## Add Azure OpenAI credentials into Kubernetes secrets

* Export OpenAI_API_KEY and OPENAI_API_BASE:

```md
[aro@aro-rcarrata-jumphost ~]$ export OPENAI_API_KEY="xxx"
[aro@aro-rcarrata-jumphost ~]$ export OPENAI_API_BASE="https://aro-azureopenai.privatelink.openai.azure.com"
export NAMESPACE="aro-azureopenai"
```

* Deploy the secret in the namespace:

```md
cat <<EOF | kubectl apply -n $NAMESPACE -f -
apiVersion: v1
kind: Secret
metadata:
  name: azure-openai
type: Opaque
data:
  OPENAI_API_BASE: $(echo -n "$OPENAI_API_BASE" | base64)
  OPENAI_API_KEY: $(echo -n "$OPENAI_API_KEY" | base64)
EOF
```

* TODO: Fix [SSL verification error](https://stackoverflow.com/questions/76262208/openai-azure-ssl-error-certification-verification-error) using PrivateEndpoint in AzureOpenAI