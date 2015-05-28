{% set jenkins = pillar.get('jenkins', {}) -%}
{% set home = jenkins.get('home', '/usr/local/jenkins') -%}

update.jenkins.update.centre:
  cmd.run:
    - name: "sleep 15 && curl -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- http://localhost:8080/updateCenter/byId/default/postBack"
    - require:
      - pkg: curl
      - service: jenkins

curl:
  - pkg.installed

jenkins.plugins.greenballs:
  cmd.run:
    - name: java -jar {{ home }}/jenkins-cli.jar -s http://localhost:8080 install-plugin greenballs
    - watch_in:
      - module: jenkins-restart
    require:
      - pkg: jenkins
      - cmd: update.jenkins.update.centre


