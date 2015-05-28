{% set jenkins = pillar.get('jenkins', {}) -%}
{% set home = jenkins.get('home', '/usr/local/jenkins') -%}

{% for pluginName in ['greenballs'] %}

jenkins.plugin.{{ pluginName }}:
  cmd.run:
    - name: "java -jar {{ home }}/jenkins-cli.jar -s http://localhost:8080 install-plugin {{ pluginName }} -restart && sleep 15"
    - watch_in:
      - module: jenkins-restart
    - require:
      - pkg: jenkins

{% endfor %}
