FROM quay.io/operator-framework/ansible-operator:v1.28.1

USER root
RUN yum install openssl git -y \
    && curl -fsSL -o - https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash \
    && helm plugin install https://github.com/databus23/helm-diff \
    && helm plugin install https://github.com/aslafy-z/helm-git

USER 1001

COPY requirements.yml ${HOME}/requirements.yml
RUN ansible-galaxy collection install -r ${HOME}/requirements.yml \
 && chmod -R ug+rwx ${HOME}/.ansible

COPY watches.yaml ${HOME}/watches.yaml
COPY roles/ ${HOME}/roles/
COPY playbooks/ ${HOME}/playbooks/
