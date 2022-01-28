Copy ssh key to server-0 since it will be used as Ansible host.

SSH into server-0 and install required packages

    yum install -y git python3

Clone this repo

    git clone https://github.com/ztzxt/k8s-consul-challenge.git


Intall requirements.txt

    pip3 install -r requirements.txt

Edit ```ansible/inventory.ini```

CD into ansible directory and run playbooks 
    
    cd ansible
    ansible-playbook -i inventory.ini site.yaml --ask-vault-pass


Vault is used for ```ansible/group_vars/all/secret.yaml```. You can delete this file and create new secrets with ```ansible-vault create ansible/group_vars/all/secret.yaml``` The file contains those variables:

- grafana_admin_password
- gitlab_password
- gitlab_token

Although not complete, draft for a tool (or at least for the part that select services) that creates dynamic nginx configuration is prepared. Tool utilizes kubernetes client API library and kubeconfig file to get services with desired annotation. I name the tool as 'nginerate'. It is tested with local kind clusters. Code can be found below:

``` Python
    from kubernetes import client, config

    def find_service(desired_annotation, desired_annotation_value, cluster_indicator='kind-cluster'):
        service_list = []
        contexts, _ = config.list_kube_config_contexts()

        for context in contexts:
            context_name = context['name']
            if cluster_indicator in context_name:
                config.load_kube_config(context=context_name)
                v1 = client.CoreV1Api()
                services = v1.list_service_for_all_namespaces(watch=False)
                for service in services.items:
                    #Also get IP info for routing
                    annotations = service.metadata.annotations
                    if annotations and (desired_annotation in annotations):
                        if annotations[desired_annotation] == desired_annotation_value:
                            service_info = {
                                'name': service.metadata.name,
                                'context_name': context_name,
                                'type': service.spec.type,
                            }

                            service_list.append(service_info)
        return service_list

    find_service('nginerate.io/enabled', 'true')
```