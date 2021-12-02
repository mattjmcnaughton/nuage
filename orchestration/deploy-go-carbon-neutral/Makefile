install:
	poetry install
	poetry run ansible-galaxy role install -r requirements.yml
	poetry run ansible-galaxy collection install -r requirements.yml

deploy_dev:
	poetry run ansible-playbook playbook.yml --limit environment_development

deploy_prod:
	poetry run ansible-playbook playbook.yml --limit environment_production
