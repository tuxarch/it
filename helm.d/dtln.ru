kubectl delete deployment tiller-deploy -n kube-system
kubectl delete service tiller-deploy -n kube-system
kubectl delete secret tiller-secret -n kube-system

  - name: Init Helm
    run_once: true
    shell: /usr/local/bin/helm init --tiller-tls --tiller-tls-cert /home/{{ ansible_user }}/HELM-CA/tiller.cert.pem --tiller-tls-key /home/{{ ansible_user }}/HELM-CA/tiller.key.pem --tiller-tls-verify --tls-ca-cert /home/{{ ansible_user }}/HELM-CA/ca.cert.pem --service-account=tiller


