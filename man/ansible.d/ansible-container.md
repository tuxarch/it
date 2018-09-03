## ansible-container


pip install ansible-container

ansible-container init
    Creates a directory ansible with files to get you started. Read the comments, and edit to suit your needs.

--save-conductor-container - пересборк без изменения кондуктор образа
ansible-container install
    Downloads Ansible-Container-ready roles from Ansible Galaxy, and installs them in your project.

ansible-container build
    Creates images from your Ansible playbooks.

ansible-container run
    Launches the containers specified in the orchestration document, container.yml, for testing the built images. The format of container.yml is nearly identical to Docker Compose.
    ansible-container deploy
    Pushes the project's container images to a registry of your choice, and generates a playbook capable of deploying the project on a supported cloud provider.

ansible-container push - отправляем на докер хаб

ansible-container deploy - для выкадки в систему оркестрации
прописываем container.yml параметры для k8s
ansible-container --engine k8s deploy --push-to docker --tag kubernetes
ansible-container --engine openshift depl
ansible-container описывем структуру проекта


Как собирать контейнер из локального проекта!!!!
ansible-galaxy init Role --container-enabled
кладем в папку roles и прописываем необходимый образ в container.yml



# Конфиг файлы
ansible.cfg
container.yml
	добавляем в services - какие-контейнеры запускать
requirement.yml - определяем роли из ansible-galaxy
