This is a repo containing the first 3 tasks of the assignment.
The helm repo can be found at https://github.com/Mungari/helm-webapp-demo

How to run the assignments:
1. For the shell script run them without parameters to get an overview what arguments it needs to run.
2. For the ansible playbook you can either provide tags ``modify_file, install_package or restart_service`` to run the tasks individually or the entire playbook. Note: install the roles with ``ansible-galaxy install -r roles/requirements.yml``

Important notes:
1. the check_disk script accepts a file extension, and only one. For time constraints I couldn't add more, but it can be modified as needed.
2. the check_rest sript assumes that a successful request only happens on a 200, 301 or 302 return code. It can be modified as needed.
3. the ansible playbook provides an option to either modify the entire line of a file or just the string called ``replace_mode``. If set to true it will only replace the string, if set to false or omitted it will change the entire line.